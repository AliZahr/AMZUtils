//
//  UIColor+Utils.m
//  TemplateApp
//
//  Created by Admin on 2/26/18.
//  Copyright © 2018 MobilePasse. All rights reserved.
//

#import "UIColor+Utils.h"

@implementation UIColor (Utils)

+ (UIColor*)themeColorWithAlpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:93/255.0 green:112/255.0 blue:241/255.0 alpha:alpha];
}

+ (UIColor*)themeColor
{
    return [UIColor colorWithRed:93/255.0 green:112/255.0 blue:241/255.0 alpha:1];
}

+ (UIColor*)titleColor
{
    return [UIColor colorWithRed:17/255.0 green:17/255.0 blue:17/255.0 alpha:1];
}
@end
