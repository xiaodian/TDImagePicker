//
//  DDImageGroupPickerView.h
//  TDImagePicker
//
//  Created by Su Jiandong on 15/11/4.
//  Copyright © 2015年 Su Jiandong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef void(^DDGroupPickBlock) (NSInteger index);

@interface TDImageGroupPickerView : UIView
@property (nonatomic,strong) NSMutableArray *assetGroups;
@property (nonatomic,assign) BOOL isShow;
-(void)reloadData;
-(void)show;
-(void)hide;
-(void)selectWithBlock:(DDGroupPickBlock )callback;
@end
