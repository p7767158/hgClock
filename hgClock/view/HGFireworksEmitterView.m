//
//  HGFireworksEmitterView.m
//  hgClock
//
//  Created by zhh on 16/8/24.
//  Copyright © 2016年 zhh. All rights reserved.
//

#import "HGFireworksEmitterView.h"
#import <QuartzCore/QuartzCore.h>

@interface HGFireworksEmitterView ()

@property (nonatomic, strong) CAEmitterLayer *fireEmitter;

@end

@implementation HGFireworksEmitterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _fireEmitter = (CAEmitterLayer *)self.layer;
        _fireEmitter.renderMode = kCAEmitterLayerAdditive;
        _fireEmitter.emitterShape = kCAEmitterLayerCircle;
        
        CAEmitterCell *fire = [CAEmitterCell emitterCell];
        fire.birthRate = 15;
        fire.lifetime = 0.5;
        fire.lifetimeRange = 0;
        
        fire.color = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.7].CGColor;
        fire.contents = (id)[[UIImage imageNamed:@"test.png"] CGImage];
        fire.velocity = 30;
        fire.velocityRange = 1;
        fire.emissionRange = 3;
        
        fire.scale = 0.5;
        fire.scaleSpeed = 0.3;
        fire.spin = 2;
        
        fire.redSpeed = 1;
        fire.redRange = 1.5;
        
        fire.greenSpeed = 1;
        fire.greenRange = 1.5;
        fire.blueSpeed = 1;
        fire.blueRange = 1.5;
        
        
        [fire setName:@"fire"];
        
        _fireEmitter.emitterCells = [NSArray arrayWithObject:fire];
        
    }
    return self;
}

+ (Class)layerClass //3
{
    //configure the UIView to have emitter layer
    return [CAEmitterLayer class];
}

@end
