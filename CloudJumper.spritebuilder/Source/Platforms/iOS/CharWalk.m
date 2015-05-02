//
//  CharWalk.m
//  CloudJumper
//
//  Created by Tony Fu on 4/9/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CharWalk.h"
#import "Gameplay.h"

@implementation CharWalk

- (void)didLoadFromCCB
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    self.position = ccp(155, screenHeight - 180);
    self.zOrder = DrawingOrderHero;
    self.physicsBody.collisionType = @"character";
}

@end

