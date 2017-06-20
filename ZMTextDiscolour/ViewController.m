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
    
    UIScrollView *_sv;
    CGRect _circleRect;
    CAShapeLayer *_maskLayer;
    UIBezierPath *_currentPath;
    UIBezierPath *_minPath;
    UIBezierPath *_maxPath;
}


@end

@implementation ViewController

- (void)viewDidLoad {
    
    [self setupUI];
    
    [self configs];

}

- (void)setupUI{
    
    _sv = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _sv.delegate = self;
    _sv.multipleTouchEnabled=YES; //是否支持多点触控
    _sv.minimumZoomScale=1.0;  //表示与原图片最小的比例
    _sv.maximumZoomScale=2.5; //表示与原图片最大的比例
    [self.view addSubview:_sv];
    
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:_sv.bounds];
    imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mt" ofType:@"jpg"]];
    imageView.tag = 1001;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [_sv addSubview:imageView];
    
    UIImageView * imageView2 = [[UIImageView alloc]initWithFrame:_sv.bounds];
    imageView2.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mv" ofType:@"jpg"]];
    imageView2.tag = 1002;
    imageView2.contentMode = UIViewContentModeScaleAspectFill;
    [_sv addSubview:imageView2];
    
    
    
    CGFloat radio = 320;
    _circleRect = CGRectMake(20,20, radio, radio);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:imageView.bounds];
    [path appendPath:[UIBezierPath bezierPathWithOvalInRect:_circleRect]];

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

- (void)configs{
    
    UIView *topView = _sv.subviews.lastObject;
    CGFloat minRadios = 0;
    CGFloat maxRadios = sqrt(pow(topView.frame.size.width, 2)+pow(topView.frame.size.height, 2));
    
    _maskLayer = [CAShapeLayer layer];
    _maskLayer.backgroundColor = [UIColor redColor].CGColor;
    
    _minPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(topView.center.x - minRadios/2.f, topView.center.y - minRadios/2.f, minRadios, minRadios)];
    
    _maxPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake((topView.frame.size.width-maxRadios)/2.f, (topView.frame.size.height-maxRadios)/2.f, maxRadios, maxRadios)];
    
    _currentPath = _minPath;
    topView.layer.mask = _maskLayer;
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [_sv addGestureRecognizer:doubleTap];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [_sv addGestureRecognizer:singleTap];
    
    [singleTap requireGestureRecognizerToFail:doubleTap];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)tap{

    UIBezierPath *endPath = [_currentPath isEqual:_maxPath]?_minPath:_maxPath;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.duration = 0.33;
    animation.fillMode = kCAFillModeForwards;
    animation.fromValue = (id)_currentPath.CGPath;
    animation.toValue = (id)endPath.CGPath;
    [_maskLayer addAnimation:animation forKey:@"animation"];
    _currentPath = endPath;
    _maskLayer.path = _currentPath.CGPath;
    
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)tap{
    
    CGPoint touchPoint = [tap locationInView:_sv];
    if(_sv.zoomScale == _sv.minimumZoomScale) {
        //使放大的位置为点击的位置
        CGRect rect;
        rect.size.width = _sv.frame.size.width/_sv.maximumZoomScale;
        rect.size.height = _sv.frame.size.height/_sv.maximumZoomScale;
        rect.origin.x = touchPoint.x*(1-1/_sv.maximumZoomScale);
        rect.origin.y = touchPoint.y*(1-1/_sv.maximumZoomScale);
        [_sv zoomToRect:rect animated:YES];
    }else{
        [_sv setZoomScale:_sv.minimumZoomScale animated:YES];
    }
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return [scrollView viewWithTag:[_currentPath isEqual:_minPath]?1001:1002];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale{
    
    CGRect toRect = [view convertRect:_circleRect toView:self.view];
    CGRect fmRect = [view convertRect:_circleRect fromView:self.view];
    
    NSLog(@"to====%@\nfm===%@",NSStringFromCGRect(toRect),NSStringFromCGRect(fmRect));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
