//
//  UIViewController+Base.h
//  SNImagePicker
//
//  Created by snvfhpgu on 2019/4/4.
//  Copyright © 2019 SNde. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Base)

- (void)showAlertWithMessage:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle;

@end

NS_ASSUME_NONNULL_END
