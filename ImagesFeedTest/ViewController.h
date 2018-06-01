//
//  ViewController.h
//  ImagesFeedTest
//
//  Created by Aleksey Kiselev on 5/31/18.
//  Copyright © 2018 rf10. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedViewModel.h"
#import "ImagesFeedCollectionViewLayout.h"

@interface ViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource, ImagesFeedCollectionViewLayoutDelegate, FeedViewModelDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) FeedViewModel *viewModel;

@end

