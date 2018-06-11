//
//  UITextField+Utils.m
//  Al Chef
//
//  Created by Admin on 3/15/18.
//  Copyright © 2018 MobilePasse. All rights reserved.
//

#import "UITextField+Utils.h"
#import "UIView+Utils.h"

@implementation UITextField (Utils)

- (void)addBottomBorder
{
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
    [self addSubview:lineView];
    
    [lineView anchorWithConstantsToTop:0 left:self.leftAnchor bottom:self.bottomAnchor right:self.rightAnchor topConstant:0 leftConstant:0 bottomConstant:0 rightConstant:0 width:0 height:1];

}

- (void)highlightWithColor:(UIColor*)color
{
    UIView *bottom = [UIView new];
    bottom.backgroundColor = color;
    bottom.tag = 1;
    
//    UIView *top = [UIView new];
//    top.backgroundColor = color;
//    top.tag = 2;
//
//    UIView *left = [UIView new];
//    left.backgroundColor = color;
//    left.tag = 3;
//
//    UIView *right = [UIView new];
//    right.backgroundColor = color;
//    right.tag = 4;
    
    [self addSubview:bottom];
//    [self addSubview:top];
//    [self addSubview:left];
//    [self addSubview:right];
    
    [bottom anchorWithConstantsToTop:nil left:self.leftAnchor bottom:self.bottomAnchor right:self.rightAnchor topConstant:0 leftConstant:0 bottomConstant:0 rightConstant:0 width:0 height:1];
    
//    [top anchorWithConstantsToTop:self.topAnchor left:self.leftAnchor bottom:nil right:self.rightAnchor topConstant:0 leftConstant:0 bottomConstant:0 rightConstant:0 width:0 height:1];
//
//    
//    [left anchorWithConstantsToTop:self.topAnchor left:self.leftAnchor bottom:self.bottomAnchor right:nil topConstant:0 leftConstant:0 bottomConstant:0 rightConstant:0 width:1 height:0];
//
//
//    [right anchorWithConstantsToTop:self.topAnchor left:nil bottom:self.bottomAnchor right:self.rightAnchor topConstant:0 leftConstant:0 bottomConstant:0 rightConstant:0 width:1 height:0];
}

- (void)clearBorders
{
    for(UIView *view in self.subviews)
    {
        if(view.tag > 0)
            [view removeFromSuperview];
    }
}
@end
