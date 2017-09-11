//
//  HFParticleSearchAnimateView.m
//  SearchParticleAnimateDemo(搜索的粒子动画)
//
//  Created by 胡丰 on 2017/9/1.
//  Copyright © 2017年 hufeng. All rights reserved.
//

#import "HFParticleSearchAnimateView.h"
#import "UIImage+Common.h"

//角度转化弧度
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

#define kCircleRadius 100
#define kCircleTime 2.0
#define kStartCircleNum 3.0

@interface HFParticleSearchAnimateView () {
    //是否正在运动
    BOOL _starting;
    NSInteger _particleNum;
}

@property (nonatomic, strong) CAEmitterLayer *emitter;

@property (nonatomic, strong) NSMutableArray *animationViewArray;

@end

@implementation HFParticleSearchAnimateView

- (instancetype)init {
    self = [self initWithFrame:CGRectZero];
    if (self) {
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _animationViewArray = [[NSMutableArray alloc] init];
        
        _particleNum = 13;
    }
    return self;
}

#pragma mark - Public
- (void)startAnimation {
    if (self.animationViewArray.count != 0 && self.animationViewArray.count != _particleNum) {
        return;
    }
    if (self.animationViewArray.count == _particleNum) {
        [self hiddenAnimation];
    }
    _starting = YES;
    if (_refreshActionBlock) {
        _refreshActionBlock();
    }
    for (int i = 0; i < _particleNum; i ++) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1*i * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self customSubviewsWithRate:(_particleNum-i)/(_particleNum * 1.0)];
        });
    }
}

- (void)hiddenAnimation {
    if (self.animationViewArray.count < _particleNum) {
        return;
    }
    for (int i = 0; i < self.animationViewArray.count; i ++) {
        UIView *animationView = self.animationViewArray[i];
        [animationView removeFromSuperview];
    }
    [self.animationViewArray removeAllObjects];
    _starting = NO;
}

- (void)endAnimation {
    if (self.animationViewArray.count < _particleNum) {
        return;
    }
    if (!_starting) {
        return;
    }
    for (int i = 0; i < self.animationViewArray.count; i ++) {
        UIView *animationView = self.animationViewArray[i];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1*i * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [animationView removeFromSuperview];
        });
    }
    [self.animationViewArray removeAllObjects];
    _starting = NO;
}

- (void)resumeAnimation {
    if (self.animationViewArray.count < _particleNum) {
        return;
    }
    for (UIView *animationView in self.animationViewArray) {
        if (_starting) {
            CFTimeInterval interval=[animationView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
            [animationView.layer setTimeOffset:interval];
            animationView.layer.speed=0;
        } else {
            CFTimeInterval beginTime= CACurrentMediaTime()- animationView.layer.timeOffset;
            animationView.layer.timeOffset=0;
            animationView.layer.beginTime=beginTime;
            animationView.layer.speed=1.0;
        }
    }
    _starting = !_starting;
}

#pragma mark - private
- (UIImage *)imgWithSize:(CGSize)size {
    UIImage *img = [UIImage imageWithColor:[UIColor whiteColor] withFrame:CGRectMake(0, 0, size.width, size.height)];
    img = [img clipImageWithRadius:size.width/2.0];
    return img;
}

#pragma mark - Action
- (void)searchAction:(UIButton *)button {
    [self startAnimation];
}

#define mark - Animate Method
- (void)customSubviewsWithRate:(CGFloat)rate {
    UIView *animationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self.animationViewArray addObject:animationView];
    [self insertSubview:animationView atIndex:0];
    
    
    self.emitter = [CAEmitterLayer new];
    self.emitter.emitterPosition = CGPointMake(animationView.frame.size.width / 2, animationView.frame.size.height/2.0);
    self.emitter.emitterShape = kCAEmitterLayerPoint;
    self.emitter.emitterSize = CGSizeMake(0.5 * rate, 0.5 * rate);
    self.emitter.shadowOpacity = 0.7;
    self.emitter.shadowColor = [UIColor whiteColor].CGColor;
    
    
    CAEmitterCell *star = [self makeEmitterCellRate:rate];
    
    self.emitter.emitterCells = @[star];
    [animationView.layer addSublayer:self.emitter];
    
    
    CAKeyframeAnimation *loopingAnimation = [self loopingPathAnimation];
    CAKeyframeAnimation *pathAnimation2 = [self circlePathAnimation];
    CABasicAnimation *rotationAnimation = [self rotationAnimation];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = YES;
    [group setAnimations:[NSArray arrayWithObjects:pathAnimation2,loopingAnimation,rotationAnimation,  nil]];
    group.duration = 1000.f;
    group.repeatCount = HUGE_VALF;
    [animationView.layer addAnimation:group forKey:@"groupAnimation"];
}

- (CAEmitterCell *)makeEmitterCellRate:(CGFloat)rate {
    CAEmitterCell *cell = [CAEmitterCell new];
    cell.velocity = 40;
    cell.emissionLongitude = DEGREES_TO_RADIANS(60);
    cell.emissionRange = M_PI_4*0.5 *rate;
    cell.yAcceleration = 10;
    cell.xAcceleration = -10;
    cell.scale = 0.4;
    cell.lifetime = [self randFloatBetween:0.3 and:0.75];
    cell.lifetimeRange = [self randFloatBetween:0.6 and:1.5];
    cell.contents = (id)[[self imgWithSize:CGSizeMake(10*rate, 10*rate)] CGImage];
    cell.birthRate = 20*rate;
    return cell;
}

- (CGFloat)randFloatBetween:(float)low and:(float)high {
    float diff = high - low;
    return (((float) rand() / RAND_MAX) * diff) + low;
}

//螺旋路径
- (CAKeyframeAnimation *)loopingPathAnimation {
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationLinear;
    pathAnimation.fillMode = kCAFillModeRemoved;
    pathAnimation.removedOnCompletion = YES;
    pathAnimation.duration = kCircleTime * kStartCircleNum;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    NSMutableArray *array = [NSMutableArray array];
    CGFloat radius = kCircleRadius;
    for (CGFloat angle = M_PI; angle < kStartCircleNum*2.0*M_PI + M_PI; angle = angle + 0.3) {
        CGFloat x = 10*angle*cos(angle) + self.frame.size.width/2.0;
        CGFloat y = 10*angle*sin(angle) +self.frame.size.height/2.0;
        if (10*angle > radius) {
            x = radius*cos(angle) + self.frame.size.width/2.0;
            y = radius*sin(angle) + self.frame.size.height/2.0;
        }
        NSValue *value = [NSValue valueWithCGPoint:CGPointMake(x, y)];
        [array addObject:value];
    }
    [path moveToPoint:[array.firstObject CGPointValue]];
    for (int i = 0; i < array.count; i ++ ) {
        CGPoint point1 = [array[i] CGPointValue];
        [path addLineToPoint:point1];
    }
    pathAnimation.path = [path CGPath];
    return pathAnimation;
}

- (CAKeyframeAnimation *)circlePathAnimation {
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationLinear;
    pathAnimation.fillMode = kCAFillModeRemoved;
    pathAnimation.removedOnCompletion = YES;
    pathAnimation.duration = kCircleTime;
    pathAnimation.repeatCount = HUGE_VALF;
    pathAnimation.beginTime = kStartCircleNum*kCircleTime;
    
    //绘制圆
    UIBezierPath *path = [UIBezierPath bezierPath];
    NSMutableArray *array = [NSMutableArray array];
    CGFloat radius = kCircleRadius;
    for (CGFloat angle = M_PI; angle < 2.0*M_PI + M_PI; angle = angle + 0.3) {
        CGFloat x = radius*cos(angle) + self.frame.size.width/2.0;
        CGFloat y = radius*sin(angle) + self.frame.size.height/2.0;
        NSValue *value = [NSValue valueWithCGPoint:CGPointMake(x, y)];
        [array addObject:value];
    }
    [path moveToPoint:[array.firstObject CGPointValue]];
    for (int i = 0; i < array.count; i ++ ) {
        CGPoint point1 = [array[i] CGPointValue];
        [path addLineToPoint:point1];
    }
    pathAnimation.path = [path CGPath];
    return pathAnimation;
}

- (CABasicAnimation *)rotationAnimation {
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnimation.fromValue = @(0);
    rotationAnimation.toValue = @(2*M_PI);
    rotationAnimation.duration = kCircleTime;
    rotationAnimation.cumulative = YES;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    rotationAnimation.repeatCount = HUGE_VALF;
    return rotationAnimation;
}
@end
