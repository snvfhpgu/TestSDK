//
//  SNAssetsViewController.m
//  SNImagePicker
//
//  Created by SNde on 2017/3/3.
//  Copyright © 2017年 SNde. All rights reserved.
//

#import "SNAssetsViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "SNAssetsCell.h"
#import "SNView+Frame.h"
#import "UIViewController+Base.h"
#import "SNImagePickerController.h"

@implementation NSIndexSet (indexPath)

-(NSArray *)sn_indexPathWithSection:(NSInteger)section {
    NSMutableArray *indexPaths = [@[]mutableCopy];
    [self enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * stop) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:section];
        [indexPaths addObject:indexPath];
    }];
    return indexPaths;
}

@end

@interface SNAssetsViewController ()<
PHPhotoLibraryChangeObserver,
UICollectionViewDelegateFlowLayout,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate>

@property (strong, nonatomic) UIBarButtonItem *doneBtn;
@property (strong, nonatomic) UIView *bottomController;

@end

@implementation SNAssetsViewController

static NSString * const reuseIdentifier = @"SNAssetsCell";

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self setObserver:self remove:false];
    [self.navigationItem setRightBarButtonItem:self.doneBtn];

    [self.collectionView registerClass:[SNAssetsCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView setAllowsMultipleSelection:self.imagePickerController.allowsMultipleSelection];
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {
    [self setObserver:nil remove:true];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.imagePickerController.showCameraItem) {
        return _dataSource.count+1;
    }
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SNImagePickerController *picker = self.imagePickerController;

    SNAssetsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSInteger row = indexPath.row;
    if (picker.showCameraItem) {
        BOOL isCamera = [self returnCameraItem:row finshBlock:nil];
        cell.isCamera = isCamera;
        if (isCamera) {return cell;}
        if (picker.cameraShowType == SNImagePickerCameraShowAtFirst) {
            row = row - 1;
        }
    }
    cell.showsOverlayViewWhenSelected = picker.allowsMultipleSelection;
   
    cell.tag = indexPath.row;
    PHAsset *asset = _dataSource[row];
    if (asset.mediaType == PHAssetMediaTypeVideo) {
        cell.videoIndicatorView.hidden = false;
        NSInteger minutes = (NSInteger)(asset.duration / 60.0);
        NSInteger seconds = (NSInteger)ceil(asset.duration - 60.0 * (double)minutes);
        cell.videoIndicatorView.videoTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];
    }else {
        cell.videoIndicatorView.hidden = true;
    }
    
    [[PHImageManager defaultManager]requestImageForAsset:asset targetSize:cell.bounds.size contentMode:(PHImageContentModeAspectFill) options:nil resultHandler:^(UIImage * image, NSDictionary * info) {
        if (cell.tag == indexPath.row) {
            cell.imageView.image = image;
        }
    }];
    if ([picker.selectAssets containsObject:asset]) {
        [cell setSelected:true];
        [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SNImagePickerController *picker = self.imagePickerController;

    if (picker.selectAssets.count >= picker.maxCountOfSelection) {
        return false;
    }
    return true;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    [self returnCameraItem:indexPath.row finshBlock:^(NSInteger row, BOOL showCamera) {
        if (showCamera) {
            [self goImagePickerController];
        }else {
            PHAsset *asset = self.dataSource[row];
            NSMutableOrderedSet *selectAssets = self.imagePickerController.selectAssets;
            [selectAssets addObject:asset];
            if (!self.imagePickerController.allowsMultipleSelection) {
                [self doneBtn:nil];
            }
        }
    }];
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.imagePickerController.allowsMultipleSelection) {
        return;
    }
    [self returnCameraItem:indexPath.row finshBlock:^(NSInteger row, BOOL showCamera) {
        if (!showCamera) {
            PHAsset *asset = self.dataSource[row];
            NSMutableOrderedSet *selectAssets = self.imagePickerController.selectAssets;
            [selectAssets removeObject:asset];
        }
    }];

}



#pragma mark < UICollectionViewDelegateFlowLayout >
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger numberOfColumns;
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        numberOfColumns = self.imagePickerController.countOfColumnsInPortrait;
    } else {
        numberOfColumns = self.imagePickerController.countOfColumnsInLandscape;
    }
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - 2.0 * (numberOfColumns - 1)) / numberOfColumns;
    
    return CGSizeMake(width, width);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 2, 0);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2;
}


#pragma mark - < UIImagePickerControllerDelegate >
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        NSURL *videoUrl = info[UIImagePickerControllerMediaURL];

        NSString *path = videoUrl.path;
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path)) {
            UISaveVideoAtPathToSavedPhotosAlbum(path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
        
    }
    
    [picker dismissViewControllerAnimated:true completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:true completion:nil];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
}


#pragma mark - < PHPhotoLibraryChangeObserver >
-(void)photoLibraryDidChange:(PHChange *)changeInstance {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        PHFetchResultChangeDetails *changeDetails = [changeInstance changeDetailsForFetchResult:self.dataSource];
        if (changeDetails) {
            
            self.dataSource = [changeDetails fetchResultAfterChanges];
            if (![changeDetails hasIncrementalChanges]||changeDetails.hasMoves) {
                [self.collectionView reloadData];
                return ;
            }
            [self.collectionView performBatchUpdates:^{
                NSIndexSet *removedIndexes = [changeDetails removedIndexes];
                if ([removedIndexes count]) {
                    [self.collectionView deleteItemsAtIndexPaths:[removedIndexes sn_indexPathWithSection:0]];
                }
                
                NSIndexSet *insertedIndexes = [changeDetails insertedIndexes];
                if ([insertedIndexes count]) {
                    NSArray<NSIndexPath *> *indexPaths = [insertedIndexes sn_indexPathWithSection:0];
                    
                    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
                        [self.collectionView insertItemsAtIndexPaths:indexPaths];
//                        [self collectionView:self.collectionView didSelectItemAtIndexPath:indexPaths[0]];
                        [self.collectionView selectItemAtIndexPath:indexPaths[0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
                        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPaths[0]];
                        cell.selected = self.imagePickerController.allowsMultipleSelection;
                        
                    }else {
                        [self.collectionView insertItemsAtIndexPaths:indexPaths];
                    }
                }
                
                NSIndexSet *changedIndexes = [changeDetails changedIndexes];
                if ([changedIndexes count]) {
                    [self.collectionView reloadItemsAtIndexPaths:[changedIndexes sn_indexPathWithSection:0]];
                }
            } completion:nil];
        }
    });
}

#pragma mark - NSNotification Action
-(void)willChangeStatusBarOrientationNotification:(NSNotificationCenter *)sender {
    self.bottomController.frame = CGRectMake(0,[UIScreen mainScreen].bounds.size.height-50,
                                             [UIScreen mainScreen].bounds.size.width, 50);
    [self.collectionView reloadData];
}


#pragma mark - Custom Action
-(void)goImagePickerController {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSArray *mediaTypes = @[(NSString *)kUTTypeImage,(NSString *)kUTTypeMovie];
        if (self.imagePickerController.mediaType == SNImagePickerMediaTypeImage) {
            mediaTypes = @[(NSString *)kUTTypeImage];
        }
        if (self.imagePickerController.mediaType == SNImagePickerMediaTypeVideo) {
            mediaTypes = @[(NSString *)kUTTypeMovie];
        }

        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes = mediaTypes;
        picker.delegate = self;
        picker.videoMaximumDuration = self.imagePickerController.videoMaximumDuration;
        [self presentViewController:picker animated:true completion:nil];
    }
}

-(BOOL)returnCameraItem:(NSInteger)row finshBlock:(void(^)(NSInteger row,BOOL showCamera))block {
    if (self.imagePickerController.showCameraItem) {
        switch (self.imagePickerController.cameraShowType) {
            case SNImagePickerCameraShowAtLast:{
                if (row==_dataSource.count) {
                    !block?:block(row,true);
                    return true;
                }else {
                    !block?:block(row,false);
                    return false;
                }
            }break;
            case SNImagePickerCameraShowAtFirst:{
                if (row==0) {
                    !block?:block(row,true);
                    return true;
                }else {
                    row = row - 1;
                    !block?:block(row,false);
                    return false;
                }
            }break;
            default:
                break;
        }
    }
    return false;
}

-(void)setObserver:(id)obsetver remove:(BOOL)remove {
    if (remove) {
        [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:obsetver];
        [[NSNotificationCenter defaultCenter] removeObserver:obsetver];
    }else {
        [[NSNotificationCenter defaultCenter] addObserver:obsetver selector:@selector(willChangeStatusBarOrientationNotification:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
        [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:obsetver];
    }
}



#pragma mark - Button Action
-(void)doneBtn:(id)sender {
    SNImagePickerController *picker = self.imagePickerController;
    if (picker.selectAssets.count< picker.minCountOfSelection) {
        NSString *message = LocalizeString(@"assets.done");
        NSString *cancel = LocalizeString(@"photo.ok");
        message = [NSString stringWithFormat:message,picker.minCountOfSelection];
        [self showAlertWithMessage:message cancelButtonTitle:cancel];
        return;
    }
   
    
    SEL selector = @selector(sn_imagePickerController:didFinishPickingAssets:);
    if ([picker.pickerDelegate respondsToSelector:selector]) {
        [picker.pickerDelegate sn_imagePickerController:picker
                                 didFinishPickingAssets:picker.selectAssets.array];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - get
-(UIBarButtonItem *)doneBtn {
    SNImagePickerController *picker = self.imagePickerController;
    if (!_doneBtn && picker.allowsMultipleSelection) {
        _doneBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItemDone) target:self action:@selector(doneBtn:)];
    }
    return _doneBtn;
}

-(UIView *)bottomController {
    if (!_bottomController) {
        _bottomController = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height-50, self.view.width, 50)];
        _bottomController.backgroundColor = [UIColor whiteColor];
        
        UIButton *preview = [[UIButton alloc]initWithFrame:CGRectMake(8, 8, 80, 50-8*2)];
        [preview setTitleColor:[UIColor colorWithRed:0 green:122/255.0 blue:255 alpha:1] forState:(UIControlStateNormal)];
        preview.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [preview setTitle:LocalizeString(@"photo.preview") forState:(UIControlStateNormal)];
        [_bottomController addSubview:preview];
        
    }
    return _bottomController;
}

#pragma mark - set
-(void)setDataSource:(PHFetchResult *)dataSource {
    _dataSource = [dataSource copy];
    [self.imagePickerController.selectAssets removeAllObjects];
    [self.collectionView reloadData];
}

@end
