//
//  UIColor+RGB.h
//  FrameWork
//
//  Created by 陈午阳 on 2018/3/27.
//  Copyright © 2018年 陈午阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (RGB)
+ (UIColor *)colorWithR:(CGFloat)R G:(CGFloat)G B:(CGFloat)B;
+ (UIColor *)colorWithR:(CGFloat)R G:(CGFloat)G B:(CGFloat)B alpha:(CGFloat)alpha;
+ (UIColor *) colorWithHexString: (NSString *)color;
+ (UIColor *) colorWithHexString: (NSString *)color alpha:(CGFloat)alpha;
+ (NSMutableArray *)changeUIColorToRGB:(UIColor *)color;
@end
