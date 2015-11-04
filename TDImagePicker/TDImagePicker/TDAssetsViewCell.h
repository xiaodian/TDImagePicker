//
//  DDAssetsViewCell.h
//  TDImagePicker
//
//  Created by Su Jiandong on 15/11/4.
//  Copyright © 2015年 Su Jiandong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DDAssetsViewCellDelegate <NSObject>

-(void)didSelectAtIndexPath:(NSIndexPath *)indexPath;
-(void)deSelectAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface TDAssetsViewCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIButton *selectBtn;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,assign) id<DDAssetsViewCellDelegate> delegate;

@end


