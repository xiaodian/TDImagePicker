//
//  DDSignAssetsCell.h
//  TDImagePicker
//
//  Created by Su Jiandong on 15/11/4.
//  Copyright © 2015年 Su Jiandong. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "TDimagePickerUtils.h"
@protocol DDSignAssetsCellDelegate <NSObject>

-(void)didSelectAtIndexPath:(NSIndexPath *)indexPath;
-(void)deSelectAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface TDSignAssetsCell : UICollectionViewCell
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIButton *selectBtn;
@property (nonatomic,strong) NSIndexPath *indexPath;

@property (nonatomic,assign) id<DDSignAssetsCellDelegate> delegate;

@end
