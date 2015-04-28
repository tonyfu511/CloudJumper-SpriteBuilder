//
//  GameDataSingleton.m
//  CloudJumper
//
//  Created by Tony Fu on 4/19/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameDataSingleton.h"

@implementation GameDataSingleton {
    NSInteger _topScore;
}

static GameDataSingleton *instance;
static NSString* const TOP_SCORE_KEY = @"topScore";

+ (GameDataSingleton *)getInstance {
    if (instance == NULL) {
        instance = [[self alloc] init];
    }
    return instance;
}

- (void)load {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    _topScore = [userDefault integerForKey:TOP_SCORE_KEY];
}

- (void)save {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setInteger:_topScore forKey:TOP_SCORE_KEY];
    [userDefault synchronize];
}

- (NSInteger)getTopScore {
    return _topScore;
}

- (void)setTopScore:(NSInteger)topScore {
    _topScore = topScore;
}

@end

