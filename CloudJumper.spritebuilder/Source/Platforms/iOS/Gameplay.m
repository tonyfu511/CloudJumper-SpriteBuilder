//
//  Gameplay.m
//  CloudJumper
//
//  Created by Tony Fu on 2/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "CharWalk.h"
#import "CCPhysics+ObjectiveChipmunk.h"

@implementation Gameplay {
    CCPhysicsNode *_physicsNode;
    CCNode *_contentNode;
    CCNode *_levelNode;
    
    NSMutableArray *_clouds;
    
    CCNode *_bg1;
    CCNode *_bg2;
    NSArray *_bgs;
    
    CCSprite *_character;
    BOOL faceRight; // YES if character moves right
    
    float moveHeight;
}

- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    
    // visualize physics bodies & joints
    //_physicsNode.debugDraw = TRUE;
    
    _physicsNode.collisionDelegate = self;
    
    _bgs = @[_bg1, _bg2];
    
    _clouds = [NSMutableArray array];
    
    [self initialize];
}

- (void)initialize {
    //CCScene *level = [CCBReader loadAsScene:@"Levels/Level1"];
    //[_levelNode addChild:level];
    
    _character = (CCSprite*)[CCBReader load:@"CharWalk"];
    [_physicsNode addChild:_character];
    faceRight = YES;

    timeSinceObstacle = 0.0f;
    moveHeight = 50.0f;
}

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CGPoint touchLocation = [touch locationInNode:_contentNode];
    CGPoint charLocation = _character.position;
    
    if (touchLocation.x - charLocation.x > 0) {
        if (!faceRight) {
            faceRight = YES;
            [_character setFlipX:NO];
        }
        _character.position = CGPointMake(charLocation.x + 3, charLocation.y);
    } else if (touchLocation.x - charLocation.x < 0) {
        if (faceRight) {
            faceRight = NO;
            [_character setFlipX:YES];
        }
        _character.position = CGPointMake(charLocation.x - 3, charLocation.y);
    }
}

- (void)update:(CCTime)delta {
    for (CCNode *bg in _bgs) {
        // move the background clouds
        bg.position = ccp(bg.position.x, bg.position.y - (moveHeight * delta));
        
        // if the left corner is one complete width off the screen, move it to the right
        if (bg.position.y <= (-1 * bg.contentSize.height)) {
            bg.position = ccp(bg.position.x, bg.position.y + 2 * bg.contentSize.height);
        }
    }
    
    timeSinceObstacle += delta;
    if (timeSinceObstacle > 2.0f) {
        [self addCloud];
        timeSinceObstacle = 0.0f;
    }
}

- (void)addCloud {
    Obstacle *obstacle = (Obstacle *)[CCBReader load:@"Obstacle"];
    CGPoint screenPosition = [self convertToWorldSpace:ccp(380, 0)];
    CGPoint worldPosition = [physicsNode convertToNodeSpace:screenPosition];
    obstacle.position = worldPosition;
    [obstacle setupRandomPosition];
    obstacle.zOrder = DrawingOrderPipes;
    [physicsNode addChild:obstacle];
    [_obstacles addObject:obstacle];
}

@end
