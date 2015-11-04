//
//  DDSignAssetsController.m
//  TDImagePicker
//
//  Created by Su Jiandong on 15/11/4.
//  Copyright © 2015年 Su Jiandong. All rights reserved.
//
#import "TDImagePreviewController.h"
#import "TDSignAssetsCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

#import "TDColor.h"

@implementation NSIndexSet (Convenience)

- (NSArray *)qb_indexPathsFromIndexesWithSection:(NSUInteger)section
{
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [indexPaths addObject:[NSIndexPath indexPathForItem:idx inSection:section]];
    }];
    return indexPaths;
}
@end

@interface TDImagePreviewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,DDSignAssetsCellDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *showAssets;

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) ALAsset *currentAsset;
@property (nonatomic, strong) DDImagePickBlock block;

@end

@implementation TDImagePreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [TDColor backgroundColor];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.view addSubview:self.collectionView];
        [self.view sendSubviewToBack:self.collectionView];
        [self buildTopView];
        [self buildBottomView];
    }
    return self;
}

- (instancetype)initWithMaxNum:(NSInteger )maxNum andCallback:(DDImagePickBlock )callblock
{
    self = [self init];
    if (self) {
        self.maxNum = maxNum;
        self.block = callblock;
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO
                                                 withAnimation:UIStatusBarAnimationSlide];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    if (self.indexPath) {
        [self.collectionView scrollToItemAtIndexPath:self.indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        NSIndexPath *indexPath = [self indexPathOfCell];
        self.currentAsset = self.assets[indexPath.row];
    } else {
        self.currentAsset = self.selectAssets[0];
    }
    self.selectButton.selected = [self.selectAssets containsObject:self.currentAsset];
}

-(void)buildTopView
{
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    _topView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
    [self.view addSubview:_topView];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = CGRectMake(15, 32 - 25/2.0, 0, 0);
    [self.backButton setTitle:@"back" forState:UIControlStateNormal];
    self.backButton.titleLabel.font = FONT(15);
    [self.backButton sizeToFit];
    [self.backButton setTitleColor:[TDColor textColor] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:self.backButton];
    
    self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectButton.frame = CGRectMake(SCREEN_WIDTH - 25 - 15, 32 - 25/2.0, 25, 25);
    [self.selectButton setBackgroundImage:[UIImage imageNamed:@"photoDeselected"] forState:UIControlStateNormal];
    [self.selectButton setBackgroundImage:[UIImage imageNamed:@"photoSelected"] forState:UIControlStateSelected];
    [self.selectButton addTarget:self action:@selector(selectPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:self.selectButton];
}

-(void)buildBottomView
{
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44)];
    _bottomView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
    [self.view addSubview:_bottomView];
    
    self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.doneButton.frame = CGRectMake(SCREEN_WIDTH - 80 -15, 0, 80, 44);
    [self.doneButton setTitle:@"完成" forState:UIControlStateNormal];
    self.doneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.doneButton.titleLabel.font = FONT(15);
    [self.doneButton setTitleColor:[TDColor textColor] forState:UIControlStateNormal];
    self.doneButton.userInteractionEnabled = NO;
    [self.doneButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:self.doneButton];
}

-(void)selectPhoto:(UIButton *)btn
{
 
    if (self.maxNum == self.selectAssets.count && !btn.selected) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"最多只能选择 %ld 张",(long)self.maxNum] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        //        [[HUDManager sharedHUDManager] showErrorWithHint:[NSString stringWithFormat:@"最多只能选择 %ld 张",(long)self.maxNum]];
        [alert show];

        return;
    }
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self.selectAssets addObject:self.currentAsset];
    } else {
        [self.selectAssets removeObject:self.currentAsset];
    }
    if (self.selectAssets.count>0) {
        [self.doneButton setTitleColor:[TDColor textLightColor] forState:UIControlStateNormal];
        self.doneButton.userInteractionEnabled = YES;
    } else {
        [self.doneButton setTitleColor:[TDColor textColor] forState:UIControlStateNormal];
        self.doneButton.userInteractionEnabled = NO;
    }
    [self.doneButton setTitle:[NSString stringWithFormat:@"完成 (%lu)",(unsigned long)self.selectAssets.count] forState:UIControlStateNormal];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)hideNav
{
    _topView.hidden = !_topView.hidden;
    _bottomView.hidden = !_bottomView.hidden;
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

-(NSArray *)showAssets
{
    if (!_showAssets) {
        _showAssets = [NSArray arrayWithArray:self.selectAssets];
    }
    return _showAssets;
}

-(void)setSelectAssets:(NSMutableArray *)selectAssets
{
    if (_selectAssets == nil) {
        _selectAssets = [NSMutableArray array];
    }
    _selectAssets = selectAssets;
    if (self.type == 2) {
        self.currentAsset = selectAssets [0];
    }
    if (selectAssets.count>0) {
        [self.doneButton setTitleColor:[TDColor textLightColor] forState:UIControlStateNormal];
        self.doneButton.userInteractionEnabled = YES;
    }
    [self.doneButton setTitle:[NSString stringWithFormat:@"完成 (%lu)",(unsigned long)self.selectAssets.count] forState:UIControlStateNormal];

    [self.collectionView reloadData];
}

-(void)setAssets:(NSMutableArray *)assets
{
    _assets = assets;
    if (_assets == nil) {
        _assets = [NSMutableArray array];
    }
    [self.collectionView reloadData];
}

-(void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(self.view.width, self.view.height);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-5, 0, SCREEN_WIDTH+10, SCREEN_HEIGHT) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[TDSignAssetsCell class] forCellWithReuseIdentifier:@"DDAssetsViewCell"];
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.type == 1) {
        return self.assets.count;
    }
    return self.showAssets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TDSignAssetsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DDAssetsViewCell" forIndexPath:indexPath];
    cell.tag = indexPath.row;
    ALAsset *asset;
    if (self.type == 1) {
        asset = self.assets[indexPath.row];
    } else {
        asset = self.showAssets[indexPath.row];
    }
    cell.indexPath = indexPath;
    ALAssetRepresentation* representation = [asset defaultRepresentation];
    
    CGImageRef ref = [representation fullResolutionImage];
    UIImage *img = [[UIImage alloc]initWithCGImage:ref scale:[representation scale] orientation:UIImageOrientationUp];
    cell.imageView.image = img;//[UIImage imageWithCGImage:asset.aspectRatioThumbnail];
    cell.selectBtn.selected = [self.selectAssets containsObject:asset];
    cell.delegate = self;
    return cell;
}


-(void)didSelectAtIndexPath:(NSIndexPath *)indexPath
{
    ALAsset *asset;
    if (self.type == 1) {
        asset = self.assets[indexPath.row];
    } else {
        asset = self.selectAssets[indexPath.row];
    }
    [self.selectAssets addObject:asset];
}

-(void)deSelectAtIndexPath:(NSIndexPath *)indexPath
{
    ALAsset *asset;
    if (self.type == 1) {
        asset = self.assets[indexPath.row];
    } else {
        asset = self.selectAssets[indexPath.row];
    }
    [self.selectAssets removeObject:asset];
}

#pragma mark --UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.width+10, self.view.height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self hideNav];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSIndexPath *indexPath = [self indexPathOfCell];
    if (self.type == 2) {
        self.currentAsset = self.showAssets[indexPath.row];
    } else {
        self.currentAsset = self.assets[indexPath.row];
    }
    if (self.selectAssets.count>0) {
        [self.doneButton setTitleColor:[TDColor textLightColor] forState:UIControlStateNormal];
    } else {
         [self.doneButton setTitleColor:[TDColor textColor] forState:UIControlStateNormal];
    }
    self.selectButton.selected = [self.selectAssets containsObject:self.currentAsset];
}


-(NSIndexPath *)indexPathOfCell
{
    CGPoint centerPoint = CGPointMake(self.collectionView.frame.size.width / 2 + self.collectionView.contentOffset.x, self.collectionView.frame.size.height /2 + self.collectionView.contentOffset.y);
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:centerPoint];
    return indexPath;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
