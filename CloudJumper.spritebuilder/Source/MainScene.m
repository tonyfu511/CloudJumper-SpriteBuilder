#import "MainScene.h"

@implementation MainScene

- (void)play {
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
    CCTransition *transition = [CCTransition transitionCrossFadeWithDuration:1.5f];
    [[CCDirector sharedDirector] replaceScene:gameplayScene withTransition:transition];
}

@end
