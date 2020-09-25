//
//  SNCheckmarkView.m
//  SNImagePicker
//
//  Created by SNde on 2017/3/8.
//  Copyright © 2017年 SNde. All rights reserved.
//

#import "SNCheckmarkView.h"

@implementation SNCheckmarkView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self defaultConfiguration];
   
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self defaultConfiguration];
    }
    return self;
}

-(void)defaultConfiguration {
    // Set default values
    self.borderWidth = 1.0;
    self.checkmarkLineWidth = 1.2;
    
    self.borderColor = [UIColor whiteColor];
    self.bodyColor   = [UIColor colorWithRed:(20.0 / 255.0) green:(111.0 / 255.0) blue:(223.0 / 255.0) alpha:1.0];
    self.checkmarkColor = [UIColor whiteColor];
    
    // Set shadow
    self.layer.shadowColor = [[UIColor grayColor] CGColor];
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowOpacity = 0.6;
    self.layer.shadowRadius = 2.0;

    self.backgroundColor = [UIColor clearColor];
}

- (void)drawRect:(CGRect)rect
{
    // Border
    [self.borderColor setFill];
    [[UIBezierPath bezierPathWithOvalInRect:self.bounds] fill];
    
    // Body
    [self.bodyColor setFill];
    [[UIBezierPath bezierPathWithOvalInRect:CGRectInset(self.bounds, self.borderWidth, self.borderWidth)] fill];
    
    // Checkmark
    UIBezierPath *checkmarkPath = [UIBezierPath bezierPath];
    checkmarkPath.lineWidth = self.checkmarkLineWidth;
    
    [checkmarkPath    moveToPoint:CGPointMake(CGRectGetWidth(self.bounds) * ( 6.0 / 24.0), CGRectGetHeight(self.bounds) * (12.0 / 24.0))];
    [checkmarkPath addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds) * (10.0 / 24.0), CGRectGetHeight(self.bounds) * (16.0 / 24.0))];
    [checkmarkPath addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds) * (18.0 / 24.0), CGRectGetHeight(self.bounds) * ( 8.0 / 24.0))];
    
    [self.checkmarkColor setStroke];
    [checkmarkPath stroke];
}

@end
