//
//  UIView+Utils.h
//  AMZUtils
//
//  Created by Admin on 11/5/17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Utils)

- (void)anchorToTop:(NSLayoutYAxisAnchor*)top left:(NSLayoutXAxisAnchor*)left bottom:(NSLayoutYAxisAnchor*)bottom right:(NSLayoutXAxisAnchor*)right;

- (void)anchorWithConstantsToTop:(NSLayoutYAxisAnchor*)top left:(NSLayoutXAxisAnchor*)left bottom:(NSLayoutYAxisAnchor*)bottom right:(NSLayoutXAxisAnchor*)right topConstant:(CGFloat)topConstant leftConstant:(CGFloat)leftConstant bottomConstant:(CGFloat)bottomConstant rightConstant:(CGFloat)rightConstant;


@end
