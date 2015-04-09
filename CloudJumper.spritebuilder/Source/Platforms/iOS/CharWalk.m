//
//  CharWalk.m
//  CloudJumper
//
//  Created by Tony Fu on 4/9/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CharWalk.h"

@implementation CharWalk

- (void)didLoadFromCCB
{
    self.position = ccp(155, -150);
    self.physicsBody.collisionType = @"character";
}

@end
