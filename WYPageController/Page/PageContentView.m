//
//  PageContentView.m
//  FrameWork
//
//  Created by 陈午阳 on 2018/3/9.
//  Copyright © 2018年 陈午阳. All rights reserved.
//

#import "PageContentView.h"

@interface PageContentView()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong)NSMutableArray *childvcs;
@property (nonatomic,assign)CGFloat startOffSetX;
@property (nonatomic,assign)BOOL isForbidScrollDelegate;
@end

@implementation PageContentView

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _isForbidScrollDelegate = NO;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = self.bounds.size;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

- (void)setupPageContentViewWithChilds:(NSArray *)childs parentController:(UIViewController *)parentController
{
    self.childvcs = [NSMutableArray arrayWithArray:childs];
    //1.将所有子控制器添加到福控制器中
    for (UIViewController *childVC in childs) {
        [parentController addChildViewController:childVC];
    }
    //2.添加UICollectionView 用于在cell中cu存放控制器的view
    [self addSubview:self.collectionView];
    _collectionView.frame = self.bounds;
}

#pragma mark 对外暴露的方法
- (void)setCurrentIndex:(NSInteger)currentIndex
{
    //记录需要禁止执行的代理方法
    self.isForbidScrollDelegate = YES;
    //滚动到合适的位置
    CGFloat offSet = _collectionView.frame.size.width*(CGFloat)currentIndex;
    [_collectionView setContentOffset:CGPointMake(offSet, 0)];
}

#pragma mark UICollectionView datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.childvcs.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *childVC = self.childvcs[indexPath.row];
    UICollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    [cell.contentView addSubview:childVC.view];
    return cell;
}

#pragma mark UICollectionView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.isForbidScrollDelegate = NO;
    int X = scrollView.contentOffset.x;
    int width = scrollView.bounds.size.width;
    if (X % width != 0) {
        int a = X/width;
        self.startOffSetX = width*(a+1);
    }else{
        self.startOffSetX = scrollView.contentOffset.x;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //0.判断是否是点击事件
    if (_isForbidScrollDelegate) {
        return;
    }
    //1.获取需要数据
    CGFloat progress = 0;
    int sourceIndex = 0;
    int targetIndex = 0;

    //2.判断左滑还是右滑
    CGFloat currentOffSetX = scrollView.contentOffset.x;
    CGFloat scrollViewW = scrollView.bounds.size.width;
    if (currentOffSetX>_startOffSetX) {//左滑
        //1.计算progress
        progress = currentOffSetX/scrollViewW-floor(currentOffSetX/scrollViewW);
        //2.计算sourceIndex
        sourceIndex = (int)currentOffSetX/scrollViewW;
        //3.计算targetIndex
        targetIndex = sourceIndex+1;
        if (targetIndex>=_childvcs.count) {
            targetIndex = (int)_childvcs.count-1;
        }
        //4.如果完全滑过去
        if (currentOffSetX-_startOffSetX == scrollViewW) {
            progress = 1;
            targetIndex = sourceIndex;
        }
    }else{//右划
        //1.计算progress
        progress = 1-(currentOffSetX/scrollViewW-floor(currentOffSetX/scrollViewW));
        //2.计算targetIndex
        targetIndex = (int)currentOffSetX/scrollViewW;
        //3.计算sourceIndex
        sourceIndex = targetIndex+1;
        if (sourceIndex>=_childvcs.count) {
            sourceIndex = (int)_childvcs.count-1;
        }
    }

    //3.将progress sourceIndex targetIndex 传递给titleView
    [self.delegate pageContentView:progress sourceIndex:sourceIndex targetIndex:targetIndex];
}


@end
