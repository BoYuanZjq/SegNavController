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
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setupViews];
    
    [self reloadData];
    
    [self initSegmentNavbarView];
}
- (void)setupViews {
    [self.view addSubview:self.centerContainerView];
    
     NSDictionary* views = NSDictionaryOfVariableBindings(_centerContainerView,_paggingScrollView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_centerContainerView]-0-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_centerContainerView]-0-|" options:0 metrics:nil views:views]];
    
    [_centerContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_paggingScrollView]-0-|" options:0 metrics:nil views:views]];
    [_centerContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_paggingScrollView]-0-|" options:0 metrics:nil views:views]];
}

- (void)reloadData {
    if (!self.viewControllers.count) {
        return;
    }
    
    [self.paggingScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    __block  NSArray* tempvConstraintArray = nil;
    static UIView *tempView = nil;
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL *stop) {
        [self addChildViewController:viewController];
        [self.paggingScrollView addSubview:viewController.view];
        UIView *view = viewController.view;
        view.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary* views;
        if (tempView) {
            views = NSDictionaryOfVariableBindings(view,tempView);
        }else{
            views = NSDictionaryOfVariableBindings(view);
        }
        
        if (idx!=0) {
            if (tempvConstraintArray) {
                [NSLayoutConstraint deactivateConstraints:tempvConstraintArray];
            }
            NSArray* vConstraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:nil views:views];
            [NSLayoutConstraint activateConstraints:vConstraintArray];
            
            
            NSArray* v2ConstraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[view]-0-|" options:0 metrics:nil views:views];
            [NSLayoutConstraint activateConstraints:v2ConstraintArray];
            
            
            NSArray* v4ConstraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"[tempView]-0-[view]" options:0 metrics:nil views:views];
            [NSLayoutConstraint activateConstraints:v4ConstraintArray];
            
            NSLayoutConstraint* imageViewWidthConstraint = [NSLayoutConstraint constraintWithItem:viewController.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_paggingScrollView attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.f];
            
            NSLayoutConstraint* imageViewHeightConstraint = [NSLayoutConstraint constraintWithItem:viewController.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_paggingScrollView attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.f];
            imageViewWidthConstraint.active = YES;
            imageViewHeightConstraint.active = YES;
            tempView = viewController.view;
            tempvConstraintArray = v2ConstraintArray;
            
        }else{
            tempView = viewController.view;
            
            NSArray* vConstraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:nil views:views];
            [NSLayoutConstraint activateConstraints:vConstraintArray];
            
            NSArray* v2ConstraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]" options:0 metrics:nil views:views];
            [NSLayoutConstraint activateConstraints:v2ConstraintArray];
            
            NSLayoutConstraint* imageViewWidthConstraint = [NSLayoutConstraint constraintWithItem:viewController.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_paggingScrollView attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.f];
            NSLayoutConstraint* imageViewHeightConstraint = [NSLayoutConstraint constraintWithItem:viewController.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_paggingScrollView attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.f];
            imageViewWidthConstraint.active = YES;
            imageViewHeightConstraint.active = YES;
        }
        
//        CGRect contentViewFrame = viewController.view.bounds;
//        contentViewFrame.origin.y = 0;
//        contentViewFrame.origin.x = idx * CGRectGetWidth(self.view.bounds);
//        contentViewFrame.size.width = CGRectGetWidth(self.view.bounds);
//        contentViewFrame.size.height = CGRectGetHeight(self.view.bounds);
//        viewController.view.frame = contentViewFrame;
    }];
    
    //[self.paggingScrollView setContentSize:CGSizeMake(CGRectGetWidth(self.view.bounds) * self.viewControllers.count, 0)];
    
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
        _centerContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        _centerContainerView.backgroundColor = self.view.backgroundColor;
        
        [_centerContainerView addSubview:self.paggingScrollView];
        _centerContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _centerContainerView;
}

- (UIScrollView *)paggingScrollView {
    if (!_paggingScrollView) {
        _paggingScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _paggingScrollView.bounces = NO;
        _paggingScrollView.backgroundColor = [UIColor whiteColor];
        _paggingScrollView.pagingEnabled = YES;
        [_paggingScrollView setScrollsToTop:NO];
        _paggingScrollView.delegate = self;
        _paggingScrollView.showsVerticalScrollIndicator = NO;
        _paggingScrollView.showsHorizontalScrollIndicator = NO;
        _paggingScrollView.translatesAutoresizingMaskIntoConstraints = NO;
        
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
