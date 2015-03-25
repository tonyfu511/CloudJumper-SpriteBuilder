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
    CCSprite *_character;
    CCAction *_followCharacter;
    BOOL faceRight; // YES if character moves right
}

- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    
    // visualize physics bodies & joints
    //_physicsNode.debugDraw = TRUE;
    
    _physicsNode.collisionDelegate = self;
    
    CCScene *level = [CCBReader loadAsScene:@"Levels/Level1"];
    [_levelNode addChild:level];
    
    _character = (CCSprite*)[CCBReader load:@"CharWalk"];
    [_physicsNode addChild:_character];
    faceRight = YES;
    
    _followCharacter = [CCActionFollow actionWithTarget:_character worldBoundary:level.boundingBox];
    [_levelNode runAction:_followCharacter];
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
    
}

@end
