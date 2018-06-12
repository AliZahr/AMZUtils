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
    return [UIColor colorWithRed:57/255.0 green:110/255.0 blue:165/255.0 alpha:alpha];
}

+ (UIColor*)themeColor
{
    return [UIColor colorWithRed:57/255.0 green:110/255.0 blue:165/255.0 alpha:1];
}

+ (UIColor*)titleColor
{
    return [UIColor whiteColor];
}

+ (UIColor *)fadedWhite
{
    return [UIColor colorWithWhite:1 alpha:0.8];
}

+ (UIColor *) signUpGray
{
    return [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0];
}

+ (UIColor *)separatorColor
{
    return [UIColor colorWithRed:137/255.0 green:136/255.0 blue:170/255.0 alpha:0.5];
}

+ (UIColor *)popupBlack
{
    return [UIColor colorWithRed:43/255.0 green:43/255.0 blue:43/255.0 alpha:1];
}

+ (UIColor *)popupGray
{
    return [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1];
}


+ (UIColor*)progressBackground
{
    return [UIColor colorWithRed:130/255.0 green:136/255.0 blue:171/255.0 alpha:1];
}
+ (UIColor*)progressForeground
{
    return [UIColor whiteColor];
}

+ (UIColor *)blueBorder
{
    return [UIColor colorWithRed:55/255.0 green:137/255.0 blue:189/255.0 alpha:1];
}

+ (UIColor *)navyBlue
{
    return [UIColor colorWithRed:40/255.0 green:76/255.0 blue:118/255.0 alpha:1];
}

+ (UIColor *)placeholder
{
    return [UIColor whiteColor];
}

+ (UIColor *)fadedNavyBlue
{
    return [UIColor colorWithRed:64/255.0 green:129/255.0 blue:196/255.0 alpha:0.4];
}

+ (UIColor *)profSelectBackground
{
    return [UIColor colorWithRed:153/255.0 green:158/255.0 blue:197/255.0 alpha:0.1];
}

+ (UIColor *)infoButtonBackground
{
    return [UIColor colorWithWhite:1 alpha:0.2];
}
+ (UIColor *)followButtonBackground
{
    return [UIColor whiteColor];
}

+ (UIColor *)navigationBarBackground
{
    return [UIColor colorWithRed:42/255.0 green:80/255.0 blue:119/255.0 alpha:1];
}

+ (UIColor *)buttonNavyBlue
{
    return [UIColor colorWithRed:64/255.0 green:129/255.0 blue:196/255.0 alpha:1];
}

+ (UIColor *)buttonBorderFadedWhite
{
    return [UIColor colorWithWhite:1 alpha:0.5];
}

+ (UIColor *)storeCellBackground
{
    return [UIColor colorWithRed:84/255.0 green:106/255.0 blue:133/255.0 alpha:0.9];
}

+ (UIColor *)premiumNotification
{
    return [UIColor colorWithRed:245/255.0 green:166/255.0 blue:35/255.0 alpha:1];
}

+ (UIColor *)profNotificationBackground
{
    return [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:0.15];
}

+ (UIColor *)walletBackground
{
    return [UIColor colorWithRed:246/255.0 green:247/255.0 blue:249/255.0 alpha:0.15];
}

+ (UIColor *)lightRed
{
    return [UIColor colorWithRed:232/255.0 green:119/255.0 blue:115/255.0 alpha:1];
}

+ (UIColor *)lightYellow
{
    return [UIColor colorWithRed:250/255.0 green:223/255.0 blue:153/255.0 alpha:1];
}

+ (UIColor *)lightGreen
{
    return [UIColor colorWithRed:187/255.0 green:226/255.0 blue:132/255.0 alpha:1];
}
@end
