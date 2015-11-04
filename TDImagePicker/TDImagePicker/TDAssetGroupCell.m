//
//  DDAssetGroupCell.m
//  TDImagePicker
//
//  Created by Su Jiandong on 15/11/4.
//  Copyright © 2015年 Su Jiandong. All rights reserved.
//

#import "TDAssetGroupCell.h"
#import "TDimagePickerUtils.h"
#import "TDColor.h"
@interface TDAssetGroupCell()
@property (nonatomic, strong)UIImageView *coverImageView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *numLabel;
@end

@implementation TDAssetGroupCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [TDColor cellBackgroundColor];
        self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_disclosure"]];
        self.selectedBackgroundView = [UIView new];
        self.selectedBackgroundView.backgroundColor = [TDColor cellSelectedBackgroundColor];
        
        self.coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 50, 50)];
        [self.contentView addSubview:self.coverImageView];
        self.numLabel = [[UILabel alloc] init];
        self.numLabel.font = FONT(12);
        self.numLabel.textColor = [TDColor textColor];
        [self.contentView addSubview:self.numLabel];
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = FONT(16);
        self.nameLabel.textColor = [TDColor textColor];
        [self.contentView addSubview:self.nameLabel];

    }
    return self;
}

-(void)setAssetsGroup:(ALAssetsGroup *)assetsGroup
{
    _assetsGroup = assetsGroup;
    NSUInteger numberOfAssets = assetsGroup.numberOfAssets;
    self.nameLabel.text = [NSString stringWithFormat:@"%@", [assetsGroup valueForProperty:ALAssetsGroupPropertyName]];
    [self.nameLabel sizeToFit];
    self.nameLabel.center = self.contentView.center;
    self.nameLabel.positionX = 80;
    
    self.numLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)numberOfAssets];
    [self.numLabel sizeToFit];
    self.numLabel.center = self.contentView.center;
    self.numLabel.positionX = self.nameLabel.endX + 15;
    [self.coverImageView setImage:[UIImage imageWithCGImage:[assetsGroup posterImage]]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
