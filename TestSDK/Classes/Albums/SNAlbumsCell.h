//
//  SNAlbumsCell.h
//  SNImagePicker
//
//  Created by SNde on 2017/3/1.
//  Copyright © 2017年 SNde. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SNAlbumsCell : UITableViewCell
@property (nonatomic, strong) UIImageView *albumsImageView;
@property (nonatomic, strong) UILabel *albumsTitleLabel;
@property (nonatomic, strong) UILabel *albumsCountLabel;
@property (nonatomic, strong) UIView *accessoryIndicator;

@end
