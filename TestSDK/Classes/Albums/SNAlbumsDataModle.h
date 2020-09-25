//
//  SNAlbumsDataModle.h
//  SNImagePicker
//
//  Created by SNde on 2017/3/2.
//  Copyright © 2017年 SNde. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PHFetchResult;
@interface SNAlbumsDataModle : NSObject
@property (nonatomic, copy) PHFetchResult *fetchResult;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *image;

@end
