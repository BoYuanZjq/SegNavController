//
//  SegmentNavBarView.m
//  CustTabBarViewController
//
//  Created by jianqiangzhang on 16/3/18.
//  Copyright © 2016年 jianqiangzhang. All rights reserved.
//

#import "SegmentNavBarView.h"
@interface SegmentNavBarView()

@property (nonatomic, strong) NSMutableArray *titleLabelViews;
@property (nonatomic, strong) UIView *pageIndicator;
@property (nonatomic, strong) NSArray *titleArray;

@end

static CGFloat kTitleMargin = 50;

@implementation SegmentNavBarView

- (id)init
{
    if (self = [super init]) {
        self.titleLabelViews = [NSMutableArray array];
        [self addSubview:self.pageIndicator];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabelViews = [NSMutableArray array];
        [self addSubview:self.pageIndicator];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.titleLabelViews = [NSMutableArray array];
        [self addSubview:self.pageIndicator];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect idRect            = self.pageIndicator.frame;
    idRect.origin.y          = self.frame.size.height - 5;
    __block CGFloat viewWidth = 0.0;
    [self.titleLabelViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        [view sizeToFit];
        CGSize size       = view.frame.size;
        size.width        = self.frame.size.width;
        viewWidth = size.width/self.titleArray.count;
        view.frame = CGRectMake(viewWidth*idx, 0, viewWidth, size.height*2);
    }];
    idRect.size.width = viewWidth;
    self.pageIndicator.frame = idRect;
    [self selectedItemWithIndex:0];
}

- (void)addItemTitles:(NSArray *)titles
{
    self.titleArray = titles;
    [self.titleLabelViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.titleLabelViews removeAllObjects];
    __weak typeof(self) weakself = self;
    [titles enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
        if ([object isKindOfClass:[NSString class]]) {
            UILabel *textLabel                   = [[UILabel alloc] init];
            textLabel.backgroundColor = [UIColor clearColor];
            textLabel.text                       = object;
            textLabel.tag                        = idx;
            textLabel.textAlignment              = NSTextAlignmentCenter;
            textLabel.font                       = self.font;
            textLabel.userInteractionEnabled     = YES;
            UITapGestureRecognizer *tapTextLabel = [[UITapGestureRecognizer alloc] initWithTarget:weakself action:@selector(didTapTextLabel:)];
            [textLabel addGestureRecognizer:tapTextLabel];
            [weakself addSubview:textLabel];
            [weakself.titleLabelViews addObject:textLabel];
        }
    }];

}

+ (CGFloat)countTitleWidth:(NSArray *)titleArr withFont:(UIFont *)titleFont
{
    return [self getMaxTitleWidthFromArray:titleArr withFont:titleFont] * titleArr.count + kTitleMargin *(titleArr.count-1);
}
+ (CGFloat)getMaxTitleWidthFromArray:(NSArray *)titleArray withFont:(UIFont *)titleFont
{
    CGFloat maxWidth = 0;
    for (int i = 0; i < titleArray.count; i++) {
        NSString *titleString = [titleArray objectAtIndex:i];
        CGFloat titleWidth    = [titleString sizeWithAttributes:@{NSFontAttributeName:titleFont}].width;
        if (titleWidth > maxWidth) {
            maxWidth = titleWidth;
        }
    }
    return maxWidth;
}


- (void)updatePageIndicatorPosition:(CGFloat)xPosition
{
    CGFloat screenWidth            = [[UIScreen mainScreen]bounds].size.width;
    CGFloat pageIndicatorXPosition = ((xPosition/screenWidth) * (self.frame.size.width - self.pageIndicator.frame.size.width))/(self.titleArray.count - 1);
    CGRect idRect                  = self.pageIndicator.frame;
    idRect.origin.x                = pageIndicatorXPosition;
    self.pageIndicator.frame       = idRect;
}

- (void)selectedItemWithIndex:(NSInteger)index
{
    for (UILabel *textLabel in self.subviews) {
        if ([textLabel isKindOfClass:[UILabel class]]) {
            textLabel.textColor = self.titleNormalColor ? : [UIColor colorWithWhite:0.675 alpha:1.000];
            if (textLabel.tag == index) {
                textLabel.textColor =  self.titleSelectedColor ? : [UIColor blackColor];
            }
        }
    }
}

- (void)didTapTextLabel:(UITapGestureRecognizer*)gesture
{
    
    if (self.didChangedBarCompleted) {
        self.didChangedBarCompleted(gesture.view.tag);
    }
}

- (UIView *)pageIndicator
{
    if (!_pageIndicator) {
        _pageIndicator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 5)];
    }
    _pageIndicator.backgroundColor = self.indicatorColor;
    return _pageIndicator;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
