//
//  GradientView.m
//  CAGradientLayerDemo
//
//  Created by zhangbin on 2018/7/14.
//  Copyright © 2018年 VVEX. All rights reserved.
//

#import "VVEXGradientView.h"

@interface VVEXGradientView()
/// 底部设置了渐变色的View
@property (nonatomic, strong) UIView *backView;
/// 灰色条的View
@property (nonatomic, strong) UIView *topView;
/// 圆点View
@property (nonatomic, strong) UIView *circularView;
/// 记录没个结点坐标的数组
@property (nonatomic, strong) NSMutableArray *nodeXArray;
/// 记录数字的label数组
@property (nonatomic, strong) NSMutableArray *lblArray;
/// 当前选中的位置标记 0~10
@property (nonatomic, assign) NSInteger index;

@end

@implementation VVEXGradientView


/**
 初始化

 @param frame 位置跟大小
 @return GradientView的对象
 */
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.8];
        [self addSubview:self.backView];
        [self addSubview:self.circularView];
        self.backView.frame = CGRectMake(20, 40, frame.size.width - 40, 10);
        self.backView.layer.cornerRadius = 5;
        self.backView.layer.masksToBounds = YES;
        [self setCAGradient];
        [self addSubview:self.topView];
        self.topView.frame = self.backView.frame;
        self.topView.layer.cornerRadius = 5;
        self.topView.layer.masksToBounds = YES;
        
        for (int i = 0; i < 11; ++i) {
            CGFloat marg = self.backView.frame.size.width / 10;
            CGFloat lblWidth = self.backView.frame.size.width / 11;
            CGFloat x = (i) * marg + self.backView.frame.origin.x;
            [self.nodeXArray addObject:@(x)];
            UILabel *lbl = [[UILabel alloc] init];
            lbl.text = [NSString stringWithFormat:@"%d",i];
            lbl.textColor = [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0];
            lbl.font = [UIFont systemFontOfSize:17];
            lbl.textAlignment = NSTextAlignmentCenter;
            [lbl sizeToFit];
            lbl.frame = CGRectMake(x, 5, lblWidth, lbl.bounds.size.height);
            lbl.center = CGPointMake(x, lbl.center.y);
            lbl.tag = 100 + i;
            UITapGestureRecognizer *top = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lblClick:)];
            top.numberOfTapsRequired = 1;
            top.numberOfTouchesRequired = 1;
            lbl.userInteractionEnabled = true;
            [lbl addGestureRecognizer:top];
            [self addSubview:lbl];
            [self.lblArray addObject:lbl];
            if (i != 0 && i != 10) {
                UIView *lineView = [[UIView alloc] init];
                lineView.frame = CGRectMake(x, self.backView.frame.origin.y, 1, 10);
                lineView.backgroundColor = UIColor.whiteColor;
                [self addSubview:lineView];
            }
        }
        [self bringSubviewToFront:self.circularView];
        self.circularView.center = CGPointMake([self.nodeXArray[0] floatValue], self.backView.center.y);
    }
    return self;
}

/**
 View的点击事件，确定点击位置 移动白点
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (CGRectContainsPoint(self.backView.frame, point)) {
        CGFloat topViewX = [self calculationFrame:point.x];
        if (self.delegate && [self.delegate respondsToSelector:@selector(choiceAtIndex:)]) {
            [self.delegate choiceAtIndex:self.index];
        }
        self.circularView.center = CGPointMake(topViewX, self.circularView.center.y);
        self.topView.frame = CGRectMake(topViewX, self.topView.frame.origin.y, (self.backView.frame.size.width - topViewX) + 20 , self.topView.frame.size.height);
    }
}

/**
 数字label的点击手势事件，移动白点
 */
- (void)lblClick:(UITapGestureRecognizer *)tap {

    UILabel *lbl = (UILabel *)tap.view;
    CGFloat topViewX = lbl.center.x;
    for (int i = 0; i< self.lblArray.count; ++i) {
        UILabel *label = self.lblArray[i];
        if ([lbl.text isEqualToString:label.text]) {
            self.index = i;
            label.textColor = [UIColor blackColor];
        } else {
            label.textColor = [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0];
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(choiceAtIndex:)]) {
        [self.delegate choiceAtIndex:self.index];
    }
    self.circularView.center = CGPointMake(topViewX, self.circularView.center.y);
    self.topView.frame = CGRectMake(topViewX, self.topView.frame.origin.y, (self.backView.frame.size.width - topViewX) + 20 , self.topView.frame.size.height);
}

/**
 白点的拖拽手势事件
 */
- (void)panGRAct:(UIPanGestureRecognizer *)rec {
    
    CGPoint point = [rec translationInView:self.backView];
    CGFloat centerX = rec.view.center.x + point.x;
    if (centerX < (self.backView.frame.origin.x + (rec.view.frame.size.width * 0.5))) {
        centerX = self.backView.frame.origin.x + (rec.view.frame.size.width * 0.5);
    }
    if (centerX > (CGRectGetMaxX(self.backView.frame) - (rec.view.frame.size.width * 0.5))) {
        centerX = CGRectGetMaxX(self.backView.frame) - (rec.view.frame.size.width * 0.5);
    }
    rec.view.center = CGPointMake(centerX, rec.view.center.y);
    if (point.x == 0 && point.y == 0) {
        ///移动开始或者结束
        CGFloat x1 =  [self calculationFrame:centerX];
        rec.view.center = CGPointMake(x1, rec.view.center.y);
        if (self.delegate && [self.delegate respondsToSelector:@selector(choiceAtIndex:)]) {
            [self.delegate choiceAtIndex:self.index];
        }
    }
    self.topView.frame = CGRectMake(rec.view.center.x, self.topView.frame.origin.y, (self.backView.frame.size.width - rec.view.center.x) + 20 , self.topView.frame.size.height);
    [rec setTranslation:CGPointZero inView:self.backView];
}

/**
 根据传入的数值计算跟结点中哪个位置最近并返回

 @param x 传入的坐标X值
 @return 返回结点数组中的结点X值
 */
- (CGFloat)calculationFrame:(CGFloat)x {
    
    NSInteger index = 0;
    CGFloat tempX = [self.nodeXArray[0] floatValue];
    for (int i = 0; i < self.nodeXArray.count; ++i) {
        CGFloat tpX = [self.nodeXArray[i] floatValue];
        CGFloat currentX = ABS(tpX - x);
        if (currentX < tempX) {
            tempX = currentX;
            index = i;
        }
    }
    for (int i = 0; i< self.lblArray.count; ++i) {
        UILabel *lb = self.lblArray[i];
        if (i == index) {
            lb.textColor = UIColor.blackColor;
        } else {
            lb.textColor = [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1.0];
        }
    }
    self.index = index;
    return [self.nodeXArray[index] floatValue];
}

/**
 设置渐变色
 */
- (void)setCAGradient {
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.backView.bounds;
    if (self.GradientLeftColor != nil && self.GradientRightColor != nil) {
        gradient.colors = [NSArray arrayWithObjects:
                           (__bridge id)self.GradientLeftColor.CGColor,
                           (__bridge id)self.GradientRightColor.CGColor,
                           nil];
    } else {
        gradient.colors = [NSArray arrayWithObjects:
                           (__bridge id)[UIColor colorWithRed:255/255.0 green:243/255.0 blue:0/255.0 alpha:1.0].CGColor,
                           (__bridge id)[UIColor colorWithRed:1 green:0 blue:0 alpha:1.0].CGColor,
                           nil];
    }
    gradient.startPoint = CGPointZero;
    gradient.endPoint = CGPointMake(1.0, 0);
    [self.backView.layer addSublayer:gradient];
}

- (UIView *)backView {
    
    if (!_backView) {
        _backView = [UIView new];
        _backView.backgroundColor = UIColor.whiteColor;
    }
    return _backView;
}

- (UIView *)topView {
    
    if (!_topView) {
        _topView = [UIView new];
        _topView.backgroundColor = UIColor.lightGrayColor;
    }
    return _topView;
}

- (UIView *)circularView {

    if (!_circularView) {
        _circularView = [UIView new];
        _circularView.frame = CGRectMake(0, 0, 30, 30);
        _circularView.layer.cornerRadius = 15;
        _circularView.backgroundColor = UIColor.whiteColor;
        _circularView.layer.shadowColor = UIColor.blackColor.CGColor;
        _circularView.layer.shadowOffset = CGSizeMake(-5, 5);
        _circularView.layer.shadowRadius = 5;
        UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGRAct:)];
        [_circularView addGestureRecognizer:panGR];
    }
    return _circularView;
}

- (NSMutableArray *)nodeXArray {
    
    if (!_nodeXArray) {
        _nodeXArray = [NSMutableArray arrayWithCapacity:9];
    }
    return _nodeXArray;
}

- (NSMutableArray *)lblArray {
    
    if (!_lblArray) {
        _lblArray = [NSMutableArray array];
    }
    return _lblArray;
}

@end
