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
}

- (void)setupRandomPosition {
    // value between 0.f and 1.f
    CGFloat random = ((double)arc4random() / ARC4RANDOM_MAX);
    CGFloat newX = screenWidth * random;
    if (newX < self.contentSize.width / 2) {
        newX = self.contentSize.width / 2;
    } else if (newX > screenWidth - self.contentSize.width / 2) {
        newX = screenWidth = self.contentSize.width / 2;
    }
    self.position = ccp(newX, self.position.y);
}

@end
