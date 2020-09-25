//
//  SNAssetsCell.m
//  SNImagePicker
//
//  Created by SNde on 2017/3/3.
//  Copyright © 2017年 SNde. All rights reserved.
//

#import "SNAssetsCell.h"
#import "SNCheckmarkView.h"
#import "SNView+Frame.h"

@interface SNAssetsCell ()
@property (strong, nonatomic) UIView *overlayView;

@end

@implementation SNAssetsCell

-(void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    _overlayView.hidden = !(selected&&!_isCamera&&_showsOverlayViewWhenSelected);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.videoIndicatorView];
        [self.contentView addSubview:self.overlayView];
        [self.contentView addSubview:self.cameraView];
        [self setIsCamera:false];
    }
    return self;
}

-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = true;
    }
    _imageView.frame = self.bounds;
    return _imageView;
}

-(UIView *)overlayView {
    if (!_overlayView) {
        _overlayView = [[UIView alloc]initWithFrame:self.bounds];
        _overlayView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5];
        _overlayView.hidden = true;
        SNCheckmarkView *checkMark = [[SNCheckmarkView alloc]initWithFrame:CGRectMake(self.width-30, 0, 30, 30)];
        [_overlayView addSubview:checkMark];
    }
    _overlayView.frame = self.bounds;
    SNCheckmarkView *checkMark = _overlayView.subviews[0];
    checkMark.frame = CGRectMake(self.width-30, 0, 30, 30);
    return _overlayView;
}

-(SNVideoIndicatorView *)videoIndicatorView {
    if (!_videoIndicatorView) {
        _videoIndicatorView = [[SNVideoIndicatorView alloc]initWithFrame:CGRectMake(0, self.height-20, self.width, 20)];
    }
    _videoIndicatorView.frame = CGRectMake(0, self.height-20, self.width, 20);
    _videoIndicatorView.clipsToBounds = YES;
    return _videoIndicatorView;
}

-(UIView *)cameraView {
    if (!_cameraView) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        SNCameraView *camera =  [[SNCameraView alloc]initWithFrame:self.bounds];
       UIVisualEffectView *cameraView = [[UIVisualEffectView alloc] initWithEffect:effect];
        [cameraView.contentView addSubview:camera];
        _cameraView = cameraView;
    }
    UIVisualEffectView *cameraView = (UIVisualEffectView *)_cameraView;
    SNCameraView *camera = cameraView.contentView.subviews[0];
    camera.frame = self.bounds;
    cameraView.frame = self.bounds;
    return _cameraView;
}

#pragma mark - set
-(void)setIsCamera:(BOOL)isCamera {
    _isCamera = isCamera;
    self.cameraView.hidden = !isCamera;
    self.videoIndicatorView.hidden = isCamera;
    self.imageView.hidden = isCamera;
    if (_customCameraView) {
        self.cameraView.hidden = true;
        _customCameraView.userInteractionEnabled = false;
        [self.contentView addSubview:_customCameraView];
    }
}


@end
