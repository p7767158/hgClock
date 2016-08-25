//
//  HGWeekTableViewCell.m
//  hgClock
//
//  Created by zhh on 16/8/23.
//  Copyright © 2016年 zhh. All rights reserved.
//

#import "HGWeekTableViewCell.h"
#import <Masonry/Masonry.h>

@interface HGWeekTableViewCell ()

@property (nonatomic, strong) UIImageView *subImg;

@end

@implementation HGWeekTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLb];
        [self.contentView addSubview:self.subImg];
     
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.centerY.equalTo(self.contentView);
        }];
        [self.subImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-10);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (UILabel *)titleLb
{
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] init];
        _titleLb.font = [UIFont systemFontOfSize:14];
    }
    return _titleLb;
}

- (UIImageView *)subImg
{
    if (!_subImg) {
        _subImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_selected"]];
        _subImg.hidden = YES;
    }
    return _subImg;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.subImg.hidden = !self.subImg.hidden;
    }
    // Configure the view for the selected state
}

@end
