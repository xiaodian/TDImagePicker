//
//  ViewController.m
//  TDImagePicker
//
//  Created by Su Jiandong on 15/11/4.
//  Copyright © 2015年 Su Jiandong. All rights reserved.
//

#import "ViewController.h"
#import "TDImagePickerController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)showImagePicker:(id)sender {
    TDImagePickerController *ic = [[TDImagePickerController alloc] initWithMaxNum:5 andCallback:^(NSArray *images) {
        NSLog(@"%lu",images.count);
    }];
    UINavigationController *nav  = [[UINavigationController alloc] initWithRootViewController:ic];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
