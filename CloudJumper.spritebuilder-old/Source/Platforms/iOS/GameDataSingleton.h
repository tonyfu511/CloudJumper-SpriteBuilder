//
//  GameDataSingleton.h
//  CloudJumper
//
//  Created by Tony Fu on 4/19/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameDataSingleton : NSObject

+ (GameDataSingleton *)getInstance;
- (void)load;
- (void)save;
- (NSInteger)getTopScore;
- (void)setTopScore:(NSInteger)topScore;

@end
