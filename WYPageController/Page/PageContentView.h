//
//  PageContentView.h
//  FrameWork
//
//  Created by 陈午阳 on 2018/3/9.
//  Copyright © 2018年 陈午阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PageContentDelegate
- (void)pageContentView:(CGFloat)progress sourceIndex:(int)sourceIndex targetIndex:(int)targetIndex;
@end

@interface PageContentView : UIView
@property (nonatomic,assign)id<PageContentDelegate> delegate;

@property (nonatomic,strong)UICollectionView *collectionView;

- (void)setupPageContentViewWithChilds:(NSArray *)childs parentController:(UIViewController *)parentController;

- (void)setCurrentIndex:(NSInteger)currentIndex;
@end
