//
//  UIImage+Common.m
//  SearchParticleAnimateDemo(搜索的粒子动画)
//
//  Created by 胡丰 on 2017/9/6.
//  Copyright © 2017年 hufeng. All rights reserved.
//

#import "UIImage+Common.h"


@implementation UIImage (Common)

+(UIImage *)imageWithColor:(UIColor *)aColor{
    return [UIImage imageWithColor:aColor withFrame:CGRectMake(0, 0, 1, 1)];
}

+(UIImage *)imageWithColor:(UIColor *)aColor withFrame:(CGRect)aFrame{
    UIGraphicsBeginImageContext(aFrame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [aColor CGColor]);
    CGContextFillRect(context, aFrame);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIImage *)clipImageWithRadius:(CGFloat)radius{
    CGFloat w = self.size.width;
    CGFloat h = self.size.height;
    
    if(radius<0){radius = 0;}
    if (radius>MIN(w, h)) {
        radius = MIN(w, h);
    }
    
    CGRect imgFrame = CGRectMake(0, 0, w, h);
    
    UIGraphicsBeginImageContextWithOptions(imgFrame.size, NO, 0);
    UIBezierPath  *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, w, h) cornerRadius:radius];
    [path addClip];
    [self drawInRect:imgFrame];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
