//
//  SNCameraView.m
//  SNImagePicker
//
//  Created by SNde on 2017/3/9.
//  Copyright © 2017年 SNde. All rights reserved.
//

#import "SNCameraView.h"

@implementation SNCameraView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self defaultSet];

}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self defaultSet];
    }
    return self;
}

-(void)defaultSet {
    self.backgroundColor = [UIColor clearColor];

    _iconColor = [UIColor blackColor];
    _lineCap = kSNLineCapRound;
    _lineWidth = 2;
    _spaceX = 20;
}

- (void)drawRect:(CGRect)rect {
    CGLineCap lineCap = (CGLineCap)self.lineCap;

    CGFloat spaceX = self.spaceX;
    CGFloat maxX = CGRectGetMaxX(self.bounds);
    CGFloat maxY = CGRectGetMaxY(self.bounds);
    
    CGFloat width  = maxX-spaceX*2;
    CGFloat height = width*2/3;
    
    CGFloat spaceY = (maxY-height)/2;

    
    [[UIColor colorWithWhite:.0 alpha:1] setFill];
    UIBezierPath *roundPath0 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(maxX/2, maxY/2)
                                                              radius:maxY/2-spaceX/2
                                                          startAngle:0
                                                            endAngle:M_PI*2
                                                           clockwise:false];
    
    [roundPath0 setLineWidth:1];
    [roundPath0 setLineCapStyle:lineCap];
    [roundPath0 setLineJoinStyle:kCGLineJoinRound];
    [roundPath0 stroke];
    [roundPath0 fill];
    
    
    [self.iconColor setStroke];
    [[UIColor whiteColor] setFill];
    
    // Draw camera
    UIBezierPath *cameraPath = [UIBezierPath bezierPath];
    [cameraPath setLineWidth:self.lineWidth];
    [cameraPath setLineCapStyle:lineCap];
    [cameraPath setLineJoinStyle:kCGLineJoinRound];
    
    
    [cameraPath moveToPoint   :CGPointMake(spaceX,      spaceY+height/6)];
    [cameraPath addLineToPoint:CGPointMake(spaceX,      maxY - spaceY)];
    [cameraPath addLineToPoint:CGPointMake(maxX-spaceX, maxY - spaceY)];
    [cameraPath addLineToPoint:CGPointMake(maxX-spaceX, spaceY+height/6)];
    
    [cameraPath addLineToPoint:CGPointMake(width*3/4+spaceX, spaceY+height/6)];
    [cameraPath addLineToPoint:CGPointMake(width*5/8+spaceX, spaceY )];
    [cameraPath addLineToPoint:CGPointMake(width*3/8+spaceX, spaceY )];
    [cameraPath addLineToPoint:CGPointMake(width*1/4+spaceX, spaceY+height/6)];
    [cameraPath closePath];
    [cameraPath stroke];
    [cameraPath fill];
    
    //Round
    UIBezierPath *roundPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(maxX/2, maxY/2+height/12)
                                                             radius:(height)/3
                                                         startAngle:0
                                                           endAngle:M_PI*2
                                                          clockwise:false];

    [roundPath setLineWidth:self.lineWidth];
    [roundPath setLineCapStyle:lineCap];
    [roundPath setLineJoinStyle:kCGLineJoinRound];
    [roundPath stroke];

    //Round 2
    UIBezierPath *roundPath2 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(maxX/2, maxY/2+height/12)
                                                              radius:(height)/3-self.lineWidth*2
                                                          startAngle:M_PI/2
                                                            endAngle:M_PI/8
                                                           clockwise:false];
    
    [roundPath2 setLineWidth:self.lineWidth];
    [roundPath2 setLineCapStyle:lineCap];
    [roundPath2 setLineJoinStyle:kCGLineJoinRound];
    [roundPath2 stroke];
    
    
    
}

@end
