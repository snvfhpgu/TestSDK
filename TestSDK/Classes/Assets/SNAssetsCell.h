//
//  SNAssetsCell.h
//  SNImagePicker
//
//  Created by SNde on 2017/3/3.
//  Copyright © 2017年 SNde. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNVideoIndicatorView.h"
#import "SNCameraView.h"
typedef NS_ENUM(NSUInteger, SNAssetsType) {
    SNAssetsTypeImage = 0,
    SNAssetsTypeVideo
};

@interface SNAssetsCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) SNVideoIndicatorView *videoIndicatorView;
@property (nonatomic, strong) UIView *cameraView;
@property (nonatomic, assign) SNAssetsType type;

@property (nonatomic, assign) BOOL isCamera;
@property (nonatomic, assign) BOOL showsOverlayViewWhenSelected;

@property (nonatomic, strong) UIView *customCameraView; //default is nil


@end
