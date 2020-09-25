//
//  SNAccessoryIndicator.m
//  SNImagePicker
//
//  Created by SNde on 2017/3/10.
//  Copyright © 2017年 SNde. All rights reserved.
//

#import "SNAccessoryIndicator.h"

@implementation SNAccessoryIndicator


- (void)drawRect:(CGRect)rect {
    [[UIColor lightGrayColor]setStroke];
    
    CGFloat lineWidth = 2;
    
    UIBezierPath *cameraPath = [UIBezierPath bezierPath];
    [cameraPath setLineWidth:lineWidth];
    [cameraPath setLineCapStyle:kCGLineCapRound];
    [cameraPath setLineJoinStyle:kCGLineJoinRound];
    
    
    [cameraPath moveToPoint   :CGPointMake(lineWidth, lineWidth)];
    [cameraPath addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds)-lineWidth, CGRectGetHeight(self.bounds)/2)];
    [cameraPath addLineToPoint:CGPointMake(lineWidth, CGRectGetHeight(self.bounds)-lineWidth)];
    [cameraPath stroke];

}


@end
