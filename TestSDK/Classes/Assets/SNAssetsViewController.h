//
//  SNAssetsViewController.h
//  SNImagePicker
//
//  Created by SNde on 2017/3/3.
//  Copyright © 2017年 SNde. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PHFetchResult;
@class SNImagePickerController;

@interface SNAssetsViewController : UICollectionViewController
@property (nonatomic, copy) PHFetchResult *dataSource;
@property (nonatomic, weak) SNImagePickerController *imagePickerController;

@end
