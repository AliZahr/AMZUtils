//
//  NSAttributedString+Utils.m
//  TemplateApp
//
//  Created by Admin on 2/27/18.
//  Copyright © 2018 MobilePasse. All rights reserved.
//

#import "NSMutableAttributedString+Utils.h"

@implementation NSMutableAttributedString (Utils)

- (BOOL)setAsLinkKeyword:(NSString*)textToFind linkURL:(NSString*)linkURL
{
    
//    NSRange foundRange = [self.mutableString rangeOfString:textToFind];
//    if (foundRange.location != NSNotFound) {
//        [self addAttribute:NSLinkAttributeName value:linkURL range:foundRange];
//        return YES;
//    }
    return NO;
}

@end
