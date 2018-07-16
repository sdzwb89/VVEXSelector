//
//  GradientView.h
//  CAGradientLayerDemo
//
//  Created by zhangbin on 2018/7/14.
//  Copyright © 2018年 VVEX. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VVEXGradientViewDelegate <NSObject>

- (void)choiceAtIndex:(NSInteger)index;

@end


@interface VVEXGradientView : UIView

/**
 渐变色的左边颜色
 */
@property (nonatomic, strong) UIColor *GradientLeftColor;

/**
 渐变色的右边颜色
 */
@property (nonatomic, strong) UIColor *GradientRightColor;

/**
 选择之后的代理
 */
@property (nonatomic, weak) id<VVEXGradientViewDelegate> delegate;

@end
