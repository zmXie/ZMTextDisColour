//
//  ZMBezierPathView.m
//  ZMTextDiscolour
//
//  Created by CHT-Technology on 2017/4/28.
//  Copyright © 2017年 CHT-Technology. All rights reserved.
//

#import "ZMBezierPathView.h"

@implementation ZMBezierPathView

- (void)drawRect:(CGRect)rect{
    
    [[UIColor redColor] setStroke];
    [[UIColor greenColor] setFill];
    //椭圆
    [self addPath:
     [UIBezierPath bezierPathWithRoundedRect:CGRectMake(20, 20, 100, 50) cornerRadius:25]];
    //矩形
    [self addPath:
     [UIBezierPath bezierPathWithRect:CGRectMake(140, 20, 100, 50)]];
    //内切椭圆
    [self addPath:
     [UIBezierPath bezierPathWithOvalInRect:CGRectMake(260, 20, 100, 50)]];

    //换色
    [[UIColor lightGrayColor] setStroke];
    [[UIColor blueColor] setFill];
    //圆
    [self addPath:
     [UIBezierPath bezierPathWithOvalInRect:CGRectMake(20, 90, 100, 100)]];
    //左上右下圆角
    [self addPath:
     [UIBezierPath bezierPathWithRoundedRect:CGRectMake(140, 90, 100, 100) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(50, 0)]];
    //圆弧
    UIBezierPath*cPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(310, 140) radius:50 startAngle:M_PI_2 endAngle:0 clockwise:YES];
    cPath.lineWidth = 4;
    [cPath stroke];
    
    //换色
    [[UIColor purpleColor] setStroke];
    [[UIColor orangeColor] setFill];
    //扇形
    UIBezierPath *sPath = [UIBezierPath bezierPath];
    [sPath moveToPoint:CGPointMake(70, 260)];
    [sPath addArcWithCenter:CGPointMake(70, 260) radius:50 startAngle:-M_PI*2/3.f endAngle:-M_PI_4 clockwise:YES];
    [self addPath:sPath];
    [sPath closePath];
    //二次贝塞尔
    UIBezierPath *towPath = [UIBezierPath bezierPath];
    [towPath moveToPoint:CGPointMake(150, 210)];
    [towPath addQuadCurveToPoint:CGPointMake(150, 310) controlPoint:CGPointMake(250, 260)];
    [towPath stroke];
    //三次贝塞尔
    UIBezierPath *trePath = [UIBezierPath bezierPath];
    [trePath moveToPoint:CGPointMake(260, 260)];
    [trePath addCurveToPoint:CGPointMake(360, 260) controlPoint1:CGPointMake(285, 210) controlPoint2:CGPointMake(335, 310)];
    [trePath stroke];
    //交汇圆
    UIBezierPath *yPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(20, 330, 100, 100)];
    [yPath appendPath:[UIBezierPath bezierPathWithOvalInRect:CGRectMake(80, 330, 100, 100)]];
    yPath.usesEvenOddFillRule = YES;
    [self addPath:yPath];
    
}

- (void)addPath:(UIBezierPath *)path{
    
    path.lineWidth = 4;
    [path stroke];
    [path fill];
}


@end
