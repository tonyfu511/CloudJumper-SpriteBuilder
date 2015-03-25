//
//  CharWalkLeft.m
//  CloudJumper
//
//  Created by Tony Fu on 2/23/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CharWalk.h"

@implementation CharWalk

- (void)didLoadFromCCB
{
    self.position = ccp(155, -30);
    self.physicsBody.collisionType = @"character";
}

@end
