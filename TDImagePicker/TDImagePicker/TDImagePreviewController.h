//
//  DDSignAssetsController.h
//  TDImagePicker
//
//  Created by Su Jiandong on 15/11/4.
//  Copyright © 2015年 Su Jiandong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^DDImagePickBlock) (NSArray *images);

@interface TDImagePreviewController : UIViewController

@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) NSMutableArray *selectAssets;
@property (nonatomic, strong) NSIndexPath *indexPath; //type 2
@property (nonatomic, assign) int type;
@property (nonatomic,assign) NSInteger maxNum;
- (instancetype)initWithMaxNum:(NSInteger )maxNum andCallback:(DDImagePickBlock )callblock;

@end
