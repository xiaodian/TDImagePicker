//
//  UIView+Position.h
//  TDImagePicker
//
//  Created by Su Jiandong on 15/11/4.
//  Copyright © 2015年 Su Jiandong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(Position)

@property(nonatomic) CGPoint position;
@property(nonatomic) CGPoint left;
@property(nonatomic) CGPoint right;
@property(nonatomic) float positionX;
@property(nonatomic) float positionY;
@property(nonatomic,readonly) float endX;
@property(nonatomic,readonly) float endY;
@property(nonatomic) float centerX;
@property(nonatomic) float centerY;

@property(nonatomic) CGSize size;
@property(nonatomic) float width;
@property(nonatomic) float height;

@end
