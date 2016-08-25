//
//  HGSession.h
//  hgClock
//
//  Created by zhh on 16/8/23.
//  Copyright © 2016年 zhh. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const kUserDefaultKey = @"kUserDefaultKey";
static NSString * const kClockKey = @"kClockKey";
static NSString * const kWeekKey = @"kWeekKey";

@interface HGSession : NSObject

+ (HGSession *)sharedHGSession;

- (void)setUserDefault:(id)value forKey:(NSString *)key;
- (id)userDefaultForKey:(NSString *)key;

@end
