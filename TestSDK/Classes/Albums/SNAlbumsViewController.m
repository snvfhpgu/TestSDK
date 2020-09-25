//
//  SNAlbumsViewController.m
//  SNImagePicker
//
//  Created by SNde on 2017/3/1.
//  Copyright © 2017年 SNde. All rights reserved.
//

#import "SNAlbumsViewController.h"
#import "SNAssetsViewController.h"
#import "SNAlbumsCell.h"
#import "SNAlbumsDataModle.h"
#import "SNImagePickerController.h"
#import "UIViewController+Base.h"

static CGSize CGSizeScale(CGSize size, CGFloat scale) {
    return CGSizeMake(size.width * scale, size.height * scale);
}


@interface SNAlbumsViewController ()
@property (nonatomic, copy) NSArray *dataSource;
@property (nonatomic, strong) UIBarButtonItem *cancelBtn;

@end

@implementation SNAlbumsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willChangeStatusBarOrientationNotification:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];

    self.navigationItem.leftBarButtonItem = self.cancelBtn;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView registerClass:[SNAlbumsCell class] forCellReuseIdentifier:@"SNAlbumsCell"];

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self checkPHAuthorizationStatus];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SNAlbumsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SNAlbumsCell" forIndexPath:indexPath];
    cell.tag = indexPath.row;
  
    SNAlbumsDataModle *modle = _dataSource[indexPath.row];
    PHFetchResult *fetchResult = modle.fetchResult;
    PHImageManager *imageManager = [PHImageManager defaultManager];
    if (fetchResult.count > 0) {
        [imageManager requestImageForAsset:[fetchResult lastObject]
                                targetSize:CGSizeScale(cell.albumsImageView.frame.size,[[UIScreen mainScreen] scale])
                               contentMode:PHImageContentModeAspectFill
                                   options:nil
                             resultHandler:^(UIImage *result, NSDictionary *info) {
                                 if (cell.tag == indexPath.row) {
                                     cell.albumsImageView.image = result;
//                                     [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
                                 }
                             }];
    }
 
    // Number of photos
    cell.albumsTitleLabel.text = modle.title;
    cell.albumsCountLabel.text = @(fetchResult.count).stringValue;
    
    cell.accessoryIndicator.hidden = false;

    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return isiPad?120:80;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SNAlbumsDataModle *model = _dataSource[indexPath.row];
    [self.imagePickerController pushToAssetsViewControllerWithTitle:model.title dataSource:model.fetchResult];
}

#pragma mark - NSNotification Action
-(void)willChangeStatusBarOrientationNotification:(NSNotification*)sender {
    [self.tableView reloadData];
}

#pragma mark - custom Action
-(void)getAlbumsDataSource {

    PHFetchResult *smartFetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    PHFetchResult *userFetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    
   
    PHFetchOptions *options = self.imagePickerController.fetchOptions;
    NSMutableArray *assetCollections  = [@[] mutableCopy];
    for (PHFetchResult *fetchResult in @[smartFetchResult,userFetchResult]) {

        [fetchResult enumerateObjectsUsingBlock:^(PHAssetCollection *assetCollection, NSUInteger index, BOOL *stop) {
            
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
            SNAlbumsDataModle *modle = [[SNAlbumsDataModle alloc]init];
            modle.fetchResult = fetchResult;
            modle.title = assetCollection.localizedTitle;
            if (modle.fetchResult.count>0) {
                [assetCollections addObject:modle];
            }
        }];
    }

    _dataSource = assetCollections;
    [self.tableView reloadData];
}


-(void)checkPHAuthorizationStatus {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized) {
        
        [self getAlbumsDataSource];
        
    } else if (status == PHAuthorizationStatusNotDetermined) {
        
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self getAlbumsDataSource];
                });
            }
        }];
        
    }else {

        NSString *message = LocalizeString(@"photo.authorization");
        NSString *cancel = LocalizeString(@"photo.ok");

        [self showAlertWithMessage:message cancelButtonTitle:cancel];
    }
    
}


#pragma mark - Button Action
-(void)cancelBtn:(id)sender {
    SNImagePickerController *picker = self.imagePickerController;
    SEL selector = @selector(sn_imagePickerControllerDidCancel:);
    if ([picker.pickerDelegate respondsToSelector:selector]) {
        [picker.pickerDelegate sn_imagePickerControllerDidCancel:picker];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark - get
-(UIBarButtonItem *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                  target:self
                                                                  action:@selector(cancelBtn:)];
    }
    return _cancelBtn;
}

@end
