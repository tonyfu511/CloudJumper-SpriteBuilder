//
//  Cloud4.m
//  CloudJumper
//
//  Created by Tony Fu on 4/14/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Cloud4.h"

@implementation Cloud4 {
    CCNode *_cloud;
    
    CGFloat screenWidth;
}

#define ARC4RANDOM_MAX      0x100000000

- (void)didLoadFromCCB {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    
    _cloud.physicsBody.collisionType = @"cloud4";
}

- (void)setupRandomPosition {
    // value between 0.f and 1.f
    CGFloat random = ((double)arc4random() / ARC4RANDOM_MAX);
    CGFloat newX = screenWidth * random;
    if (newX < _cloud.contentSize.width / 2) {
        newX = _cloud.contentSize.width / 2;
    } else if (newX > screenWidth - _cloud.contentSize.width / 2) {
        newX = screenWidth = _cloud.contentSize.width / 2;
    }
    self.position = ccp(newX, self.position.y);
}

@end
