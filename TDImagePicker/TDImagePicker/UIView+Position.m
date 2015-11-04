//
//  UIView+Position.m
//  TDImagePicker
//
//  Created by Su Jiandong on 15/11/4.
//  Copyright © 2015年 Su Jiandong. All rights reserved.
//

#import "UIView+Position.h"

@implementation UIView(Position)

- (CGPoint)position {
    return self.frame.origin;
}

- (void)setPosition:(CGPoint)position {
    self.frame = CGRectMake(position.x, position.y, self.frame.size.width, self.frame.size.height);
}

- (CGPoint)left {
    return CGPointMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height / 2);
}

- (void)setLeft:(CGPoint)position {
    self.frame = CGRectMake(position.x, position.y - self.frame.size.height / 2, self.frame.size.width, self.frame.size.height);
}

- (CGPoint)right {
    return CGPointMake(self.frame.origin.x + self.frame.size.width, self.frame.origin.y + self.frame.size.height / 2);
}

- (void)setRight:(CGPoint)position {
    self.frame = CGRectMake(position.x - self.frame.size.width, position.y - self.frame.size.height / 2, self.frame.size.width, self.frame.size.height);
}

- (float)positionX {
    return self.frame.origin.x;
}

- (void)setPositionX:(float)x {
    self.frame = CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (float)positionY {
    return self.frame.origin.y;
}

- (void)setPositionY:(float)y {
    self.frame = CGRectMake(self.frame.origin.x, y, self.frame.size.width, self.frame.size.height);
}

- (float)endX {
    return self.frame.origin.x + self.frame.size.width;
}

- (float)endY {
    return self.frame.origin.y + self.frame.size.height;
}

- (float)centerX {
    return self.center.x;
}

- (void)setCenterX:(float)x {
    self.center = CGPointMake(x, self.centerY);
}

- (float)centerY {
    return self.center.y;
}

- (void)setCenterY:(float)y {
    self.center = CGPointMake(self.centerX, y);
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
}

- (float)width {
    return self.frame.size.width;
}

- (void)setWidth:(float)width {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
}

- (float)height {
    return self.frame.size.height;
}

- (void)setHeight:(float)height {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
}

@end
