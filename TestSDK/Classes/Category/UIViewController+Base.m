//
//  UIViewController+Base.m
//  SNImagePicker
//
//  Created by snvfhpgu on 2019/4/4.
//  Copyright © 2019 SNde. All rights reserved.
//

#import "UIViewController+Base.h"

@implementation UIViewController(Base)


- (void)showAlertWithMessage:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle {
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:nil];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:true completion:nil];
}

@end
