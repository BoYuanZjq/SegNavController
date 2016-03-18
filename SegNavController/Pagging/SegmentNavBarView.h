//
//  SegmentNavBarView.h
//  CustTabBarViewController
//
//  Created by jianqiangzhang on 16/3/18.
//  Copyright © 2016年 jianqiangzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SDidChangeBarBlock)(NSInteger index);

@interface SegmentNavBarView : UIView
@property (nonatomic, strong) UIColor *indicatorColor;
@property (nonatomic, strong) UIColor *titleNormalColor;
@property (nonatomic, strong) UIColor *titleSelectedColor;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, copy) SDidChangeBarBlock didChangedBarCompleted;

- (void)addItemTitles:(NSArray *)titles;

+ (CGFloat)countTitleWidth:(NSArray *)titleArr withFont:(UIFont *)titleFont;

- (void)updatePageIndicatorPosition:(CGFloat)xPosition;

- (void)selectedItemWithIndex:(NSInteger)index;

@end
