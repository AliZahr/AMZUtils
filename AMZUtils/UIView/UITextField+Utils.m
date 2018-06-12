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
    
    [self addSubview:bottom];
    
    [bottom anchorWithConstantsToTop:nil left:self.leftAnchor bottom:self.bottomAnchor right:self.rightAnchor topConstant:0 leftConstant:0 bottomConstant:0 rightConstant:0 width:0 height:1];
}

- (void)clearBorders
{
    for(UIView *view in self.subviews)
    {
        if(view.tag > 0)
            [view removeFromSuperview];
    }
}

- (void)setPlaceholder:(NSString *)placeholder
{
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

@end
