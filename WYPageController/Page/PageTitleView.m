//
//  PageTitleView.m
//  FrameWork
//
//  Created by 精英海淘 on 2018/3/8.
//  Copyright © 2018年 陈午阳. All rights reserved.
//

#import "PageTitleView.h"
#import "UIColor+RGB.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#define UIColorHex(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface PageTitleView()
@property (nonatomic,strong)UIView *scrollLine;
@property (nonatomic,strong)NSMutableArray *titleLables;//保存所有titleLable的数组
@property (nonatomic,assign)NSInteger currentIndex;
@end

@implementation PageTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.showTopLine = YES;
        self.index = 0;
        self.scrollLineWidth = 100;
        self.fontSize = 14;
    }
    return self;
}

//懒加载scrollview
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetHeight(self.frame));
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
        _scrollView.pagingEnabled = NO;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

//懒加载scrollLine
- (UIView *)scrollLine
{
    if (!_scrollLine) {
        _scrollLine = [[UIView alloc] init];
        _scrollLine.backgroundColor = self.lineColor;
    }
    return _scrollLine;
}

//根据标题类容创建视图
- (void)setupPageTitleWithTitles:(NSArray *)titles
{
    self.currentIndex = self.index;
    
    [self addSubview:self.scrollView];
    

    self.titleLables = [NSMutableArray new];

    //创建titleLable
    [self setupTitleLableWithTitles:titles];

    //创建bottomLine和scrollLine
    [self setupBottomLineAndScrollLine];
    
    //创建顶部线条
    if(self.showTopLine)
    {
         [self setupTopLine];
    }
   
}

- (void)setupTopLine
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    lineView.backgroundColor = UIColorHex(0xe0e0e0);
    [self addSubview:lineView];
}


- (void)setupTitleLableWithTitles:(NSArray *)titles
{
    CGFloat kLableW;
    kLableW = kScreenWidth/(titles.count);
    _scrollView.contentSize = CGSizeMake(kScreenWidth, CGRectGetHeight(self.frame));

    for (int i=0; i<titles.count; i++) {
        UILabel *lable = [[UILabel alloc] init];
        [self.titleLables addObject:lable];
        lable.frame = CGRectMake(kLableW*i, 0, kLableW, CGRectGetHeight(self.frame)-2);
        lable.text = titles[i];
        lable.tag = i;
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = self.normalTitleColor;
        lable.font = [UIFont boldSystemFontOfSize:self.fontSize];
        [self.scrollView addSubview:lable];

        lable.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLableClick:)];
        [lable addGestureRecognizer:tap];
    }
}

- (void)titleLableClick:(UITapGestureRecognizer *)tap
{
    //1.获取当前lable
    UILabel *currentLable;
    if (![tap.view isKindOfClass:[UILabel class]]) {
        return;
    }else{
        currentLable = (UILabel *)tap.view;
    }
    
    //2.获取之前的lable
    UILabel *oldLable = self.titleLables[_currentIndex];

    //3.切换文字颜色和大小
    oldLable.textColor = self.normalTitleColor;
    oldLable.font = [UIFont boldSystemFontOfSize:self.fontSize];
    
    currentLable.textColor = self.selectTitleColor;
    currentLable.font = [UIFont boldSystemFontOfSize:self.fontSize];
    //4.保存最新lable的下标值
    self.currentIndex = currentLable.tag;

    //5.滚动条位置发生改变
    CGFloat halfWidth = (kScreenWidth/(_titleLables.count)-_scrollLineWidth)/2;
    CGFloat scrollLineX = currentLable.tag*(kScreenWidth/(_titleLables.count))+halfWidth;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.15 animations:^{
        weakSelf.scrollLine.frame = CGRectMake(scrollLineX, weakSelf.frame.size.height-3-5, weakSelf.scrollLineWidth, 3);
    }];

    //6.通知代理
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageTitleView:)]) {
        [self.delegate pageTitleView:_currentIndex];
    }
}

- (void)setupBottomLineAndScrollLine
{
    //添加bottomline
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-0.5, kScreenWidth, 0.5)];
    bottomLine.backgroundColor = UIColorHex(0xf5f5f5);
    [self addSubview:bottomLine];

    UILabel *currentLable = self.titleLables[self.currentIndex];
    currentLable.textColor = self.selectTitleColor;
    CGFloat halfWidth = (kScreenWidth/(_titleLables.count)-_scrollLineWidth)/2;
    self.scrollLine.frame = CGRectMake(kScreenWidth/(_titleLables.count)*self.index+halfWidth, self.frame.size.height-3-5, _scrollLineWidth, 3);
    [self.scrollView addSubview:self.scrollLine];

}

//对外暴露的方法
- (void)setupTitleWithProgress:(CGFloat)progress sourceIndex:(int)sourceIndex targetIndex:(int)targetIndex
{
    //1.取出sourceLable/targetLable
    UILabel *sourceLable = _titleLables[sourceIndex];
    UILabel *targetLable = _titleLables[targetIndex];

    //2.处理滑块的逻辑
    CGFloat moveTotalX = targetLable.center.x-sourceLable.center.x;
    CGFloat moveX = moveTotalX * progress;
    self.scrollLine.frame = CGRectMake(sourceLable.center.x-_scrollLineWidth/2+moveX, self.frame.size.height-3-5, _scrollLineWidth, 3);

    //3.处理标题颜色变化
    NSArray *selectRGBArray = [self changeUIColorToRGB:self.selectTitleColor];
    NSArray *normalRGBArray = [self changeUIColorToRGB:self.normalTitleColor];
    double selectR = [[selectRGBArray objectAtIndex:0] doubleValue];
    double selectG = [[selectRGBArray objectAtIndex:1] doubleValue];
    double selectB = [[selectRGBArray objectAtIndex:2] doubleValue];
    double normalR = [[normalRGBArray objectAtIndex:0] doubleValue];
    double normalG = [[normalRGBArray objectAtIndex:1] doubleValue];
    double normalB = [[normalRGBArray objectAtIndex:2] doubleValue];
    sourceLable.textColor = [UIColor colorWithR:(selectR-(selectR-normalR)*progress) G:(selectG-(selectG-normalG)*progress) B:(selectB-(selectB-normalB)*progress)];
    targetLable.textColor = [UIColor colorWithR:(normalR+(selectR-normalR)*progress) G:(normalG+(selectG-normalG)*progress) B:(normalB+(selectB-normalB)*progress)];

    //4.记录最新的index
    _currentIndex = targetIndex;
}

//将UIColor转换为RGB值
- (NSMutableArray *) changeUIColorToRGB:(UIColor *)color
{
    NSMutableArray *RGBStrValueArr = [[NSMutableArray alloc] init];
    NSString *RGBStr = nil;
    //获得RGB值描述
    NSString *RGBValue = [NSString stringWithFormat:@"%@",color];
    //将RGB值描述分隔成字符串
    NSArray *RGBArr = [RGBValue componentsSeparatedByString:@" "];
    //获取红色值
    double r = [[RGBArr objectAtIndex:1] doubleValue] * 255;
    RGBStr = [NSString stringWithFormat:@"%lf",r];
    [RGBStrValueArr addObject:RGBStr];
    //获取绿色值
    double g = [[RGBArr objectAtIndex:2] doubleValue] * 255;
    RGBStr = [NSString stringWithFormat:@"%lf",g];
    [RGBStrValueArr addObject:RGBStr];
    //获取蓝色值
    double b = [[RGBArr objectAtIndex:3] doubleValue] * 255;
    RGBStr = [NSString stringWithFormat:@"%lf",b];
    [RGBStrValueArr addObject:RGBStr];
    //返回保存RGB值的数组
    return RGBStrValueArr;
}




@end
