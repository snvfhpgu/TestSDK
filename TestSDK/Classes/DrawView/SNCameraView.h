//
//  SNCameraView.h
//  SNImagePicker
//
//  Created by SNde on 2017/3/9.
//  Copyright © 2017年 SNde. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, SNLineCap) {
    kSNLineCapButt = kCGLineCapButt,
    kSNLineCapRound = kCGLineCapRound ,
    kSNLineCapSquare = kCGLineCapSquare
};

@interface SNCameraView : UIView
@property (nonatomic, strong) IBInspectable UIColor *iconColor;
@property (nonatomic, assign) IBInspectable CGFloat lineWidth;
@property (nonatomic, assign) IBInspectable SNLineCap lineCap;
@property (nonatomic, assign) IBInspectable CGFloat spaceX;

@end
