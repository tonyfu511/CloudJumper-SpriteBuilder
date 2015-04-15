//
//  TopNail.m
//  CloudJumper
//
//  Created by Tony Fu on 4/14/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "TopNail.h"

@implementation TopNail

- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"topnail";
    self.physicsBody.sensor = YES;
}

@end
