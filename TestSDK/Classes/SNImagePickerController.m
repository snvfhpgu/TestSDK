//
//  SNImagePickerViewController.m
//  SNImagePicker
//
//  Created by SNde on 2017/3/2.
//  Copyright © 2017年 SNde. All rights reserved.
//

#import "SNImagePickerController.h"
#import "SNNavigationController.h"
#import "SNAlbumsViewController.h"
#import "SNAssetsViewController.h"
#import "UIViewController+Base.h"


@interface SNImagePickerController ()

@property (nonatomic, strong) SNNavigationController *theNavigationController;
@property (nonatomic, strong) SNAlbumsViewController *theAlbumsViewController;
@property (nonatomic, strong) SNAssetsViewController *theAssetsViewController;


@end

@implementation SNImagePickerController


- (instancetype)init {
    self = [super init];
    if (self) {
        self.countOfColumnsInPortrait  = isiPad?7:4;
        self.countOfColumnsInLandscape = isiPad?10:7;
        
        self.allowsMultipleSelection = true;
        self.minCountOfSelection = 1;
        self.maxCountOfSelection = NSIntegerMax;
        
        self.showCameraItem = true;
        self.mediaType = SNImagePickerMediaTypeAny;
        self.cameraShowType = SNImagePickerCameraShowAtLast;
        self.videoMaximumDuration = 10*60;
        self.viewControllers = @[self.theNavigationController,self.theAssetsViewController];

        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self addChildViewController:self.theNavigationController];
//    [self.view addSubview:_theNavigationController.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(PHFetchOptions *)fetchOptions {
    PHFetchOptions *options = [[PHFetchOptions alloc]init];
    switch (self.mediaType) {
        case SNImagePickerMediaTypeAny:
            
            break;
        case SNImagePickerMediaTypeImage:
            options.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
            break;
        case SNImagePickerMediaTypeVideo:
            options.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeVideo];
            break;
        default:
            break;
    }
    return options;
}


#pragma mark - get
-(SNNavigationController *)theNavigationController {
    if (!_theNavigationController) {
        _theNavigationController = [[SNNavigationController alloc]initWithRootViewController:self.theAlbumsViewController];
        _theNavigationController.view.frame = [UIScreen mainScreen].bounds;
        _theAlbumsViewController.imagePickerController = self;
        [_theNavigationController didMoveToParentViewController:self];

    }
    return _theNavigationController;
}

- (void)pushToAssetsViewControllerWithTitle:(NSString *)title dataSource:(PHFetchResult *)dataSource {
    self.theAssetsViewController.dataSource = dataSource;
    self.theAssetsViewController.title = title;
    [self.theNavigationController pushViewController:self.theAssetsViewController animated:YES];
}

-(SNAlbumsViewController*)theAlbumsViewController {
    if (!_theAlbumsViewController) {
        _theAlbumsViewController = [[SNAlbumsViewController alloc]init];
    }
    return _theAlbumsViewController;
}

-(SNAssetsViewController*)theAssetsViewController {
    if (!_theAssetsViewController) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        _theAssetsViewController = [[SNAssetsViewController alloc]initWithCollectionViewLayout:layout];
        _theAssetsViewController.imagePickerController = self;
        [self checkPHAuthorizationStatus];
    }
    return _theAssetsViewController;
}


-(void)checkPHAuthorizationStatus {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized) {
        
        [self getFetchResult];
        
    } else if (status == PHAuthorizationStatusNotDetermined) {
        
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self getFetchResult];
                });
            }
        }];
        
    }else {
        
        NSString *message = LocalizeString(@"photo.authorization");
        NSString *cancel = LocalizeString(@"photo.ok");
        [self showAlertWithMessage:message cancelButtonTitle:cancel];
    }
    
}


-(void)getFetchResult {
    PHFetchResult *result = [PHAssetCollection
                             fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                             subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary
                             options:nil];
    
    if (result.count>0) {
        PHAssetCollection *assetCollection = result.firstObject;
        PHFetchOptions *options = self.fetchOptions;
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
        self.theAssetsViewController.dataSource = fetchResult;
        self.theAssetsViewController.title = [assetCollection localizedTitle];
    }

}

-(NSMutableOrderedSet<PHAsset *> *)selectAssets {
    if (!_selectAssets) {
        _selectAssets = [NSMutableOrderedSet orderedSet];
    }
    return _selectAssets;
}

@end
