//
//  UIFont+Utils.m
//  TemplateApp
//
//  Created by Admin on 2/26/18.
//  Copyright © 2018 MobilePasse. All rights reserved.
//

#import "UIFont+Utils.h"

@implementation UIFont (Utils)

+ (UIFont*) ScheherazadeFontWithSize:(float)size bold:(BOOL)bold
{
    if(bold)
        return [UIFont fontWithName:@"Scheherazade-Bold" size:size];
    else
        return [UIFont fontWithName:@"Scheherazade-Regular" size:size];
}

+ (UIFont*) GeezaProBold:(float)size
{
    return [UIFont fontWithName:@"GeezaPro-Bold" size:size];
}

@end
