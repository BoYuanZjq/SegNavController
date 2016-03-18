//
//  PaggingViewController.h
//  CustTabBarViewController
//
//  Created by jianqiangzhang on 16/3/18.
//  Copyright © 2016年 jianqiangzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PdidChangedPageBlock)(NSInteger currentPage);

@interface PaggingViewController : UIViewController

/**
 *  改变页码的回调
 */
@property (nonatomic, copy) PdidChangedPageBlock didChangedPageCompleted;

/**
 *  显示视图controller
 */
@property (nonatomic, strong) NSArray *viewControllers;
/**
 *  标题
 */
@property (nonatomic, strong) NSArray *titles;
/**
 *  获取当前页码
 *
 *  @return 返回当前页码
 */
- (NSInteger)getCurrentPageIndex;

/**
 *  设置当前页面为你想要的页码
 *
 *  @param currentPage 目标页码
 *  @param animated    是否动画的设置
 */
- (void)setCurrentPage:(NSInteger)currentPage animated:(BOOL)animated;

@end
