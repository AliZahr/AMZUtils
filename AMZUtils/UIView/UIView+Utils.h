//
//  UIView+Utils.h
//  AMZUtils
//
//  Created by Admin on 11/5/17.
//  Copyright © 2017 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Utils.h"
#import "UIFont+Utils.h"
#import "UIButton+Utils.h"
#import "NSMutableAttributedString+Utils.h"
#import "UITextField+Utils.h"
#import "NSString+Utils.h"
#import "UIImageView+Utils.h"
#import "UIScrollView+ScrollViewUtils.h"

@interface UIView (Utils)

- (void)anchorToTop:(NSLayoutYAxisAnchor*)top left:(NSLayoutXAxisAnchor*)left bottom:(NSLayoutYAxisAnchor*)bottom right:(NSLayoutXAxisAnchor*)right;

- (void)anchorWithConstantsToTop:(NSLayoutYAxisAnchor*)top left:(NSLayoutXAxisAnchor*)left bottom:(NSLayoutYAxisAnchor*)bottom right:(NSLayoutXAxisAnchor*)right topConstant:(CGFloat)topConstant leftConstant:(CGFloat)leftConstant bottomConstant:(CGFloat)bottomConstant rightConstant:(CGFloat)rightConstant;

- (void)anchorWithConstantsToTop:(NSLayoutYAxisAnchor*)top left:(NSLayoutXAxisAnchor*)left bottom:(NSLayoutYAxisAnchor*)bottom right:(NSLayoutXAxisAnchor*)right topConstant:(CGFloat)topConstant leftConstant:(CGFloat)leftConstant bottomConstant:(CGFloat)bottomConstant rightConstant:(CGFloat)rightConstant width:(CGFloat)width height:(CGFloat)height;

- (void)anchorWithConstantsToTop:(NSLayoutYAxisAnchor*)top left:(NSLayoutXAxisAnchor*)left bottom:(NSLayoutYAxisAnchor*)bottom right:(NSLayoutXAxisAnchor*)right topConstant:(CGFloat)topConstant leftConstant:(CGFloat)leftConstant bottomConstant:(CGFloat)bottomConstant rightConstant:(CGFloat)rightConstant width:(CGFloat)width height:(CGFloat)height aspectRatio:(CGFloat)ratio;


- (void)anchorCenterToView:(UIView*)view constantX:(CGFloat)constantX constantY:(CGFloat)constantY;
- (void)anchorCenterYToSuperviewWithConstant:(CGFloat)constant;
- (void)anchorCenterXToSuperviewWithConstant:(CGFloat)constant;
- (void)anchorCenterSuperView;
- (void)anchorFillSuperview;
- (void)anchorCenterXToView:(UIView*)view constantX:(CGFloat)constantX;
- (void)anchorCenterYToView:(UIView*)view constantY:(CGFloat)constantY;
- (void)setWidthConstraint:(CGFloat)width;
- (void)setHeightConstraint:(CGFloat)height;
- (void)anchorHeight:(CGFloat)height;
- (void)anchorWidth:(CGFloat)width;

// Animation
- (void)ShowWithAnimation;
- (void)HideWithAnimation;

// Layer
-(void)setRoundedCorners:(UIRectCorner)corners radius:(CGFloat)radius;
- (void)addBorderWithRadius:(CGFloat)radius width:(CGFloat)width color:(UIColor*)color;


@end
