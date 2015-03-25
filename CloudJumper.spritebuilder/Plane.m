//
//  Plane.m
//  CloudJumper
//
//  Created by Tony Fu on 2/23/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Plane.h"

@implementation Plane

- (void)didLoadFromCCB
{
    self.physicsBody.collisionType = @"plane";
}

@end
