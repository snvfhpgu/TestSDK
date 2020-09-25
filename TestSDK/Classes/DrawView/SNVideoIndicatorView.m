//
//  SNVideoIndicatorView.m
//  SNImagePicker
//
//  Created by SNde on 2017/3/8.
//  Copyright © 2017年 SNde. All rights reserved.
//

#import "SNVideoIndicatorView.h"

@implementation SNVideoIndicatorView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.8];
        [self addSubview:self.videoIconView];
        [self addSubview:self.videoTimeLabel];
    }
    return self;
}


-(SNVideoIconView *)videoIconView {
    if (!_videoIconView) {
        CGFloat y = (self.bounds.size.height - 8)/2;
        _videoIconView = [[SNVideoIconView alloc]initWithFrame:CGRectMake(5, y, 14, 8)];
    }
    return _videoIconView;
}

-(UILabel *)videoTimeLabel {
    if (!_videoTimeLabel) {
        _videoTimeLabel = [[UILabel alloc]init];
        _videoTimeLabel.textColor = [UIColor whiteColor];
        _videoTimeLabel.textAlignment = NSTextAlignmentRight;
        _videoTimeLabel.font = [UIFont systemFontOfSize:12];
    }
    CGFloat y = (self.bounds.size.height - 15)/2;
    _videoTimeLabel.frame = CGRectMake(14+5+4, y, self.bounds.size.width-(14+5+4)-5, 15);
    return _videoTimeLabel;
}

@end
