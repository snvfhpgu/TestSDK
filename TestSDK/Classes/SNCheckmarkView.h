//
//  SNCheckmarkView.h
//  SNImagePicker
//
//  Created by SNde on 2017/3/8.
//  Copyright © 2017年 SNde. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SNCheckmarkView : UIView

@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) CGFloat checkmarkLineWidth;

@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, strong) UIColor *bodyColor;
@property (nonatomic, strong) UIColor *checkmarkColor;

@end
