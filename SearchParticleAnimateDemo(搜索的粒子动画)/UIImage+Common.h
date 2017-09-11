//
//  UIImage+Common.h
//  SearchParticleAnimateDemo(搜索的粒子动画)
//
//  Created by 胡丰 on 2017/9/6.
//  Copyright © 2017年 hufeng. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImage (Common)

+(UIImage *)imageWithColor:(UIColor *)aColor;
+(UIImage *)imageWithColor:(UIColor *)aColor withFrame:(CGRect)aFrame;

- (UIImage *)clipImageWithRadius:(CGFloat)radius;
@end
