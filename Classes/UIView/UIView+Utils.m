//
//  UIView+Utils.m
//  AMZUtils
//
//  Created by Admin on 11/5/17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import "UIView+Utils.h"

@implementation UIView (Utils)

- (void)anchorToTop:(NSLayoutYAxisAnchor*)top left:(NSLayoutXAxisAnchor*)left bottom:(NSLayoutYAxisAnchor*)bottom right:(NSLayoutXAxisAnchor*)right
{
    [self anchorWithConstantsToTop:top left:left bottom:bottom right:right topConstant:0 leftConstant:0 bottomConstant:0 rightConstant:0];
}

- (void)anchorWithConstantsToTop:(NSLayoutYAxisAnchor*)top left:(NSLayoutXAxisAnchor*)left bottom:(NSLayoutYAxisAnchor*)bottom right:(NSLayoutXAxisAnchor*)right topConstant:(CGFloat)topConstant leftConstant:(CGFloat)leftConstant bottomConstant:(CGFloat)bottomConstant rightConstant:(CGFloat)rightConstant
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    if(top != nil)
    {
        [self.topAnchor constraintEqualToAnchor:top constant:topConstant].active = YES;
    }
    
    if(bottom != nil)
    {
        [self.bottomAnchor constraintEqualToAnchor:top constant:-bottomConstant].active = YES;
    }
    
    if(left != nil)
    {
        [self.leftAnchor constraintEqualToAnchor:left constant:leftConstant].active = YES;
    }
    
    if(right != nil)
    {
        [self.rightAnchor constraintEqualToAnchor:right constant:-rightConstant].active = YES;
    }
}

@end
