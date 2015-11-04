//
//  DDImageGroupPickerView.m
//  TDImagePicker
//
//  Created by Su Jiandong on 15/11/4.
//  Copyright © 2015年 Su Jiandong. All rights reserved.
//
#import "TDImageGroupPickerView.h"
#import "TDAssetGroupCell.h"
#import "TDimagePickerUtils.h"
@interface TDImageGroupPickerView()<UITableViewDataSource ,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DDGroupPickBlock block;
@end
@implementation TDImageGroupPickerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 64, SCREEN_WIDTH, 0);
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
        self.assetGroups = [NSMutableArray array];
        [self addSubview:self.tableView];
    }
    return self;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[TDAssetGroupCell class] forCellReuseIdentifier:@"cell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.assetGroups.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TDAssetGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.assetsGroup = self.assetGroups[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.block) {
        self.block(indexPath.row);
    }
    [self hide];
}

-(void)show
{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect sframe = self.frame;
        CGRect tframe = self.tableView.frame;
        sframe.size.height = SCREEN_HEIGHT - 64;
        tframe.size.height = SCREEN_HEIGHT - 64;
        self.frame = sframe;
        self.tableView.frame = tframe;
    }];
    self.isShow = YES;
}

-(void)hide
{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect sframe = self.frame;
        CGRect tframe = self.tableView.frame;
        sframe.size.height = 0;
        tframe.size.height = 0;
        self.frame = sframe;
        self.tableView.frame = tframe;
    }];
    self.isShow = NO;
}
-(void)selectWithBlock:(DDGroupPickBlock)callback
{
    self.block = callback;
}

-(void)reloadData
{
    [self.tableView reloadData];
}

@end
