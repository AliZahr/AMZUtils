//
//  NSString+Utils.h
//  TemplateApp
//
//  Created by Admin on 2/13/18.
//  Copyright © 2018 MobilePasse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Utils)
- (int)extractNumber;
- (NSArray *)extractNumbers;
-(BOOL) IsValidEmail;
-(BOOL) isValidPhoneNumber;
- (NSMutableAttributedString*)getColoredPercentageWithColor:(UIColor*)color;
- (NSString *)urlencode;
@end
