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

@property (nonatomic, assign) CGSize itemSizeConstraints;

@end

NSInteger const AdsAddingMaxDelay = 20;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.viewModel) {
        self.viewModel = [[FeedViewModel alloc] initWithMaxColumns:6 minColumns:1 columns:2];
    }
    
    // FIXME:
//    self.collectionView.footerVisible = self.viewModel.hasMore;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    ((ImagesFeedCollectionViewLayout *)self.collectionView.collectionViewLayout).columns = self.viewModel.currentColumnsCount;
    
    [self addAdsWithDelay:AdsAddingMaxDelay repeat:YES];
    [self fetchItems];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.itemSizeConstraints = self.collectionView.bounds.size;
}

// MARK: - helper methods

- (void)fetchItems {
    __weak typeof(self)weakSelf = self;
    [[FeedApi provider] fetchWithOffset:self.viewModel.nextOffset onSuccess:^(FetchResult *result) {
        weakSelf.viewModel.nextOffset = result.nextOffset;
        weakSelf.viewModel.hasMore = result.hasMore;
        [weakSelf.viewModel addItems:result.feedItems];
    } onFailure:^(NSError *error) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        [weakSelf presentViewController:alertController animated:YES completion:nil];
    }];
}

- (void)addAdsWithDelay:(NSInteger)maxDelay repeat:(BOOL)repeat {
    NSInteger minDelay = 1;
    NSInteger currentDelay = minDelay + arc4random_uniform((uint32_t)(maxDelay - minDelay + 1));
    __weak typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(currentDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (!repeat || !strongSelf) {
            return;
        }
        FeedAdsModel *ads = [[FeedAdsModel alloc] initWithText:[NSString stringWithFormat:@"Ads after %ld", (long)currentDelay]];

        [strongSelf.viewModel addItems:@[ads]];
        
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

// MARK: - UICollectionViewDataSource

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return [self cellFor:indexPath];
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.items.count;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(stopLoading)])
    {
        [cell performSelector:@selector(stopLoading)];
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (self.viewModel.hasMore && [kind isEqualToString:UICollectionElementKindSectionFooter]) {
    }
    return nil;
}

// MARK: - UIScrollViewDelegate

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

// MARK: - FeedViewModelDelegate

- (void)viewModelDidChangeColumns:(NSInteger)columns {
    ((ImagesFeedCollectionViewLayout *)self.collectionView.collectionViewLayout).columns = columns;
    [self.collectionView.collectionViewLayout invalidateLayout];
}

- (void)viewModelDidAddItems:(NSArray<id<FeedItem>> *)items isInitial:(BOOL)isInitial {
    if (isInitial) {
        [self.collectionView reloadData];
        return;
    }
}

@end
