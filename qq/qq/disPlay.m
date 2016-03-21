//
//  disPlay.m
//  qq
//
//  Created by 李勇猛 on 16/3/20.
//  Copyright © 2016年 李勇猛. All rights reserved.
//

#import "disPlay.h"
// 最大圆心距离
#define kMaxDistance 80
@interface disPlay ()




@end

@implementation disPlay

- (UIView *)smallCircleView{

    if (_smallCircleView ==nil) {
        _smallCircleView = [[UIView alloc]init];
        
        _smallCircleView.backgroundColor = self.backgroundColor;
        
        
    }
    return _smallCircleView;
}

#pragma mark - 创建一个不规则图层 根据 画线的路径声称图层

- (CAShapeLayer *)shapeLayer{

    if (_shapeLayer ==nil) {
        _shapeLayer = [CAShapeLayer layer];
        
        _shapeLayer.fillColor = self.backgroundColor.CGColor;
        
        [self.superview.layer insertSublayer:_shapeLayer below:self.layer];
    }
    return _shapeLayer;

}

#pragma mark - 初始化

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor redColor];
       [self setTitle:@"10" forState:UIControlStateNormal];
        
        self.titleLabel.font = [UIFont systemFontOfSize:12];
       
        
        
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void)pan:(UIPanGestureRecognizer *)pan{


    //获取偏移量
    CGPoint Offset = [pan translationInView:self];
    
    CGPoint center = self.center;
    
    center.x +=Offset.x;
    center.y +=Offset.y;
    self.center = center;
    
    [pan setTranslation:CGPointZero inView:self];

    
    //每次大圆的范围
    
     self.smallCircleView.bounds = self.bounds;
    
       CGFloat  btnW = self.smallCircleView.bounds.size.width/2;
    
    //求两个圆心的距离
    CGFloat  yun = [self moveRound:self.center smallCircleView:self.smallCircleView.center];
    
    // 后面圆的大小跟着前面圆改变半径
    
    
    CGFloat vvv = btnW - yun/10;
    self.smallCircleView.layer.cornerRadius = vvv;
    self.smallCircleView.bounds = CGRectMake(0, 0, vvv *2, vvv *2);
    
//    if (yun) {
//        self.shapeLayer.path = [self pathWithBigCirCleView:self smallCirCleView:self.smallCircleView].CGPath;
//    }
    
    if (yun > kMaxDistance) {
        
        self.smallCircleView.hidden = YES;
        [self.shapeLayer removeFromSuperlayer];
        self.shapeLayer = nil;
    
    }else if ( yun > 0 && self.smallCircleView.hidden ==NO){
    
        self.shapeLayer.path = [self pathWithBigCirCleView:self smallCirCleView:self.smallCircleView].CGPath;
    
    }
    
    
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        
        
        self.smallCircleView.bounds = self.bounds;
        self.smallCircleView.layer.cornerRadius = self.bounds.size.width/2;
        if (yun < 80) {
            // 移除不规则矩形
            [self.shapeLayer removeFromSuperlayer];
            self.shapeLayer = nil;
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.center =self.smallCircleView.center;
            } completion:^(BOOL finished) {
                self.smallCircleView.hidden = NO;
                
            }];
        }else{
        
        
            // 展示gif动画
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
            NSMutableArray *arrM = [NSMutableArray array];
            for (int i = 1; i < 9; i++) {
                UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
                [arrM addObject:image];
            }
            imageView.animationImages = arrM;
            
            imageView.animationRepeatCount = 1;
            
            imageView.animationDuration = 0.5;
            
            [imageView startAnimating];
            
            [self addSubview:imageView];
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.hidden = YES;
            });

        }
    }
    
    
   
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
   //NSLog(@"%@",self.superview);
    

}

#pragma mark -view已经创建了 这个方法只走一次
- (void)didMoveToSuperview{
    [super didMoveToSuperview];

    CGFloat btnW = self.frame.size.width;
    self.layer.cornerRadius = btnW/2;
//    self.smallCircleView.layer.cornerRadius =btnW/2;
    self.smallCircleView.layer.cornerRadius = 20;
    self.smallCircleView.bounds = self.bounds;
    
    [self.superview insertSubview:self.smallCircleView belowSubview:self];
}

- (void)willMoveToSuperview:(UIView *)newSuperview{

    [super willMoveToSuperview:newSuperview];
     self.smallCircleView.center = self.center;
    self.smallCircleView.bounds = self.bounds;
    
    CGFloat ww =  self.bounds.size.width/2;

    self.smallCircleView.layer.cornerRadius = ww;

}

#pragma mark - 算两个圆 圆心的距离
- (CGFloat)moveRound:(CGPoint)moveRound smallCircleView:(CGPoint)smallCircleView{

    //勾股定理
    CGFloat circleX = moveRound.x - smallCircleView.x;
    CGFloat circleY = moveRound.y - smallCircleView.y;
    
    return sqrtf(circleX * circleX + circleY * circleY);

}

#pragma mark - 算两个圆画线
- (UIBezierPath *)pathWithBigCirCleView:(UIView *)bigCirCleView  smallCirCleView:(UIView *)smallCirCleView{

    CGPoint bigCenter = bigCirCleView.center;
    CGFloat x2 = bigCenter.x;
    CGFloat y2 = bigCenter.y;
    CGFloat r2 = bigCirCleView.bounds.size.width / 2;
    
    CGPoint smallCenter = smallCirCleView.center;
    CGFloat x1 = smallCenter.x;
    CGFloat y1 = smallCenter.y;
    CGFloat r1 = smallCirCleView.bounds.size.width / 2;

    //获取圆心的距离
   CGFloat  d =  [self moveRound:bigCenter smallCircleView:smallCenter];
    
    CGFloat  sinθ = (x2-x1)/d;
    
    CGFloat cosθ = (y2-y1)/d;
    
    //通过余玄定理算坐标点
    
    // 坐标系基于父控件
    CGPoint pointA = CGPointMake(x1 - r1 * cosθ , y1 + r1 * sinθ);
    CGPoint pointB = CGPointMake(x1 + r1 * cosθ , y1 - r1 * sinθ);
    CGPoint pointC = CGPointMake(x2 + r2 * cosθ , y2 - r2 * sinθ);
    CGPoint pointD = CGPointMake(x2 - r2 * cosθ , y2 + r2 * sinθ);
    CGPoint pointO = CGPointMake(pointA.x + d / 2 * sinθ , pointA.y + d / 2 * cosθ);
    CGPoint pointP =  CGPointMake(pointB.x + d / 2 * sinθ , pointB.y + d / 2 * cosθ);
    UIBezierPath * path = [UIBezierPath bezierPath];
    //开始的点
    [path moveToPoint:pointA];
    //ab
    [path addLineToPoint:pointB];
    //bc曲线
    [path addQuadCurveToPoint:pointC controlPoint:pointP];
    //cd
    [path addLineToPoint:pointD];
    
    //da再画回去
    [path addQuadCurveToPoint:pointA controlPoint:pointO];

    return path;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



@end
