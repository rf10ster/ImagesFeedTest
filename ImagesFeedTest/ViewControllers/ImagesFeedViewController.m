//
//  ImagesFeedViewController.m
//  ImagesFeedTest
//
//  Created by Aleksey Kiselev on 5/31/18.
//  Copyright © 2018 rf10. All rights reserved.
//

#import "ImagesFeedViewController.h"
#import "ImagesFeedCollectionView.h"

@interface ImagesFeedViewController ()

@property (nonatomic, strong) ImagesFeedCollectionView *collectionView;

@end

@implementation ImagesFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView = [[ImagesFeedCollectionView alloc] init];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.collectionView];
    
    [self setupConstraints];
}

// MARK: - helper methods
- (void)setupConstraints {
    NSDictionary* views = @{@"collectionView" : self.collectionView};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|" options:0 metrics:0 views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collectionView]|" options:0 metrics:0 views:views]];
}
@end
