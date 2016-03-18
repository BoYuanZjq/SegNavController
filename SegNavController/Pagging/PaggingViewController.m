//
//  PaggingViewController.m
//  CustTabBarViewController
//
//  Created by jianqiangzhang on 16/3/18.
//  Copyright © 2016年 jianqiangzhang. All rights reserved.
//

#import "PaggingViewController.h"
#import "SegmentNavBarView.h"

@interface PaggingViewController ()<UIScrollViewDelegate>
/**
 *  显示内容的容器
 */
@property (nonatomic, strong) UIView *centerContainerView;
@property (nonatomic, strong) UIScrollView *paggingScrollView;
/**
 *  标识当前页码
 */
@property (nonatomic, assign) NSInteger currentPage;


/**
 *  显示title集合的容器
 */
@property (nonatomic, strong) SegmentNavBarView *segmentNavbarView;

@end

@implementation PaggingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupViews];
    
    [self reloadData];
    
    [self initSegmentNavbarView];
}
- (void)setupViews {
    [self.view addSubview:self.centerContainerView];
}

- (void)reloadData {
    if (!self.viewControllers.count) {
        return;
    }
    
    [self.paggingScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL *stop) {
        [self addChildViewController:viewController];
        [self.paggingScrollView addSubview:viewController.view];
        CGRect contentViewFrame = viewController.view.bounds;
        contentViewFrame.origin.y = 0;
        contentViewFrame.origin.x = idx * CGRectGetWidth(self.view.bounds);
        contentViewFrame.size.width = CGRectGetWidth(self.view.bounds);
        contentViewFrame.size.height = CGRectGetHeight(self.view.bounds);
        viewController.view.frame = contentViewFrame;
    }];
    
    [self.paggingScrollView setContentSize:CGSizeMake(CGRectGetWidth(self.view.bounds) * self.viewControllers.count, 0)];
    
    [self setupScrollToTop];
}

- (void)initSegmentNavbarView
{
    self.navigationItem.titleView = self.segmentNavbarView;
}

#pragma mark - TableView Helper Method

- (void)setupScrollToTop {
    for (int i = 0; i < self.viewControllers.count; i ++) {
        UITableView *tableView = (UITableView *)[self subviewWithClass:[UITableView class] onView:[self getPageViewControllerAtIndex:i].view];
        if (tableView) {
            if (self.currentPage == i) {
                [tableView setScrollsToTop:YES];
            } else {
                [tableView setScrollsToTop:NO];
            }
        }
    }
}

- (UIView *)subviewWithClass:(Class)cuurentClass onView:(UIView *)view {
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:cuurentClass]) {
            return subView;
        }
    }
    return nil;
}

- (UIViewController *)getPageViewControllerAtIndex:(NSInteger)index {
    if (index < self.viewControllers.count) {
        return self.viewControllers[index];
    } else {
        return nil;
    }
}

- (NSInteger)getCurrentPageIndex {
    return self.currentPage;
}

- (void)setCurrentPage:(NSInteger)currentPage animated:(BOOL)animated {
    self.currentPage = currentPage;
    
    CGFloat pageWidth = CGRectGetWidth(self.paggingScrollView.frame);
    
    CGPoint contentOffset = self.paggingScrollView.contentOffset;
    contentOffset.x = currentPage * pageWidth;
    [self.paggingScrollView setContentOffset:contentOffset animated:animated];
}
- (void)setCurrentPage:(NSInteger)currentPage
{
    if (self.didChangedPageCompleted) {
        self.didChangedPageCompleted(currentPage);
    }
    _currentPage = currentPage;
    [self.segmentNavbarView selectedItemWithIndex:currentPage];
}



#pragma mark - UIScrollView Delegate

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    [self.segmentNavbarView updatePageIndicatorPosition:contentOffsetX];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 得到每页宽度
    CGFloat pageWidth = CGRectGetWidth(self.paggingScrollView.frame);
    
    // 根据当前的x坐标和页宽度计算出当前页数
    self.currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}


#pragma mark - Propertys

- (UIView *)centerContainerView {
    if (!_centerContainerView) {
        _centerContainerView = [[UIView alloc] initWithFrame:self.view.bounds];
        _centerContainerView.backgroundColor = self.view.backgroundColor;
        
        [_centerContainerView addSubview:self.paggingScrollView];
    }
    return _centerContainerView;
}

- (UIScrollView *)paggingScrollView {
    if (!_paggingScrollView) {
        _paggingScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _paggingScrollView.bounces = NO;
        _paggingScrollView.pagingEnabled = YES;
        [_paggingScrollView setScrollsToTop:NO];
        _paggingScrollView.delegate = self;
        _paggingScrollView.showsVerticalScrollIndicator = NO;
        _paggingScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _paggingScrollView;
}

- (SegmentNavBarView *)segmentNavbarView
{
    if (!_segmentNavbarView) {
        _segmentNavbarView = [[SegmentNavBarView alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
        _segmentNavbarView.font = [UIFont systemFontOfSize:15];
        _segmentNavbarView.titleSelectedColor = [UIColor redColor];
        _segmentNavbarView.titleNormalColor = [UIColor blackColor];
        _segmentNavbarView.indicatorColor = [UIColor redColor];
        CGRect ptRect                 = self.segmentNavbarView.frame;
        ptRect.size.width             = [SegmentNavBarView countTitleWidth:_titles withFont:self.segmentNavbarView.font];
        [_segmentNavbarView addItemTitles:_titles];
        _segmentNavbarView.frame = ptRect;
        __weak typeof(self) weakSelf = self;
        _segmentNavbarView.didChangedBarCompleted = ^(NSInteger index) {
            [weakSelf setCurrentPage:index animated:YES];
        };
    }
    return _segmentNavbarView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
