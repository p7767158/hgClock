//
//  HGGlobal.m
//  hgClock
//
//  Created by zhh on 16/8/23.
//  Copyright © 2016年 zhh. All rights reserved.
//

#import "HGGlobal.h"

@implementation HGGlobal

+ (NSString *)formatTime:(NSTimeInterval)time withFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    return [formatter stringFromDate:date];
}

+ (NSAttributedString *)makeAttString:(NSString *)str withFont:(UIFont *)font withColor:(UIColor *)color
{
    NSString *string;
    if (!str) {
        string = @"";
    } else {
        if ([str isKindOfClass:NSNumber.class]) {
            string = [(NSNumber *)str stringValue];
        } else {
            string = str;
        }
    }
    return [[NSAttributedString alloc] initWithString:string
                                           attributes:@{
                                                        NSFontAttributeName:font,
                                                        NSForegroundColorAttributeName:color
                                                        }];
}

@end
