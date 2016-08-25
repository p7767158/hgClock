//
//  HGSession.m
//  hgClock
//
//  Created by zhh on 16/8/23.
//  Copyright © 2016年 zhh. All rights reserved.
//

#import "HGSession.h"
#import "HGGlobal.h"

@implementation HGSession

SYNTHESIZE_SINGLETON_FOR_CLASS(HGSession);

- (void)setUserDefault:(id)value forKey:(NSString *)key
{
    NSMutableDictionary *defaults = [[self userDefaults] mutableCopy];
    if (!defaults) {
        defaults = [[NSMutableDictionary alloc] init];
    }
    if (nil != value) {
        defaults[key] = value;
        [[NSUserDefaults standardUserDefaults] setObject:defaults forKey:kUserDefaultKey];
    } else {
        [defaults removeObjectForKey:key];
        [[NSUserDefaults standardUserDefaults] setObject:defaults forKey:kUserDefaultKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)userDefaultForKey:(NSString *)key
{
    id value = [self userDefaults][key];
    if (value) {
        return value;
    } else {
        return [NSNull null];
    }
}

- (NSDictionary *)userDefaults
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultKey];
}

@end
