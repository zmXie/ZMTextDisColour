//
//  ViewController.m
//  ZMTextDiscolour
//
//  Created by CHT-Technology on 2017/4/28.
//  Copyright © 2017年 CHT-Technology. All rights reserved.
//

#import "ViewController.h"
#import "ZMDiscolourView.h"
#import "ZMBezierPathView.h"

@interface ViewController ()<UIScrollViewDelegate>{
    
    UIScrollView *sv;
    CGRect circleRect;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    
    sv = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    sv.delegate = self;
    sv.multipleTouchEnabled=YES; //是否支持多点触控
    sv.minimumZoomScale=1.0;  //表示与原图片最小的比例
    sv.maximumZoomScale=2.5; //表示与原图片最大的比例
    [self.view addSubview:sv];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:sv.bounds];
    imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mt" ofType:@"jpg"]];
    imageView.tag = 1001;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [sv addSubview:imageView];
    
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [sv addGestureRecognizer:doubleTap];
    
    
    CGFloat radio = 320;
    circleRect = CGRectMake(20,20, radio, radio);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:imageView.bounds];
    [path appendPath:[UIBezierPath bezierPathWithOvalInRect:circleRect]];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = path.CGPath;
    maskLayer.fillColor = [UIColor colorWithWhite:0 alpha:0.6].CGColor;
    maskLayer.fillRule = kCAFillRuleEvenOdd;
    [self.view.layer addSublayer:maskLayer];
    
   
    ZMDiscolourView *discolourView = [[ZMDiscolourView alloc]initWithFrame:CGRectMake(0, 0, 200, 50)];
    discolourView.center = self.view.center;
    [self.view addSubview:discolourView];
    
    
//    ZMBezierPathView *pathView = [[ZMBezierPathView alloc]initWithFrame:self.view.bounds];
//    [self.view addSubview:pathView];
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)tap{
    
    CGPoint touchPoint = [tap locationInView:sv];
    if(sv.zoomScale == sv.minimumZoomScale) {
        //使放大的位置为点击的位置
        CGRect rect;
        rect.size.width = sv.frame.size.width/sv.maximumZoomScale;
        rect.size.height = sv.frame.size.height/sv.maximumZoomScale;
        rect.origin.x = touchPoint.x*(1-1/sv.maximumZoomScale);
        rect.origin.y = touchPoint.y*(1-1/sv.maximumZoomScale);
        [sv zoomToRect:rect animated:YES];
    }else{
        [sv setZoomScale:sv.minimumZoomScale animated:YES];
    }
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return [scrollView viewWithTag:1001];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale{
    
    CGRect toRect = [view convertRect:circleRect toView:self.view];
    CGRect fmRect = [view convertRect:circleRect fromView:self.view];
    
    NSLog(@"to====%@\nfm===%@",NSStringFromCGRect(toRect),NSStringFromCGRect(fmRect));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
