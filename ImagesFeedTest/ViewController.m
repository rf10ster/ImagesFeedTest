//
//  ViewController.m
//  ImagesFeedTest
//
//  Created by Aleksey Kiselev on 5/31/18.
//  Copyright © 2018 rf10. All rights reserved.
//

#import "ViewController.h"
#import "ImagesFeedCollectionView.h"
#import "FeedAdsModel.h"
#import "FeedItemModel.h"
#import "FeedApi.h"
#import "BaseCollectionViewCell.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *removeColumnsButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addColumnsButton;
@property (nonatomic, weak) IBOutlet ImagesFeedCollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
    
@property (nonatomic, assign) CGSize itemSizeConstraints;

@end

NSInteger const AdsAddingMaxDelay = 20;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.viewModel) {
        self.viewModel = [[FeedViewModel alloc] initWithMaxColumns:5 minColumns:1 columns:2];
    }
    self.viewModel.delegate = self;

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    ((UIScrollView *)self.collectionView).delegate = self;

    self.collectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    ImagesFeedCollectionViewLayout *clayout = (ImagesFeedCollectionViewLayout *)self.collectionView.collectionViewLayout;
    clayout.delegate = self;
    clayout.numberOfColumns = self.viewModel.currentColumnsCount;
    clayout.cellPadding = 6;
    
    [self addAdsWithDelay:AdsAddingMaxDelay repeat:YES];
    [self fetchItems];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.itemSizeConstraints = self.collectionView.bounds.size;
}
- (IBAction)removeColumns:(id)sender {
    [self.viewModel removeColumn];
}
- (IBAction)addColumns:(id)sender {
    [self.viewModel addColumn];
}
    
// MARK: - helper methods

- (void)fetchItems {
    [self.activityView startAnimating];
    __weak typeof(self)weakSelf = self;
    [[FeedApi provider] fetchWithOffset:self.viewModel.nextOffset onSuccess:^(FetchResult *result) {
        weakSelf.viewModel.nextOffset = result.nextOffset;
        weakSelf.viewModel.hasMore = result.hasMore;
        [weakSelf.viewModel addItems:result.models];
        [weakSelf.activityView stopAnimating];
    } onFailure:^(NSError *error) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [weakSelf presentViewController:alertController animated:YES completion:nil];
        [weakSelf.activityView stopAnimating];
    }];
}
    


- (void)addAdsWithDelay:(NSInteger)maxDelay repeat:(BOOL)repeat {
    NSInteger minDelay = maxDelay/2;
    NSInteger currentDelay = minDelay + arc4random_uniform((uint32_t)(maxDelay - minDelay + 1));
    __weak typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(currentDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (!repeat || !strongSelf) {
            return;
        }
        FeedAdsModel *ads = [[FeedAdsModel alloc] initWithText:[NSString stringWithFormat:@"Ads after %ld", (long)currentDelay]];

        [strongSelf.viewModel insertItem:ads withinRange:NSMakeRange(0, strongSelf.viewModel.items.count)];
        
        [strongSelf addAdsWithDelay:AdsAddingMaxDelay repeat:YES];
    });
}

- (UICollectionViewCell *)cellFor:(nonnull NSIndexPath *)indexPath {
    id<FeedItem> item = [self.viewModel itemFor:indexPath];
    if (!item) {
        // fatal error
        return [UICollectionViewCell new];
    }
    NSString *reuseIdentifier = nil;
    switch (item.itemType) {
        case FeedItemTypeFeed:
            reuseIdentifier = @"FeedItemCollectionViewCell";
            break;
        case FeedItemTypeAds:
            reuseIdentifier = @"AdsCollectionViewCell";
            break;    }
    BaseCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell updateWith:item];
    return cell;
}
    
// MARK: - ImagesFeedCollectionViewLayoutDelegate
    
- (CGSize)collectionView:(UICollectionView *)collectionView sizeForItemAt:(NSIndexPath *)IndexPath constraints:(CGSize)constraints {
    id<FeedItem> item = [self.viewModel itemFor:IndexPath];
    switch (item.itemType) {
        case FeedItemTypeAds:
        return CGSizeMake(constraints.width, constraints.width);
        case FeedItemTypeFeed:
        {
            FeedItemModel *model = (FeedItemModel *)item;
            CGFloat oldWidth = model.imageSize.width;
            CGFloat scaleFactor = constraints.width / oldWidth;
            CGFloat newHeight = model.imageSize.height * scaleFactor;
            CGFloat newWidth = oldWidth * scaleFactor;
            return CGSizeMake(newWidth, newHeight);
        }
    }
}

// MARK: - UICollectionViewDataSource

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return [self cellFor:indexPath];
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.items.count;
}

// MARK: - UIScrollViewDelegate - not called ???
// alternative apploach for fetch next is:
// sectionFooterVisible = self.viewModel.hasMore;
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (!self.viewModel.hasMore) {
        return;
    }
    if (!scrollView.dragging && !scrollView.decelerating) {
        return;
    }
    CGFloat scrollViewHeight = scrollView.bounds.size.height;
    CGFloat contentHeight = scrollView.contentSize.height;
    if (contentHeight < scrollViewHeight) {
        return;
    }
    if ((contentHeight - scrollView.contentOffset.y) < scrollViewHeight * 2) {
        // fetch next
        [self fetchItems];
    }
    
}
    
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item > (self.viewModel.items.count - 1 - self.viewModel.currentColumnsCount)) {
        // before last row appeared
        // fetch next
        [self fetchItems];
    }
}

// MARK: - FeedViewModelDelegate

- (void)viewModelDidChangeColumns:(NSInteger)columns completed:(void (^)(void))completed {
    //[self.collectionView scrollRectToVisible:CGRectZero animated:NO];
    [self.collectionView.collectionViewLayout invalidateLayout];
    ((ImagesFeedCollectionViewLayout *)self.collectionView.collectionViewLayout).numberOfColumns = columns;
    [self.collectionView reloadData];
    completed();
}

- (void)viewModelDidAddItemsAt:(NSIndexSet *)indexes completed:(void (^)(void))completed {
    BOOL isInitial = self.viewModel.items.count == indexes.count;
    if (isInitial) {
        [self.collectionView reloadData];
        completed();
        return;
    }
    @try {
        NSMutableArray<NSIndexPath *> *indexPaths = [[NSMutableArray alloc] initWithCapacity:indexes.count];
        NSInteger section = self.viewModel.sections - 1;
        [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
           [indexPaths addObject:[NSIndexPath indexPathForItem:idx inSection:section]];
        }];
        [self.collectionView performBatchUpdates:^{
            [self.collectionView insertItemsAtIndexPaths:indexPaths];
        } completion:^(BOOL finished) {
            completed();
        }];
    } @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
        [self.collectionView.collectionViewLayout invalidateLayout];
        [self.collectionView reloadData];
        completed();
    }
}

@end
