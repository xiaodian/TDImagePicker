//
//  TDColor.m
//  TDImagePicker
//
//  Created by Su Jiandong on 15/11/4.
//  Copyright © 2015年 Su Jiandong. All rights reserved.
//

#import "TDColor.h"

@implementation TDColor

+ (UIColor*) navigationColor {
    return RGBCOLOR(103, 103, 103);
}

+ (UIColor*) tabbarColor {
    return RGBCOLOR(0xfa, 0xfa, 0xfa);
}

+ (UIColor*) textColor {
    return RGBCOLOR(0x87, 0x88, 0x8e);
}

+ (UIColor*) textPromptColor {
    return [UIColor colorWithRed:84/255.f green:84/255.f blue:88/255.f alpha:1];
}

+ (UIColor*) textLightColor {
    return RGBCOLOR(0xff, 0xff, 0xff);
}

+ (UIColor*) placeHolderColor {
    return RGBCOLOR(0x35, 0x35, 0x35);
}

+ (UIColor*) textDarkColor {
    return RGBCOLOR(0x44, 0x44, 0x44);
}

+ (UIColor*) backgroundColor {
    //return RGBCOLOR(0xf0, 0xf0, 0xf0);
    return RGBCOLOR(18, 18, 19);
}

+ (UIColor*) cellBackgroundColor {
    //return RGBCOLOR(0xf0, 0xf0, 0xf0);
    return RGBCOLOR(0x18, 0x18, 0x19);
}

+ (UIColor*) cellSelectedBackgroundColor {
    return RGBCOLOR(0x33, 0x33, 0x33);
}

+ (UIColor*) highlightColor {
    return RGBCOLOR(0x66, 0x66, 0x66);
}

+ (UIColor*) blueColor {
    return RGBCOLOR(0x00, 0x88, 0xc2);
}

+ (UIColor*) pinkColor {
    return RGBCOLOR(0xe1, 0x66, 0x9c);
}

+ (UIColor*) dashColor {
    return RGBCOLOR(0x20, 0x21, 0x23);
}

+ (UIColor*) blueControlColor {
    return RGBCOLOR(0x00, 0xa1, 0xe5);
}

+ (UIColor*) blueControlHighlightColor {
    return RGBCOLOR(0x00, 0x82, 0xb7);
}

+ (UIColor*) grayControlColor {
    return RGBCOLOR(0x34, 0x34, 0x36);
}

@end
