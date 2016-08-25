//
//  HGAnimationCircleBtn.m
//  hgClock
//
//  Created by zhh on 16/8/24.
//  Copyright © 2016年 zhh. All rights reserved.
//

#import "HGAnimationCircleBtn.h"
#import "HGFireworksEmitterView.h"

@interface HGAnimationCircleBtn ()

@property (nonatomic, strong) HGFireworksEmitterView *emitterView;

@end

@implementation HGAnimationCircleBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _emitterView = [[HGFireworksEmitterView alloc] initWithFrame:CGRectZero];
        [self addSubview:_emitterView];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, self.frame.size.width / 2.0, self.frame.size.width / 2.0, self.frame.size.width / 2.0, 0, M_PI * 2, 0);
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.duration = 5;
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    animation.repeatCount = MAXFLOAT;
    animation.calculationMode = kCAAnimationPaced;
//    animation.fillMode = kCAFillModeForwards;
    animation.path = path;
    [_emitterView.layer addAnimation:animation forKey:@"test"];
}

@end
