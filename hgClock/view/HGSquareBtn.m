
//
//  HGSquareBtn.m
//  hgClock
//
//  Created by zhh on 16/8/23.
//  Copyright © 2016年 zhh. All rights reserved.
//

#import "HGSquareBtn.h"
#import <Masonry/Masonry.h>

static const CGFloat kMargin = 10.f;

@implementation HGSquareBtn

+ (HGSquareBtn *)squareBtnWithTitle:(NSString *)title
{
    HGSquareBtn *btn = [HGSquareBtn buttonWithType:UIButtonTypeCustom];
    btn.layer.cornerRadius = 5.f;
    btn.layer.masksToBounds = YES;
    
    for (int i = 0; i < title.length; i++) {
        unichar ch = [title characterAtIndex:i];
        NSString *str = [NSString stringWithFormat:@"%c", ch];
        UILabel *lb = [[UILabel alloc] init];
        lb.text = str;
        switch (i) {
            case 0: {
                [lb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(btn).offset(kMargin);
                    make.left.equalTo(btn).offset(kMargin);
                }];
            }
                break;
            case 1: {
                [lb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(btn).offset(kMargin);
                    make.right.equalTo(btn).offset(-kMargin);
                }];
            }
                break;
            case 2: {
                [lb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(btn).offset(-kMargin);
                    make.left.equalTo(btn).offset(kMargin);
                }];
            }
                break;
            case 3: {
                [lb mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(btn).offset(-kMargin);
                    make.right.equalTo(btn).offset(-kMargin);
                }];
            }
                break;
        }
    }
    return btn;
}

@end
