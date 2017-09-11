//
//  HFParticleSearchAnimateView.h
//  SearchParticleAnimateDemo(搜索的粒子动画)
//
//  Created by 胡丰 on 2017/9/1.
//  Copyright © 2017年 hufeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HFParticleSearchAnimateView : UIView


/**
 开始动画
 */
- (void)startAnimation;

/**
 结束动画，只在动画运动的情况有效
 */
- (void)endAnimation;

/**
 暂停/重新运动 动画
 */
- (void)resumeAnimation;


@property (nonatomic, copy) void (^refreshActionBlock)();

@end
