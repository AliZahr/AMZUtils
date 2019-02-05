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
    [self anchorWithConstantsToTop:top left:left bottom:bottom right:right topConstant:0 leftConstant:0 bottomConstant:0 rightConstant:0 width:0 height:0];
}
- (void)anchorWithConstantsToTop:(NSLayoutYAxisAnchor*)top left:(NSLayoutXAxisAnchor*)left bottom:(NSLayoutYAxisAnchor*)bottom right:(NSLayoutXAxisAnchor*)right topConstant:(CGFloat)topConstant leftConstant:(CGFloat)leftConstant bottomConstant:(CGFloat)bottomConstant rightConstant:(CGFloat)rightConstant
{
    [self anchorWithConstantsToTop:top left:left bottom:bottom right:right topConstant:topConstant leftConstant:leftConstant bottomConstant:bottomConstant rightConstant:rightConstant width:0 height:0];
}

- (void)anchorWithConstantsToTop:(NSLayoutYAxisAnchor*)top left:(NSLayoutXAxisAnchor*)left bottom:(NSLayoutYAxisAnchor*)bottom right:(NSLayoutXAxisAnchor*)right topConstant:(CGFloat)topConstant leftConstant:(CGFloat)leftConstant bottomConstant:(CGFloat)bottomConstant rightConstant:(CGFloat)rightConstant width:(CGFloat)width height:(CGFloat)height aspectRatio:(CGFloat)ratio
{
    [self anchorWithConstantsToTop:top left:left bottom:bottom right:right topConstant:topConstant leftConstant:leftConstant bottomConstant:bottomConstant rightConstant:rightConstant width:width height:height];
    
    [self.heightAnchor constraintEqualToAnchor:self.widthAnchor multiplier:ratio].active = YES;
}

- (void)anchorWithConstantsToTop:(NSLayoutYAxisAnchor*)top left:(NSLayoutXAxisAnchor*)left bottom:(NSLayoutYAxisAnchor*)bottom right:(NSLayoutXAxisAnchor*)right topConstant:(CGFloat)topConstant leftConstant:(CGFloat)leftConstant bottomConstant:(CGFloat)bottomConstant rightConstant:(CGFloat)rightConstant width:(CGFloat)width height:(CGFloat)height
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    if(top != nil)
    {
        [self.topAnchor constraintEqualToAnchor:top constant:topConstant].active = YES;
    }
    
    if(bottom != nil)
    {
        [self.bottomAnchor constraintEqualToAnchor:bottom constant:-bottomConstant].active = YES;
    }
    
    if(left != nil)
    {
        [self.leftAnchor constraintEqualToAnchor:left constant:leftConstant].active = YES;
    }
    
    if(right != nil)
    {
        [self.rightAnchor constraintEqualToAnchor:right constant:-rightConstant].active = YES;
    }
    
    if(width>0)
    {
        [self.widthAnchor constraintEqualToConstant:width].active = YES;
    }
    if(height>0)
    {
        [self.heightAnchor constraintEqualToConstant:height].active = YES;
    }
}

- (void)anchorCenterToView:(UIView*)view constantX:(CGFloat)constantX constantY:(CGFloat)constantY
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.centerXAnchor constraintEqualToAnchor:view.centerXAnchor constant:constantX].active = YES;
    [self.centerYAnchor constraintEqualToAnchor:view.centerYAnchor constant:constantY].active = YES;
}

- (void)anchorCenterYToView:(UIView*)view constantY:(CGFloat)constantY
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self.centerYAnchor constraintEqualToAnchor:view.centerYAnchor constant:constantY].active = YES;
}

- (void)anchorCenterXToView:(UIView*)view constantX:(CGFloat)constantX
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self.centerXAnchor constraintEqualToAnchor:view.centerXAnchor constant:constantX].active = YES;
}


- (void)anchorCenterYToSuperviewWithConstant:(CGFloat)constant
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    if(self.superview.centerYAnchor != nil)
    {
        [self.centerYAnchor constraintEqualToAnchor:self.superview.centerYAnchor constant:constant].active = YES;
    }
}

- (void)anchorCenterXToSuperviewWithConstant:(CGFloat)constant
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    if(self.superview.centerXAnchor != nil)
    {
        [self.centerXAnchor constraintEqualToAnchor:self.superview.centerXAnchor constant:constant].active = YES;
    }
}

- (void)anchorCenterSuperView
{
    [self anchorCenterXToSuperviewWithConstant:0];
    [self anchorCenterYToSuperviewWithConstant:0];
}

- (void)anchorFillSuperview
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    if(self.superview != nil)
    {
        [self.leftAnchor constraintEqualToAnchor:self.superview.leftAnchor constant:0].active = YES;
        [self.rightAnchor constraintEqualToAnchor:self.superview.rightAnchor constant:0].active = YES;
        [self.topAnchor constraintEqualToAnchor:self.superview.topAnchor constant:0].active = YES;
        [self.bottomAnchor constraintEqualToAnchor:self.superview.bottomAnchor constant:0].active = YES;
    }
}

- (void)setWidthConstraint:(CGFloat)width
{
    for (NSLayoutConstraint *cstr in self.constraints) {
        if(cstr.firstAttribute==NSLayoutAttributeWidth)
            cstr.constant = width;
    }
}

- (void)setHeightConstraint:(CGFloat)height
{
    for (NSLayoutConstraint *cstr in self.constraints) {
        if(cstr.firstAttribute==NSLayoutAttributeHeight)
            cstr.constant = height;
    }
}

- (void)anchorHeight:(CGFloat)height
{
    if(height>0)
    {
        [self.heightAnchor constraintEqualToConstant:height].active = YES;
    }
}

- (void)anchorWidth:(CGFloat)width
{
    if(width>0)
    {
        [self.widthAnchor constraintEqualToConstant:width].active = YES;
    }
}

- (void)removeAllConstraints
{
    [NSLayoutConstraint deactivateConstraints:self.constraints];
    [self removeConstraints:self.constraints];
}

- (void)removeConstraints
{
    UIView *superview = self.superview;
    while (superview != nil) {
        for (NSLayoutConstraint *c in superview.constraints) {
            if (c.firstItem == self || c.secondItem == self) {
                [superview removeConstraint:c];
            }
        }
        superview = superview.superview;
    }
    
    [self removeConstraints:self.constraints];
    self.translatesAutoresizingMaskIntoConstraints = YES;
}
// Animation

- (void)ShowWithAnimation
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    if([topController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *navCtrl=(UINavigationController*)topController;
        topController = navCtrl.topViewController;
    }
    
    UIView *original=topController.view;
    original.userInteractionEnabled=NO;
    self.transform=CGAffineTransformMakeScale(0.1f, 0.1f);
    self.alpha=0.0f;
    [topController.view addSubview:self];
    [self anchorFillSuperview];
    [self layoutIfNeeded];
    [UIView animateWithDuration:0.2 delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        self.transform=CGAffineTransformMakeScale(1.0f,1.0f);
        self.alpha=1.0f;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        UIView *original=topController.view;
        original.userInteractionEnabled=YES;
    }];
}

- (void)HideWithAnimation
{
    [UIView animateWithDuration:0.2 delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform=CGAffineTransformMakeScale(0.1f,0.1f);
        self.alpha=0.0f;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)setRoundedCorners:(UIRectCorner)corners radius:(CGFloat)radius {
    CGRect rect = self.bounds;
    
    // Create the path
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    
    // Create the shape layer and set its path
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    
    // Set the newly created shape layer as the mask for the view's layer
    self.layer.mask = maskLayer;
}

- (void)addBorderWithRadius:(CGFloat)radius width:(CGFloat)width color:(UIColor*)color
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(radius, radius)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    
    CAShapeLayer*   borderShape = [CAShapeLayer layer];
    borderShape.frame = self.bounds;
    borderShape.path = maskPath.CGPath;
    borderShape.strokeColor = color.CGColor;
    borderShape.fillColor = nil;
    borderShape.lineWidth = width;
    [self.layer addSublayer:borderShape];
    
}
@end
