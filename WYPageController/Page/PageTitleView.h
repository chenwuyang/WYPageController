//
//  PageTitleView.h
//  FrameWork
//
//  Created by 精英海淘 on 2018/3/8.
//  Copyright © 2018年 陈午阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PageTitleViewDelegate <NSObject>
- (void)pageTitleView:(NSInteger)index;
@end

@interface PageTitleView : UIView
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,weak)id<PageTitleViewDelegate> delegate;

//正常标题颜色
@property (nonatomic,strong)UIColor * normalTitleColor;
//选中标题颜色
@property (nonatomic,strong)UIColor * selectTitleColor;
//划线颜色
@property (nonatomic,strong)UIColor * lineColor;
//滑线的宽度
@property (nonatomic,assign)CGFloat   scrollLineWidth;
//默认选中index
@property (nonatomic,assign)NSInteger index;
//标题字体大小
@property (nonatomic,assign)CGFloat   fontSize;
//是否显示头部线 default   YES
@property (nonatomic,assign)BOOL      showTopLine;

//创建视图
- (void)setupPageTitleWithTitles:(NSArray *)titles;

- (void)setupTitleWithProgress:(CGFloat)progress sourceIndex:(int)sourceIndex targetIndex:(int)targetIndex;
@end
