//
//  DDAssetsViewCell.m
//  TDImagePicker
//
//  Created by Su Jiandong on 15/11/4.
//  Copyright © 2015年 Su Jiandong. All rights reserved.
//

#import "TDAssetsViewCell.h"
#import "TDimagePickerUtils.h"
@implementation TDAssetsViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH-3)/3.0, (SCREEN_WIDTH-3)/3.0)];
        [self addSubview:self.imageView];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        CGFloat w = (SCREEN_WIDTH-3)/3.0;
        
        self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.selectBtn.frame = CGRectMake(w - 30 + 2.5, 2.5, 25, 25);
        [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"photoDeselected"] forState:UIControlStateNormal];
        [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"photoSelected"] forState:UIControlStateSelected];
        [self.selectBtn addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.selectBtn];
    }
    return self;
}


-(void)selectImage:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected) {
        if ([self.delegate respondsToSelector:@selector(didSelectAtIndexPath:)]) {
            [self.delegate didSelectAtIndexPath:self.indexPath];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(deSelectAtIndexPath:)]) {
            [self.delegate deSelectAtIndexPath:self.indexPath];
        }
    }
}

@end
