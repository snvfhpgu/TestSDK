//
//  SNVideoIndicatorView.h
//  SNImagePicker
//
//  Created by SNde on 2017/3/8.
//  Copyright © 2017年 SNde. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNVideoIconView.h"

@interface SNVideoIndicatorView : UIView

@property (nonatomic, strong) SNVideoIconView *videoIconView;
@property (nonatomic, strong) UILabel *videoTimeLabel;

@end
