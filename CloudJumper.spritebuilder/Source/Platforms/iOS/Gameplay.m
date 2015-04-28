//
//  Gameplay.m
//  CloudJumper
//
//  Created by Tony Fu on 2/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "CharWalk.h"
#import "Cloud1.h"
#import "Cloud2.h"
#import "Cloud3.h"
#import "Cloud4.h"
#import "TopNail.h"
#import "GameDataSingleton.h"
#import "CCPhysics+ObjectiveChipmunk.h"

#import <FBSDKShareKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@implementation Gameplay {
    CCPhysicsNode *_physicsNode;
    
    NSMutableArray *_clouds;
    
    CCNode *_bg1;
    CCNode *_bg2;
    NSArray *_bgs;
    
    CCSprite *_heart1;
    CCSprite *_heart2;
    CCSprite *_heart3;
    
    CCLabelTTF *_gameOverLabel;
    CCLabelTTF *_scoreLabel;
    CCLabelTTF *_finalScoreLabel;
    CCLabelTTF *_topScoreLabel;
    CCButton *_restartButton;
    CCButton *_fbButton;
    
    CCNode *lastCollision;
    
    TopNail *_topnail;
    
    CCSprite *_character;
    BOOL faceRight; // YES if character moves right
    
    float moveHeight;
    BOOL firstCloud;
    int points;
    int heartNum;
    CGFloat screenHeight;
    CGFloat screenWidth;
    BOOL _gameOver;
    
    float timeSinceObstacle;
    double time;
    
    GameDataSingleton *gameData;
}

static float const MIN_DISTANCE = 20.0f;

- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    
    _physicsNode.collisionDelegate = self;
    
    _bgs = @[_bg1, _bg2];
    
    _clouds = [NSMutableArray array];
    
    [self initialize];
}

- (void)initialize {
    _character = (CCSprite*)[CCBReader load:@"CharWalk"];
    [_physicsNode addChild:_character];
    faceRight = YES;
    
    timeSinceObstacle = 0.0f;
    moveHeight = 50.0f;
    firstCloud = TRUE;
    points = 0;
    heartNum = 3;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenHeight = screenRect.size.height;
    screenWidth = screenRect.size.width;
    
    for (CGFloat y = 200.0f; y <= screenHeight; y += 70.0f) {
        [self addCloud:screenHeight - y];
    }
    
    gameData = [GameDataSingleton getInstance];
}

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    if (!_gameOver) {
        CGPoint touchLocation = [touch locationInNode:_physicsNode];
        CGPoint charLocation = _character.position;
        
        CCAnimationManager *animationManager = _character.animationManager;
        [animationManager runAnimationsForSequenceNamed:@"CupidWalk"];
        
        if (touchLocation.x > charLocation.x) {
            if (!faceRight) {
                faceRight = YES;
                [_character setFlipX:NO];
            }
            _character.position = CGPointMake(charLocation.x + 20, charLocation.y);
        } else if (touchLocation.x < charLocation.x) {
            if (faceRight) {
                faceRight = NO;
                [_character setFlipX:YES];
            }
            _character.position = CGPointMake(charLocation.x - 20, charLocation.y);
        }
    }
}

- (void)update:(CCTime)delta {
    CGPoint characterWorldPosition = [_physicsNode convertToWorldSpace:_character.position];
    CGPoint characterScreenPosition = [self convertToNodeSpace:characterWorldPosition];
    if (characterScreenPosition.y < 0) {
        [self gameOver];
        return;
    }
    
    // if character is out of the side bounds, move it to another side
    if (_character.position.x < 0) {
        _character.position = CGPointMake(screenWidth, _character.position.y);
    } else if (_character.position.x > screenWidth) {
        _character.position = CGPointMake(0, _character.position.y);
    }
    
    if (!_gameOver) {
        time += delta;
        if (time >= 15.0) {
            moveHeight += 10;
            time = 0.0;
        }
        
        _physicsNode.position = ccp(_physicsNode.position.x, _physicsNode.position.y + (moveHeight * delta));
        
        _topnail.position = ccp(_topnail.position.x, _topnail.position.y - (moveHeight * delta));
        
        for (CCNode *bg in _bgs) {
            // move the background clouds
            bg.position = ccp(bg.position.x, bg.position.y + (moveHeight * delta));
            
            // if the left corner is one complete width off the screen, move it to the right
            if (bg.position.y >= (bg.contentSize.height)) {
                bg.position = ccp(bg.position.x, bg.position.y - 2 * bg.contentSize.height);
            }
        }
        
        NSMutableArray *offScreenClouds = nil;
        for (CCNode *cloud in _clouds) {
            CGPoint cloudWorldPosition = [_physicsNode convertToWorldSpace:cloud.position];
            CGPoint cloudScreenPosition = [self convertToNodeSpace:cloudWorldPosition];
            if (cloudScreenPosition.y > (screenHeight + cloud.contentSize.height)) {
                if (!offScreenClouds) {
                    offScreenClouds = [NSMutableArray array];
                }
                [offScreenClouds addObject:cloud];
            }
        }
        
        for (CCNode *cloudToRemove in offScreenClouds) {
            [cloudToRemove removeFromParent];
            [_clouds removeObject:cloudToRemove];
        }
        
        timeSinceObstacle += delta;
        if (timeSinceObstacle > 1.2f) {
            [self addCloud];
            timeSinceObstacle = 0.0f;
        }
    }
}

- (void)addCloud {
    CGFloat y = -20.0f;
    [self addCloud:y];
}

- (void)addCloud:(CGFloat)y {
    if (firstCloud) {
        Cloud2 *cloud = (Cloud2 *)[CCBReader load:@"Cloud2"];
        CGPoint screenPosition = [self convertToWorldSpace:ccp(155, y)];
        CGPoint worldPosition = [_physicsNode convertToNodeSpace:screenPosition];
        cloud.position = worldPosition;
        [_physicsNode addChild:cloud];
        [_clouds addObject:cloud];
        firstCloud = FALSE;
    } else {
        CGPoint screenPosition = [self convertToWorldSpace:ccp(0, y)];
        CGPoint worldPosition = [_physicsNode convertToNodeSpace:screenPosition];
        CCNode *node;
        
        while (TRUE) {
            int randomCloud = CCRANDOM_0_1() * 100;
            
            if (randomCloud <= 50) {
                Cloud2 *cloud = (Cloud2 *)[CCBReader load:@"Cloud2"];
                cloud.position = worldPosition;
                [cloud setupRandomPosition];
                node = cloud;
            } else if (randomCloud <= 75) {
                Cloud1 *cloud = (Cloud1 *)[CCBReader load:@"Cloud1"];
                cloud.position = worldPosition;
                [cloud setupRandomPosition];
                node = cloud;
            } else if (randomCloud <= 90) {
                Cloud3 *cloud = (Cloud3 *)[CCBReader load:@"Cloud3"];
                cloud.position = worldPosition;
                [cloud setupRandomPosition];
                node = cloud;
            } else {
                Cloud4 *cloud = (Cloud4 *)[CCBReader load:@"Cloud4"];
                cloud.position = worldPosition;
                [cloud setupRandomPosition];
                node = cloud;
            }
            
            if ([self isValidCloud:node]) {
                [_physicsNode addChild:node];
                [_clouds addObject:node];
                break;
            }
        }
    }
}

- (BOOL)isValidCloud:(CCNode *)node1 {
    if (_clouds.count >= 2) {
        CCNode *node2 = [_clouds objectAtIndex:_clouds.count - 1];
        CCNode *node3 = [_clouds objectAtIndex:_clouds.count - 2];
        float x1 = node1.position.x;
        float x2 = node2.position.x;
        float x3 = node3.position.x;
        
        if (fabsf(x1 - x2) <= MIN_DISTANCE && fabsf(x2 - x3) <= MIN_DISTANCE && fabsf(x1 - x3) <= MIN_DISTANCE) {
            return FALSE;
        }
        
        if ([node1 isKindOfClass:[Cloud1 class]]) {
            if ([node2 isKindOfClass:[Cloud1 class]] && [node3 isKindOfClass:[Cloud1 class]]) {
                return FALSE;
            }
        } else if ([node1 isKindOfClass:[Cloud2 class]]) {
            if ([node2 isKindOfClass:[Cloud2 class]] && [node3 isKindOfClass:[Cloud2 class]]) {
                return FALSE;
            }
        } else if ([node1 isKindOfClass:[Cloud3 class]]) {
            if ([node2 isKindOfClass:[Cloud3 class]] && [node3 isKindOfClass:[Cloud3 class]]) {
                return FALSE;
            }
        } else if ([node1 isKindOfClass:[Cloud4 class]]) {
            if ([node2 isKindOfClass:[Cloud4 class]] && [node3 isKindOfClass:[Cloud4 class]]) {
                return FALSE;
            }
        }
    }
    
    return TRUE;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair character:(CCNode *)character goal:(CCNode *)goal {
    [goal removeFromParent];
    points++;
    _scoreLabel.string = [NSString stringWithFormat:@"%d", points];
    return TRUE;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair character:(CCNode *)character topnail:(CCNode *)topnail {
    [self gameOver];
    points++;
    _scoreLabel.string = [NSString stringWithFormat:@"%d", points];
    return TRUE;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair character:(CCNode *)character cloud1:(CCNode *)cloud1 {
    [self removeCloud:cloud1];
    
    return TRUE;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair character:(CCNode *)character cloud4:(CCNode *)cloud4 {
    if (lastCollision != cloud4) {
        if (heartNum == 3) {
            _heart1.visible = FALSE;
            heartNum--;
        } else if (heartNum == 2) {
            _heart2.visible = FALSE;
            heartNum--;
        } else if (heartNum == 1) {
            _heart3.visible = FALSE;
            [self gameOver];
        }
        lastCollision = cloud4;
    }
    
    return TRUE;
}

- (void)gameOver {
    if (!_gameOver) {
        _gameOver = TRUE;
        
        NSInteger topPoints = topPoints = [gameData getTopScore];
        if (topPoints < points) {
            topPoints = points;
        }
        [gameData setTopScore:topPoints];
        
        _finalScoreLabel.string = [NSString stringWithFormat:@"Final Score: %d", points];
        _topScoreLabel.string = [NSString stringWithFormat:@"Top Score: %d", (int)topPoints];
        
        _heart1.visible = FALSE;
        _heart2.visible = FALSE;
        _heart3.visible = FALSE;
        
        _topnail.visible = FALSE;
        _scoreLabel.visible = FALSE;
        _gameOverLabel.visible = TRUE;
        _finalScoreLabel.visible = TRUE;
        _topScoreLabel.visible = TRUE;
        _restartButton.visible = TRUE;
        _fbButton.visible = TRUE;
        
        for (CCNode *cloud in _clouds) {
            [self removeCloud:cloud];
        }
    }
}

- (void)restart {
    [[CCDirector sharedDirector] replaceScene: [CCBReader loadAsScene:@"Gameplay"]];
}

- (void)removeCloud:(CCNode *)cloud {
    CCParticleSystem *cloudClear = (CCParticleSystem *)[CCBReader load:@"CloudClear"];
    cloudClear.autoRemoveOnFinish = TRUE;
    cloudClear.position = cloud.position;
    [cloud.parent addChild:cloudClear];
    [cloud removeFromParent];
}

- (void)shareToFacebook {
    /*//UIImage *img = [UIImage imageNamed:@"spacemonkey.png"];
     CCScene *myScene = [[CCDirector sharedDirector] runningScene];
     CCNode *node = [myScene.children objectAtIndex:0];
     UIImage *img = [self screenshotWithStartNode:node];
     
     FBSDKSharePhoto *screen = [[FBSDKSharePhoto alloc] init];
     screen.image = img;
     screen.userGenerated = YES;
     //[screen setImageURL:[NSURL URLWithString:@"http://spacemonkey.kailiangchen.com"]];
     
     FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
     content.photos = @[screen];
     
     FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
     dialog.fromViewController = [CCDirector sharedDirector];
     [dialog setShareContent:content];
     dialog.mode = FBSDKShareDialogModeShareSheet;
     [dialog show];*/
}

- (UIImage*)screenshotWithStartNode:(CCNode*)stNode {
    [CCDirector sharedDirector].nextDeltaTimeZero = YES;
    
    CCRenderTexture* renTxture = [CCRenderTexture renderTextureWithWidth:screenWidth height:screenHeight];
    [renTxture begin];
    [stNode visit];
    [renTxture end];
    
    return [renTxture getUIImage];
}

@end
