//
//  DDAssetsViewController.m
//  TDImagePicker
//
//  Created by Su Jiandong on 15/11/4.
//  Copyright © 2015年 Su Jiandong. All rights reserved.
//

#import "TDImagePickerController.h"
#import "TDAssetsViewCell.h"
#import "TDImagePreviewController.h"
#import "TDImageGroupPickerView.h"
#import "TDColor.h"
@interface TDImagePickerController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,DDAssetsViewCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) NSMutableArray *selectAssets;
@property (nonatomic, strong) NSMutableArray *selectIndexPath;
@property (nonatomic, strong) UIButton *previewButton;
@property (nonatomic, strong) UIButton *doneButton;
@property (strong, nonatomic)  ALAssetsGroup *assetsGroup;
@property (nonatomic, strong) NSMutableArray *assetsGroups;
@property (nonatomic, strong) UIButton *titleButton;
@property (nonatomic, strong) TDImageGroupPickerView *groupPicker;

@property (nonatomic, strong) DDImagePickBlock block;
@end

@implementation TDImagePickerController

@synthesize assetsGroup = _assetsGroup;

- (instancetype)initWithMaxNum:(NSInteger )maxNum andCallback:(DDImagePickBlock )callblock
{
    self = [self init];
    if (self) {
        if (maxNum > 0) {
            self.maxNum =maxNum;
        }
        self.block = callblock;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.maxNum = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.assetsGroups = [NSMutableArray array];
    self.assets = [NSMutableArray array];
    self.selectAssets = [NSMutableArray array];
    self.selectIndexPath = [NSMutableArray array];
    [self buildBottomView];
    [self loadAssetsGroups];
    [self.view addSubview:self.groupPicker];
    self.navigationItem.titleView = self.titleButton;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(dismiss)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
    [self.doneButton setTitle:[NSString stringWithFormat:@"完成 (%lu)",(unsigned long)self.selectAssets.count] forState:UIControlStateNormal];
    if (self.selectAssets.count == 0) {
        [self.previewButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.doneButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.previewButton.userInteractionEnabled = NO;
        self.doneButton.userInteractionEnabled = NO;
    } else {
        [self.previewButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.doneButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.previewButton.userInteractionEnabled = YES;
        self.doneButton.userInteractionEnabled = YES;
    }

}

-(void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadAssetsGroups
{
    [self.assetsGroups removeAllObjects];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        @autoreleasepool {
            void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop){
                if (group == nil){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (!self.assetsGroup) {
                            if (self.assetsGroups.count>0) {
                                self.assetsGroup = self.assetsGroups[0];
                                [_titleButton setTitle:[self.assetsGroup valueForProperty:ALAssetsGroupPropertyName] forState:UIControlStateNormal];
                                [_titleButton sizeToFit];
                                _titleButton.width += 15;
                            }
                        }
                    });
                    return;
                }
                if (group.numberOfAssets > 0) {
                    [self.assetsGroups insertObject:group atIndex:0];
                    [self.groupPicker.assetGroups insertObject:group atIndex:0];
                    [self.groupPicker reloadData];

                }
                if (!self.assetsGroup && group.numberOfAssets > 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:@"Camera Roll"] || [[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:@"相机胶卷"]) {
                            self.assetsGroup = group;
                            [_titleButton setTitle:[group valueForProperty:ALAssetsGroupPropertyName] forState:UIControlStateNormal];
                            [_titleButton sizeToFit];
                            _titleButton.width += 15;
                        }
                    });
                }
            };
            void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
                NSLog(@"A problem occured. Error: %@", error.localizedDescription);
            };
            [[TDImagePickerController defaultAssetsLibrary] enumerateGroupsWithTypes:ALAssetsGroupAll
                                                                               usingBlock:assetGroupEnumerator
                                                                             failureBlock:assetGroupEnumberatorFailure];
        }
    });
}

+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static ALAssetsLibrary *assetsLibrary = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        assetsLibrary = [[ALAssetsLibrary alloc] init];
        [assetsLibrary writeImageToSavedPhotosAlbum:nil metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) { }];
    });
    return assetsLibrary;
}
- (void)reloadData
{
    [self.collectionView reloadData];
}

- (void)setAssetsGroup:(ALAssetsGroup *)theAssetsGroup
{
    @synchronized (self){
        if (_assetsGroup != theAssetsGroup){
            _assetsGroup = theAssetsGroup;
            [_assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
            [self loadAssets];
            [self reloadData];
        }
    }
}

- (ALAssetsGroup *)assetsGroup
{
    ALAssetsGroup *ret = nil;
    @synchronized (self){
        ret = _assetsGroup;
    }
    return ret;
}

- (void)loadAssets
{
    [self.assets removeAllObjects];
    __weak TDImagePickerController *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        __strong TDImagePickerController *strongSelf = weakSelf;
        @autoreleasepool {
            [strongSelf.assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                
                if (result == nil){
                    return;
                } else {
                    [self.assets insertObject:result atIndex:0];
                }
            }];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf reloadData];
        });
    });
}


-(UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
        [_collectionView registerClass:[TDAssetsViewCell class] forCellWithReuseIdentifier:@"DDAssetsViewCell"];
    }
    return _collectionView;
}

-(void)buildBottomView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44)];
    view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
    [self.view addSubview:view];
    
    self.previewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.previewButton.frame = CGRectMake(15, 0, 80, 44);
    [self.previewButton setTitle:@"预览" forState:UIControlStateNormal];
    self.previewButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.previewButton.titleLabel.font = FONT(15);
    [self.previewButton setTitleColor:[TDColor textColor] forState:UIControlStateNormal];

    [self.previewButton addTarget:self action:@selector(preview) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.previewButton];
    
    self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.doneButton.frame = CGRectMake(SCREEN_WIDTH - 80 -15, 0, 80, 44);
    [self.doneButton setTitle:@"完成" forState:UIControlStateNormal];
    self.doneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.doneButton.titleLabel.font = FONT(15);
    [self.doneButton setTitleColor:[TDColor textColor] forState:UIControlStateNormal];
    [self.doneButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.doneButton];
}

-(void)done
{
    NSMutableArray *images = [NSMutableArray array];
    for (ALAsset *set in self.selectAssets) {
        ALAssetRepresentation* representation = [set defaultRepresentation];
        CGImageRef imageR =  [representation fullResolutionImage];
        UIImage *image = [UIImage imageWithCGImage:imageR scale:[representation scale] orientation:(UIImageOrientation)representation.orientation];
        [images addObject:image];
    }
    if (self.block) {
        self.block(images);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(UIButton *)titleButton
{
    if (!_titleButton) {
        _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_titleButton setImage:[UIImage imageNamed:@"drapUp"] forState:UIControlStateNormal];
        [_titleButton setImage:[UIImage imageNamed:@"drapDown"] forState:UIControlStateSelected];
        _titleButton.titleLabel.font = FONT(14);
        [_titleButton setTitleColor:[TDColor textLightColor] forState:UIControlStateNormal];
        [_titleButton sizeToFit];
        _titleButton.width += 15;
        [_titleButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, _titleButton.width/2)];
        [_titleButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        _titleButton.center = self.navigationController.navigationBar.center;
        [_titleButton addTarget:self action:@selector(chooseGroup:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _titleButton;
}

-(void)chooseGroup:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (self.groupPicker.isShow) {
        [self.groupPicker hide];
    } else {
        [self.groupPicker show];
    }
}

-(TDImageGroupPickerView *)groupPicker
{
    if (!_groupPicker) {
        _groupPicker = [[TDImageGroupPickerView alloc] init];
        [_groupPicker selectWithBlock:^(NSInteger index) {
            ALAssetsGroup *group = self.assetsGroups[index];
            NSString *name = [group valueForProperty:ALAssetsGroupPropertyName];
             [_titleButton setTitle:name forState:UIControlStateNormal];
            [_titleButton sizeToFit];
            _titleButton.width += 15;
            _titleButton.selected =!_titleButton.selected;
            self.assetsGroup = group;
        }];
    }
    return _groupPicker;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TDAssetsViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DDAssetsViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.tag = indexPath.row;
    ALAsset *asset = self.assets[indexPath.row];
    cell.selectBtn.selected = [self.selectAssets containsObject:asset];
    cell.imageView.image = [UIImage imageWithCGImage:asset.aspectRatioThumbnail];
    return cell;
}

//- (UIImage *)fixOrientation:(UIImage *)aImage {
//    
//    // No-op if the orientation is already correct
//    if (aImage.imageOrientation == UIImageOrientationUp)
//        return aImage;
//    
//    // We need to calculate the proper transformation to make the image upright.
//    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
//    CGAffineTransform transform = CGAffineTransformIdentity;
//    
//    switch (aImage.imageOrientation) {
//        case UIImageOrientationDown:
//        case UIImageOrientationDownMirrored:
//            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
//            transform = CGAffineTransformRotate(transform, M_PI);
//            break;
//            
//        case UIImageOrientationLeft:
//        case UIImageOrientationLeftMirrored:
//            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
//            transform = CGAffineTransformRotate(transform, M_PI_2);
//            break;
//            
//        case UIImageOrientationRight:
//        case UIImageOrientationRightMirrored:
//            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
//            transform = CGAffineTransformRotate(transform, -M_PI_2);
//            break;
//        default:
//            break;
//    }
//    
//    switch (aImage.imageOrientation) {
//        case UIImageOrientationUpMirrored:
//        case UIImageOrientationDownMirrored:
//            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
//            transform = CGAffineTransformScale(transform, -1, 1);
//            break;
//            
//        case UIImageOrientationLeftMirrored:
//        case UIImageOrientationRightMirrored:
//            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
//            transform = CGAffineTransformScale(transform, -1, 1);
//            break;
//        default:
//            break;
//    }
//    
//    // Now we draw the underlying CGImage into a new context, applying the transform
//    // calculated above.
//    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
//                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
//                                             CGImageGetColorSpace(aImage.CGImage),
//                                             CGImageGetBitmapInfo(aImage.CGImage));
//    CGContextConcatCTM(ctx, transform);
//    switch (aImage.imageOrientation) {
//        case UIImageOrientationLeft:
//        case UIImageOrientationLeftMirrored:
//        case UIImageOrientationRight:
//        case UIImageOrientationRightMirrored:
//            // Grr...
//            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
//            break;
//            
//        default:
//            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
//            break;
//    }
//    
//    // And now we just create a new UIImage from the drawing context
//    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
//    UIImage *img = [UIImage imageWithCGImage:cgimg];
//    CGContextRelease(ctx);
//    CGImageRelease(cgimg);
//    return img;
//}

-(void)didSelectAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.maxNum == self.selectAssets.count) {
        TDAssetsViewCell *cell = (TDAssetsViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        cell.selectBtn.selected = NO;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"最多只能选择 %ld 张",(long)self.maxNum] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [[HUDManager sharedHUDManager] showErrorWithHint:[NSString stringWithFormat:@"最多只能选择 %ld 张",(long)self.maxNum]];
        [alert show];
        return;
    }
    ALAsset *asset = self.assets[indexPath.row];
    [self.selectAssets addObject:asset];
    [self.previewButton setTitleColor:[TDColor textLightColor] forState:UIControlStateNormal];
    [self.doneButton setTitleColor:[TDColor textLightColor] forState:UIControlStateNormal];
    self.previewButton.userInteractionEnabled = YES;
    self.doneButton.userInteractionEnabled = YES;
    [self.doneButton setTitle:[NSString stringWithFormat:@"完成 (%lu)",(unsigned long)self.selectAssets.count] forState:UIControlStateNormal];
}

-(void)deSelectAtIndexPath:(NSIndexPath *)indexPath
{
    ALAsset *asset = self.assets[indexPath.row];
    [self.selectAssets removeObject:asset];
    [self.doneButton setTitle:[NSString stringWithFormat:@"完成 (%lu)",(unsigned long)self.selectAssets.count] forState:UIControlStateNormal];
    if (self.selectAssets.count == 0) {
        [self.previewButton setTitleColor:[TDColor textColor] forState:UIControlStateNormal];
        [self.doneButton setTitleColor:[TDColor textColor] forState:UIControlStateNormal];
        self.previewButton.userInteractionEnabled = NO;
        self.doneButton.userInteractionEnabled = NO;
    }
}

#pragma mark --UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float size = (self.view.width - 3) / 3.0;
    return CGSizeMake(size, size);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.5;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TDImagePreviewController *sc = [[TDImagePreviewController alloc] initWithMaxNum:self.maxNum andCallback:^(NSArray *images) {
        [self done];
    }];
    sc.type = 1;
    sc.assets = self.assets;
    sc.selectAssets = self.selectAssets;
    sc.indexPath = indexPath;
    sc.maxNum = self.maxNum;
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationSlide];
    [self.navigationController pushViewController:sc animated:YES];
}

-(void)preview
{
    if (!self.selectAssets.count) {
        return ;
    }
    TDImagePreviewController *sc = [[TDImagePreviewController alloc] initWithMaxNum:self.maxNum andCallback:^(NSArray *images) {
        [self done];
    }];
    sc.type = 2;
    sc.selectAssets = self.selectAssets;
    sc.maxNum = self.maxNum;
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationSlide];
    sc.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:sc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
