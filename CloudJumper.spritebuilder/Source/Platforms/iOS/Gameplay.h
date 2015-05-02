//
//  Gameplay.h
//  CloudJumper
//
//  Created by Tony Fu on 2/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <CCNode.h>

typedef NS_ENUM(NSInteger, DrawingOrder) {
    DrawingOrderClouds,
    DrawingOrderBlood,
    DrawingOrderTopNail,
    DrawingOrderHero
};

@interface Gameplay : CCNode <CCPhysicsCollisionDelegate>

@end

