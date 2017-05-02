//
//  ZMDiscolourView.m
//  ZMTextDiscolour
//
//  Created by CHT-Technology on 2017/4/28.
//  Copyright © 2017年 CHT-Technology. All rights reserved.
//

#import "ZMDiscolourView.h"

@interface ZMDiscolourView (){
    
    CATextLayer *_bLayer;
    CATextLayer *_tLayer;
}

@end

@implementation ZMDiscolourView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _bLayer = [self getTextLayerWithFrame:self.bounds
                                                   string:@"这是一串华丽的字符串"
                                                textColor:[UIColor whiteColor]
                                                 fontSize:18];
        [self.layer addSublayer:_bLayer];
        
        
        _tLayer = [self getTextLayerWithFrame:_bLayer.frame
                                                   string:_bLayer.string
                                                textColor:[UIColor greenColor]
                                                 fontSize:_bLayer.fontSize];
        [self.layer addSublayer:_tLayer];
        
        CALayer *mask = [CALayer layer];
        mask.frame = CGRectMake(-_tLayer.bounds.size.width, 0, _tLayer.bounds.size.width, _tLayer.bounds.size.height);
        mask.backgroundColor = [UIColor redColor].CGColor;
        _tLayer.mask = mask;
        [self addAnimationWithLayer:mask];
       
        
    }
    return self;
}

- (CATextLayer *)getTextLayerWithFrame:(CGRect)frame
                                string:(NSString *)string
                             textColor:(UIColor*)tColor
                              fontSize:(CGFloat)fontSize{
    
    CATextLayer *tLayer = [CATextLayer layer];
    tLayer.foregroundColor =tColor.CGColor;
    tLayer.frame = frame;
    tLayer.string = string;
    tLayer.fontSize = fontSize;
    tLayer.alignmentMode = kCAAlignmentCenter;
    return tLayer;
    
}

- (void)addAnimationWithLayer:(CALayer *)layer{
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.toValue = [NSValue valueWithCGPoint:self.center];
    animation.repeatCount = CGFLOAT_MAX;

    animation.duration = 2.f;
    [layer addAnimation:animation forKey:@"mask.bounds"];
}

@end
