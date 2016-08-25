//
//  HGGlobal.h
//  hgClock
//
//  Created by zhh on 16/8/23.
//  Copyright © 2016年 zhh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HGGlobal : NSObject

#define SYNTHESIZE_SINGLETON_FOR_HEADER(classname)\
+ (classname *)shared##classname;

#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
\
static classname *shared##classname = nil; \
\
+ (classname *)shared##classname \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [[super allocWithZone:NULL] init]; \
} \
} \
\
return shared##classname; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
return [self shared##classname];\
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return self; \
} \
\

#define RGBA(r, g, b, a) \
[UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define UIColorFrom0x(rgbValue) [UIColor colorWithRed:((float)(((rgbValue) & 0xFF0000) >> 16))/255.0 green:((float)(((rgbValue) & 0xFF00) >> 8))/255.0 blue:((float)((rgbValue) & 0xFF))/255.0 alpha:1.0]

+ (NSString *)formatTime:(NSTimeInterval)time withFormat:(NSString *)format;
+ (NSAttributedString *)makeAttString:(NSString *)str withFont:(UIFont *)font withColor:(UIColor *)color;

@end
