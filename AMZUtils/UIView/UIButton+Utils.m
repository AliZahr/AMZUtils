//
//  UIButton+Utils.m
//  TemplateApp
//
//  Created by Admin on 2/26/18.
//  Copyright © 2018 MobilePasse. All rights reserved.
//

#import "UIButton+Utils.h"
#import "UIFont+Utils.h"
#import "UIView+Utils.h"

@implementation UIButton (Utils)

+ (UIButton*)roundedButtonWithShadow:(BOOL)withShadow radius:(CGFloat)radius
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.layer.cornerRadius = radius;

    if(withShadow)
    {
        button.layer.shadowRadius = 12.0f;
        button.layer.shadowColor = [UIColor whiteColor].CGColor;
        button.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        button.layer.shadowOpacity = 0.2f;
        button.layer.masksToBounds = NO;

    }
    return button;
}

+ (UIButton*)backButtonWithTextColor:(UIColor*)color imageColor:(UIColor*)imgColor
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 50, 30);
    [backBtn anchorWidth:50];
    [backBtn anchorHeight:30];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont ScheherazadeFontWithSize:20 bold:YES];
    titleLabel.textColor = color;
    titleLabel.text = @"الرجوع";
    titleLabel.textAlignment = NSTextAlignmentRight;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"backIcon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.tintColor = imgColor;
    
    [backBtn addSubview:imageView];
    [backBtn addSubview:titleLabel];
    
    [imageView anchorWithConstantsToTop:backBtn.topAnchor left:nil bottom:backBtn.bottomAnchor right:backBtn.rightAnchor topConstant:0 leftConstant:0 bottomConstant:0 rightConstant:0 width:15 height:0];
    [titleLabel anchorWithConstantsToTop:backBtn.topAnchor left:nil bottom:backBtn.bottomAnchor right:imageView.leftAnchor topConstant:0 leftConstant:0 bottomConstant:0 rightConstant:5 width:0 height:0];

    return backBtn;
}
@end
