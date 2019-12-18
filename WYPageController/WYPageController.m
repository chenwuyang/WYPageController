//
//  WYPageController.m
//  WYPageController
//
//  Created by 陈午阳 on 2019/12/18.
//  Copyright © 2019 陈午阳. All rights reserved.
//

#import "WYPageController.h"
#import "UIColor+RGB.h"
#import "PageTitleView.h"
#import "PageContentView.h"
#import "WYPageBaseController.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavBarHeight 44.0
#define kTopHeight (kStatusBarHeight + kNavBarHeight)
#define kTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
#define kBottomSafeHeight         (iPhoneX ? 34.f : 0.f)


#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]



@interface WYPageController ()<PageTitleViewDelegate,PageContentDelegate>
@property (nonatomic,strong)PageTitleView *pageTitleView;
@property (nonatomic,strong)PageContentView *pageContentView;
@property (nonatomic,strong)NSMutableArray *controllers;
@end

@implementation WYPageController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);

    self.navigationItem.title = @"你好";

    self.controllers = [NSMutableArray new];

    [self.view addSubview:self.pageTitleView];

    [self.view addSubview:self.pageContentView];

}

/**
 懒加载titleView
 */
- (PageTitleView *)pageTitleView
{
    if (!_pageTitleView) {
        NSArray *titles = @[@"全部",@"待付款",@"待发货",@"待收货",@"已完成"];
        _pageTitleView = [[PageTitleView alloc] initWithFrame:CGRectMake(0, kTopHeight, kScreenWidth, 44)];
        _pageTitleView.showTopLine = NO;
        _pageTitleView.lineColor = UIColorFromRGB(0xFF4A2D);
        _pageTitleView.backgroundColor = [UIColor whiteColor];
        _pageTitleView.delegate = self;
        _pageTitleView.fontSize = 15;
        _pageTitleView.normalTitleColor = UIColorFromRGB(0x666666);
        _pageTitleView.selectTitleColor = UIColorFromRGB(0xFF4A2D);
        _pageTitleView.index = 0;
        _pageTitleView.scrollLineWidth = 30;
        [_pageTitleView setupPageTitleWithTitles:titles];
    }
    return _pageTitleView;
}


/**
 懒加载xontentView
 */
- (PageContentView *)pageContentView
{
    if (!_pageContentView) {
        _pageContentView = [[PageContentView alloc] initWithFrame:CGRectMake(0, kTopHeight+44, kScreenWidth, kScreenHeight-44-kTopHeight-kStatusBarHeight)];
        _pageContentView.delegate = self;
        for (int i = 0; i<5; i++) {
            WYPageBaseController *pageBaseVC = [[WYPageBaseController alloc] init];
            [self.controllers addObject:pageBaseVC];
        }
        [_pageContentView setupPageContentViewWithChilds:self.controllers parentController:self];
    }

    return _pageContentView;
}

#pragma mark 遵守PageTitleViewDelegate
- (void)pageTitleView:(NSInteger)index
{
    [_pageContentView setCurrentIndex:index];
}

#pragma mark 遵守PageContentDelegate
- (void)pageContentView:(CGFloat)progress sourceIndex:(int)sourceIndex targetIndex:(int)targetIndex
{
    [_pageTitleView setupTitleWithProgress:progress sourceIndex:sourceIndex targetIndex:targetIndex];
}


@end
