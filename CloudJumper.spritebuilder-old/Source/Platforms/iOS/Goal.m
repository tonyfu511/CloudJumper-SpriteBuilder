//
//  Goal.m
//  CloudJumper
//
//  Created by Tony Fu on 4/9/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Goal.h"

@implementation Goal

- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"goal";
    self.physicsBody.sensor = YES;
}

@end
