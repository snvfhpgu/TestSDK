//
//  SNAlbumsCell.m
//  SNImagePicker
//
//  Created by SNde on 2017/3/1.
//  Copyright © 2017年 SNde. All rights reserved.
//

#import "SNAlbumsCell.h"
#import "SNAccessoryIndicator.h"

#define UIImageHeight self.bounds.size.height-10*2
#define UIImageWidth  self.bounds.size.width-10*2

@implementation SNAlbumsCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.albumsImageView];
        [self.contentView addSubview:self.albumsTitleLabel];
        [self.contentView addSubview:self.albumsCountLabel];
        [self.contentView addSubview:self.accessoryIndicator];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - get
-(UIImageView *)albumsImageView {
    if (!_albumsImageView) {
        _albumsImageView = [[UIImageView alloc]init];
        _albumsImageView.contentMode = UIViewContentModeScaleAspectFill;
        _albumsImageView.clipsToBounds = true;
    }
    _albumsImageView.frame = CGRectMake(10, 10, UIImageHeight, UIImageHeight);
    return _albumsImageView;
}

-(UILabel *)albumsTitleLabel {
    if (!_albumsTitleLabel) {
        _albumsTitleLabel = [[UILabel alloc]init];
    }
    CGFloat x = CGRectGetMaxX(self.albumsImageView.frame);
    CGFloat y = (UIImageHeight+20-20*2)/2;
    _albumsTitleLabel.frame = CGRectMake(x+10, y, UIImageWidth-x-10*3, 20);
    return _albumsTitleLabel;
}

-(UILabel *)albumsCountLabel {
    if (!_albumsCountLabel) {
        _albumsCountLabel = [[UILabel alloc]init];
    }
    CGFloat x = CGRectGetMaxX(self.albumsImageView.frame);
    CGFloat y = CGRectGetMaxY(self.albumsTitleLabel.frame);
    _albumsCountLabel.frame = CGRectMake(x+10, y, UIImageWidth-x-10*3, 20);
    return _albumsCountLabel;
}

-(UIView*)accessoryIndicator {
    if (!_accessoryIndicator) {
        _accessoryIndicator = [[SNAccessoryIndicator alloc]init];
        _accessoryIndicator.backgroundColor = [UIColor clearColor];
    }
    _accessoryIndicator.frame = CGRectMake(self.bounds.size.width-20, (self.bounds.size.height-20)/2, 10, 20);

    return _accessoryIndicator;
}

@end
