//
//  dontRushGame.h
//  DontRush
//
//  Created by Justin Wong on 2015-05-19.
//  Copyright (c) 2015 justinSYDE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DontRushGame : NSObject
@property (nonatomic) NSInteger score;
@property (nonatomic) NSInteger highScore;
@property (nonatomic) NSMutableDictionary *collectionOfColors;
@property (nonatomic) NSMutableDictionary *collectionOfTones;
@property (nonatomic) NSMutableArray *orderedListOfColors;
@property (nonatomic) NSMutableDictionary *questionObject;
@property (nonatomic) NSInteger timeCount;
@property (nonatomic) NSInteger timeLimit;
@property (nonatomic) BOOL reverse; // if true, user swipes left to match instead of right
@property (nonatomic) BOOL toned; // if true, user plays with tones rather than with distinct
@property (nonatomic) BOOL smallCircles; // if true, user plays with smaller circles
@property (nonatomic) BOOL circleQuestion; // if true, question appears as colored dots rather than a colored string
@property (nonatomic) BOOL reverseUnlocked;
@property (nonatomic) BOOL toneUnlocked;
@property (nonatomic) BOOL circleQuestionsUnlocked;
@property (nonatomic) BOOL smallCirclesUnlocked;
@property (nonatomic) BOOL tutorialFinished;
+ (NSArray *)validColors;
+ (NSArray *)validNumberStrings;
- (void)generateColorSet;
- (void)generateToneSet;
- (void)setupNewTone;
- (NSDictionary *) generateNewQuestion;
- (BOOL)match;
- (void)updateScore;
- (void)resetCurrentGameData;
- (BOOL)unlockNewGameTwists;
- (void)resetHighScore;
- (void)resetGameTwists;
- (void)masterReset;
- (void)unlockAllGameTwists;
@end
