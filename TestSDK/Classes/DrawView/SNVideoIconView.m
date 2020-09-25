//
//  SNVideoIconView.m
//  SNImagePicker
//
//  Created by SNde on 2017/3/8.
//  Copyright © 2017年 SNde. All rights reserved.
//

#import "SNVideoIconView.h"

@implementation SNVideoIconView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _iconColor = [UIColor whiteColor];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _iconColor = [UIColor whiteColor];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    [self.iconColor setFill];
    
    // Draw triangle
    UIBezierPath *trianglePath = [UIBezierPath bezierPath];
    [trianglePath moveToPoint:CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMinY(self.bounds))];
    [trianglePath addLineToPoint:CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMaxY(self.bounds))];
    [trianglePath addLineToPoint:CGPointMake(CGRectGetMaxX(self.bounds) - CGRectGetMidY(self.bounds), CGRectGetMidY(self.bounds))];
    [trianglePath closePath];
    [trianglePath fill];
    
    // Draw rounded square
    CGRect squareRect = CGRectMake(CGRectGetMinX(self.bounds),
                                   CGRectGetMinY(self.bounds),
                                   CGRectGetWidth(self.bounds) - CGRectGetMidY(self.bounds) - 1.0,
                                   CGRectGetHeight(self.bounds));
    UIBezierPath *squarePath = [UIBezierPath bezierPathWithRoundedRect:squareRect
                                                          cornerRadius:2.0];
    [squarePath fill];
}

@end
