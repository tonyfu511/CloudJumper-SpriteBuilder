#import "MainScene.h"

@implementation MainScene

- (void)play {
    [[OALSimpleAudio sharedInstance] playBg:@"click_button.wav"];
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
    CCTransition *transition = [CCTransition transitionCrossFadeWithDuration:1.5f];
    [[CCDirector sharedDirector] replaceScene:gameplayScene withTransition:transition];
}

@end
