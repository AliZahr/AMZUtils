//
//  NSAttributedString+Utils.h
//  TemplateApp
//
//  Created by Admin on 2/27/18.
//  Copyright © 2018 MobilePasse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (Utils)
- (BOOL)setAsLinkKeyword:(NSString*)textToFind linkURL:(NSString*)linkURL;
@end
