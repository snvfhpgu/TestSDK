//
//  SNImagePickerViewController.h
//  SNImagePicker
//
//  Created by SNde on 2017/3/2.
//  Copyright © 2017年 SNde. All rights reserved.
//
#define isiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "SNLocalizationSystem.h"

#define LocalizeString(key) SNLocalizeForTableName(key, @"SNImagePickerString")

@class SNNavigationController;
@class SNAlbumsViewController;
@class SNAssetsViewController;
@class SNImagePickerController;

@protocol SNImagePickerControllerDelegate <NSObject>

-(void)sn_imagePickerController:(SNImagePickerController *)imagePickerController
         didFinishPickingAssets:(NSArray<PHAsset *>*)assets;

-(void)sn_imagePickerControllerDidCancel:(SNImagePickerController *)imagePickerController;

@end

typedef NS_ENUM(NSUInteger, SNImagePickerMediaType) {
    SNImagePickerMediaTypeAny = 0,
    SNImagePickerMediaTypeImage,
    SNImagePickerMediaTypeVideo
};

typedef NS_ENUM(NSUInteger, SNImagePickerCameraShowType) {
    SNImagePickerCameraShowAtFirst = 0,
    SNImagePickerCameraShowAtLast
};

@interface SNImagePickerController : UISplitViewController


@property (nonatomic, assign) SNImagePickerMediaType mediaType;
@property (nonatomic, weak) id<SNImagePickerControllerDelegate> pickerDelegate;
@property (nonatomic, strong) NSMutableOrderedSet<PHAsset*> *selectAssets;

@property (nonatomic, assign) NSInteger countOfColumnsInPortrait;
@property (nonatomic, assign) NSInteger countOfColumnsInLandscape;

@property (nonatomic, assign) BOOL allowsMultipleSelection;
@property (nonatomic, assign) NSUInteger minCountOfSelection;
@property (nonatomic, assign) NSUInteger maxCountOfSelection;
@property (nonatomic, assign) NSTimeInterval videoMaximumDuration ; // default value is 10 minutes.

@property (nonatomic, assign) BOOL showCameraItem; // default value is true
@property (nonatomic, assign) SNImagePickerCameraShowType cameraShowType; // default is SNImagePickerCameraShowAtLast
@property (nonatomic, strong, readonly) PHFetchOptions *fetchOptions;

- (void)pushToAssetsViewControllerWithTitle:(NSString *)title dataSource:(PHFetchResult *)dataSource;

@end

