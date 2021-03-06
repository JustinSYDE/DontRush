//
//  dontRushGame.m
//  DontRush
//
//  Created by Justin Wong on 2015-05-19.
//  Copyright (c) 2015 justinSYDE. All rights reserved.
//

#import "DontRushGame.h"

@interface DontRushGame()
@property (nonatomic) NSString *randomColorForToneMode;
@property (nonatomic) NSMutableDictionary *tones;
@end

/* KEYS
 =======
 * (int) HighScoreSaved // stores the record high score
 * (BOOL) reverseUnlocked
 * (BOOL) toneUnlocked
 * (BOOL) circleQuestionsUnlocked
 * (BOOL) smallCirclesUnlocked
 * (BOOL) tutorialFinished
 */

@implementation DontRushGame

+ (NSArray *)validColors {
    return @[@"#17b287", @"#f6ac6a", @"#dd465f", @"#475358"];
}

+ (NSArray *)validTonesOfGreen {
    return @[@"#17b287", @"#0e6e54", @"#084131", @"#31e4b3"];
}

+ (NSArray *)validTonesOfOrange {
    return @[@"#f6ac6a", @"#f28422", @"#fad4b2", @"#d56b0d"];
}

+ (NSArray *)validTonesOfRed {
    return @[@"#dd465f", @"#741525", @"#b5213a", @"#e98797"];
}

+ (NSArray *)validTonesOfBlue {
    return @[@"#475358", @"#252b2e", @"#697b82", @"#91a0a6"];
}

+ (NSArray *)validNumberStrings {
    return @[@"One", @"Two", @"Three", @"Four", @"Five", @"Six", @"Seven", @"Eight", /*@"Nine"*/];
}

#pragma mark - Initializers

- (NSString *)randomColorForToneMode {
    if (!_randomColorForToneMode) _randomColorForToneMode = [[NSString alloc] init];
    return _randomColorForToneMode;
}

- (NSMutableDictionary *)questionObject {
    if (!_questionObject) _questionObject = [[NSMutableDictionary alloc] init];
    return _questionObject;
}

- (NSMutableArray *)orderedListOfColors {
    if (!_orderedListOfColors) _orderedListOfColors = [[NSMutableArray alloc] init];
    return _orderedListOfColors;
}

- (NSMutableDictionary *)collectionOfColors {
    if (!_collectionOfColors) {
        NSMutableArray *initCount = [[NSMutableArray alloc] init];
        for (int i = 0; i < [[DontRushGame validColors] count]; i++) {
            initCount[i] = @0;
        }
        
        _collectionOfColors = [[NSMutableDictionary alloc] initWithObjects:initCount forKeys:[DontRushGame validColors]];
    };
    
    return _collectionOfColors;
}

- (NSMutableDictionary *)tones {
    if (!_tones) _tones = [[NSMutableDictionary alloc] init];
    return _tones;
}

- (NSMutableDictionary *)collectionOfTones {
    if (!_collectionOfTones) {
        
        NSMutableArray *arrayOfTones = [[NSMutableArray alloc] init];
        arrayOfTones[0] = [DontRushGame validTonesOfGreen];
        arrayOfTones[1] = [DontRushGame validTonesOfOrange];
        arrayOfTones[2] = [DontRushGame validTonesOfRed];
        arrayOfTones[3] = [DontRushGame validTonesOfBlue];
        
        NSMutableArray *initCount = [[NSMutableArray alloc] init];
        for (int i = 0; i < [[DontRushGame validColors] count]; i++) {
            initCount[i] = @0;
        }
        
        NSMutableArray *arrayOfToneDictionaries = [[NSMutableArray alloc] init];
        for (int i = 0; i < [arrayOfTones count]; i++) {
            arrayOfToneDictionaries[i] = [[NSMutableDictionary alloc] initWithObjects:initCount forKeys:arrayOfTones[i]];
        }
        
        _collectionOfTones = [[NSMutableDictionary alloc] initWithObjects:arrayOfToneDictionaries forKeys:[DontRushGame validColors]];
    }
    
    return _collectionOfTones;
}

- (NSInteger)highScore {
    if (!_highScore) _highScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"HighScoreSaved"];
    return _highScore;
}

- (BOOL)reverse {
    if (!_reverse) _reverse = NO;
    return _reverse;
}

- (BOOL)toned {
    if (!_toned) _toned = NO;
    return _toned;
}

- (BOOL)smallCircles {
    if (!_smallCircles) _smallCircles = NO;
    return _smallCircles;
}

- (BOOL)circleQuestion {
    if (!_circleQuestion) _circleQuestion = NO;
    return _circleQuestion;
}

- (NSInteger)timeLimit {
    if (!_timeLimit) _timeLimit = 21;
    return _timeLimit;
}

- (BOOL)tutorialFinished {
    if (!_tutorialFinished) _tutorialFinished = [[NSUserDefaults standardUserDefaults] boolForKey:@"tutorialFinished"];
    return _tutorialFinished;
}

- (BOOL)reverseUnlocked {
    if (!_reverseUnlocked) _reverseUnlocked = [[NSUserDefaults standardUserDefaults] boolForKey:@"reverseUnlocked"];
    return _reverseUnlocked;
}

- (BOOL)toneUnlocked {
    if (!_toneUnlocked) _toneUnlocked = [[NSUserDefaults standardUserDefaults] boolForKey:@"toneUnlocked"];
    return _toneUnlocked;
}

- (BOOL)circleQuestionsUnlocked {
    if (!_circleQuestionsUnlocked) _circleQuestionsUnlocked = [[NSUserDefaults standardUserDefaults] boolForKey:@"circleQuestionsUnlocked"];
    return _circleQuestionsUnlocked;
}

- (BOOL)smallCirclesUnlocked {
    if (!_smallCirclesUnlocked) _smallCirclesUnlocked = [[NSUserDefaults standardUserDefaults] boolForKey:@"smallCirclesUnlocked"];
    return _smallCirclesUnlocked;
}


#pragma mark - Question

- (NSString *)drawRandomColor {
    int random = arc4random()%([DontRushGame.validColors count]);
    return DontRushGame.validColors[random];
}

- (NSString *)drawRandomTone {
    if ([self.tones count] == [DontRushGame.validColors count]) {
        int random = arc4random()%[DontRushGame.validColors count];
        if ([self.collectionOfTones[self.randomColorForToneMode] count] == [DontRushGame.validColors count]) {
            NSMutableDictionary *dictionary = self.collectionOfTones[self.randomColorForToneMode];
            NSArray *keys = [dictionary allKeys];
            if ([keys count] == [DontRushGame.validColors count])
                return keys[random];
        }
    }

    return @"ERROR";
}

- (void) generateColorSet {
    [self.orderedListOfColors removeAllObjects];
    [self.collectionOfColors removeAllObjects];
    NSNumber *countForColor = @0;
    NSString *randomColor;
    
    for (int i = 0; i < 16; i++) {
        randomColor = [self drawRandomColor];
        countForColor = [self collectionOfColors][randomColor];
        countForColor = @([countForColor integerValue] + 1);
        [self.collectionOfColors setObject:countForColor forKey:randomColor];
        [self.orderedListOfColors addObject:randomColor];
    }
}

- (void)generateToneSet {
    NSNumber *countForColor = @0;
    NSString *randomTone;
    
    [self.orderedListOfColors removeAllObjects];
    
    NSArray *keys = [self.tones allKeys];
    for (int i = 0; i < [keys count]; i++) {
        self.tones[keys[i]] = @0;
    }
    
    for (int i = 0; i < 16; i++) {
        randomTone = [self drawRandomTone];
        countForColor = self.tones[randomTone];
        countForColor = @([countForColor integerValue] + 1);
        [self.tones setObject:countForColor forKey:randomTone];
        [self.orderedListOfColors addObject:randomTone];
    }
}

- (void)setupNewTone {
    [self.orderedListOfColors removeAllObjects];
    [self.tones removeAllObjects];
    self.randomColorForToneMode = [self drawRandomColor];
    // First we determine the tone dictionary to be used for the round
    if (self.randomColorForToneMode && self.collectionOfTones) {
        self.tones =  [self.collectionOfTones[self.randomColorForToneMode] mutableCopy];
    }
}

- (NSDictionary *)generateNewQuestion{
    int i = arc4random() % [DontRushGame.validNumberStrings count];
    NSString *number = [[NSString alloc] initWithString:[DontRushGame validNumberStrings][i]];;
    int randNum = arc4random() % [DontRushGame.validColors count];
    
    if (self.toned && [self.tones count] == [DontRushGame.validColors count]) {
        NSArray *keys = [self.tones allKeys];
        NSString *randomTone = keys[randNum];
        self.questionObject =  (NSMutableDictionary *)@{@"color":randomTone, @"countAsString": number, @"count": [[NSNumber alloc] initWithInt:++i]};
    } else {
        NSString *randomColor = [DontRushGame validColors][randNum];
        self.questionObject =  (NSMutableDictionary *)@{@"color":randomColor, @"countAsString": number, @"count": [[NSNumber alloc] initWithInt:++i]};
    }
    
    return self.questionObject;
}

#pragma mark - Game Rules

- (BOOL)match {
    NSString *questionColor = self.questionObject[@"color"];
    NSString *questionNumber = self.questionObject[@"countAsString"];
    int answeredNumber;
    
    if (self.toned) {
        answeredNumber = [self.tones[questionColor] intValue];
    } else {
        answeredNumber = [self.collectionOfColors[questionColor] intValue];
    }
    
    if (answeredNumber > [DontRushGame.validNumberStrings count] || answeredNumber < 1)
        return false;
    
    NSString *answeredNumberString = [DontRushGame validNumberStrings][--answeredNumber]; // because the array starts at index 0
    return [answeredNumberString isEqualToString:questionNumber];
}

- (void)updateScore {
    if (self.timeCount > 0) {
        self.score += self.timeCount;
    }
}

- (BOOL)unlockNewGameTwists {
    BOOL unlockable = NO;
    
    if ((self.highScore >= 2000) && ![[NSUserDefaults standardUserDefaults] boolForKey:@"circleQuestionsUnlocked"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"circleQuestionsUnlocked"];
        self.circleQuestionsUnlocked = YES;
        unlockable = YES;
    }
    
    if ((self.highScore >= 1500) && ![[NSUserDefaults standardUserDefaults] boolForKey:@"smallCirclesUnlocked"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"smallCirclesUnlocked"];
        self.smallCirclesUnlocked = YES;
        unlockable = YES;
    }
    
    if ((self.highScore >= 1000) && ![[NSUserDefaults standardUserDefaults] boolForKey:@"toneUnlocked"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"toneUnlocked"];
        self.toneUnlocked = YES;
        unlockable = YES;
    }
    
    if ((self.highScore >= 500) && ![[NSUserDefaults standardUserDefaults] boolForKey:@"reverseUnlocked"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"reverseUnlocked"];
        self.reverseUnlocked = YES;
        unlockable = YES;
    }
    
    return unlockable;
}

- (void)resetHighScore {
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"HighScoreSaved"];
}

- (void)resetGameTwists {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"circleQuestionsUnlocked"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"smallCirclesUnlocked"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"toneUnlocked"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"reverseUnlocked"];
}

- (void)unlockAllGameTwists {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"circleQuestionsUnlocked"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"smallCirclesUnlocked"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"toneUnlocked"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"reverseUnlocked"];
}

- (void)masterReset {
    [self resetGameTwists];
    [self resetHighScore];
}
- (void)resetCurrentGameData {
    self.score = 0;
    self.reverse = NO;
    self.toned = NO;
    self.smallCircles = NO;
    self.circleQuestion = NO;
    self.timeLimit = 21;
}

@end
