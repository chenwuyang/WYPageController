//
//  UIColor+RGB.m
//  FrameWork
//
//  Created by 陈午阳 on 2018/3/27.
//  Copyright © 2018年 陈午阳. All rights reserved.
//

#import "UIColor+RGB.h"

@implementation UIColor (RGB)
+ (UIColor *)colorWithR:(CGFloat)R G:(CGFloat)G B:(CGFloat)B
{
    UIColor *color = [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0];
    return color;
}

+ (UIColor *)colorWithR:(CGFloat)R G:(CGFloat)G B:(CGFloat)B alpha:(CGFloat)alpha
{
    UIColor *color = [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:alpha];
    return color;
}

+ (UIColor *) colorWithHexString: (NSString *)color
{
    return [UIColor colorWithHexString:color alpha:1.0];
}

+ (UIColor *) colorWithHexString: (NSString *)color alpha:(CGFloat)alpha
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:alpha];
}

//将UIColor转换为RGB值
+ (NSMutableArray *) changeUIColorToRGB:(UIColor *)color
{
    NSMutableArray *RGBStrValueArr = [[NSMutableArray alloc] init];
    NSString *RGBStr = nil;
    //获得RGB值描述
    NSString *RGBValue = [NSString stringWithFormat:@"%@",color];
    //将RGB值描述分隔成字符串
    NSArray *RGBArr = [RGBValue componentsSeparatedByString:@" "];
    //获取红色值
    double r = [[RGBArr objectAtIndex:1] doubleValue] * 255;
    RGBStr = [NSString stringWithFormat:@"%lf",r];
    [RGBStrValueArr addObject:RGBStr];
    //获取绿色值
    double g = [[RGBArr objectAtIndex:2] doubleValue] * 255;
    RGBStr = [NSString stringWithFormat:@"%lf",g];
    [RGBStrValueArr addObject:RGBStr];
    //获取蓝色值
    double b = [[RGBArr objectAtIndex:3] doubleValue] * 255;
    RGBStr = [NSString stringWithFormat:@"%lf",b];
    [RGBStrValueArr addObject:RGBStr];
    //返回保存RGB值的数组
    return RGBStrValueArr;
}

@end
