//
//  UIButton+Utils.h
//  TemplateApp
//
//  Created by Admin on 2/26/18.
//  Copyright © 2018 MobilePasse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Utils)

+ (UIButton*)roundedButtonWithShadow:(BOOL)withShadow radius:(CGFloat)radius;
+ (UIButton*)backButtonWithTextColor:(UIColor*)color imageColor:(UIColor*)imgColor;

@end
