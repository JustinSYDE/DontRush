//
//  dontRushGame.m
//  DontRush
//
//  Created by Justin Wong on 2015-05-19.
//  Copyright (c) 2015 justinSYDE. All rights reserved.
//

#import "DontRushGame.h"

@interface DontRushGame()
@end

@implementation DontRushGame

+ (NSArray *)validColors {
    return @[@"#6dac76", @"#f6ac6a", @"#dd465f", @"#475358"];
}

+ (NSArray *)validNumberStrings {
    return @[@"Zero", @"One", @"Two", @"Three", @"Four", @"Five", @"Six", @"Seven", @"Eight", @"Nine"];
}

#pragma mark - Initializers

- (NSMutableDictionary *)questionObject {
    if (!_questionObject) {
        _questionObject = [[NSMutableDictionary alloc] init];
    }
    
    return _questionObject;
}

- (NSMutableArray *)orderedListOfColors {
    if (!_orderedListOfColors) {
        _orderedListOfColors = [[NSMutableArray alloc] init];
    }
    
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

- (BOOL)reverse {
    if (!_reverse) {
        _reverse = NO;
    }
    
    return _reverse;
}

#pragma mark - Question

- (NSString *)drawRandomColor {
    int random = arc4random()%([DontRushGame.validColors count]);
    if (random > 3) {
        NSLog(@"Break");
    }
    return DontRushGame.validColors[random];
}

- (void) generateColorSet {
    [self.orderedListOfColors removeAllObjects];
    [self.collectionOfColors removeAllObjects];
    for (int i = 0; i < 16; i++) {
        NSString *randomColor = [self drawRandomColor];
        NSNumber *countForColor = [self collectionOfColors][randomColor];
        countForColor = @([countForColor integerValue] + 1);
        [self.collectionOfColors setObject:countForColor forKey:randomColor];
        [self.orderedListOfColors addObject:randomColor];
    }
}

- (NSDictionary *)generateNewQuestion {
    int i = arc4random() % 10;
    NSString *number = [[NSString alloc] initWithString:[DontRushGame validNumberStrings][i]];
    
    int randNum = arc4random() % 4;
    NSString *randomColor = [DontRushGame validColors][randNum];
    
    self.questionObject =  (NSMutableDictionary *)@{randomColor: number};
    return self.questionObject;
}

#pragma mark - Game Rules

- (BOOL) match {
    NSString *questionColor = [self.questionObject allKeys][0];
    NSString *questionNumber = self.questionObject[questionColor];
    int answeredNumber = [self.collectionOfColors[questionColor] intValue];
    
    if (answeredNumber > 9)
        return false;
    
    NSString *answeredNumberString = [DontRushGame validNumberStrings][answeredNumber];
    
    if ([answeredNumberString isEqualToString:questionNumber])
        return true;

    return false;
}

- (void) updateScore {
    if ((100 - self.timeCount) > 0) { // Only reward points if player determined an answer in under 100 time units
        self.score += 100 - self.timeCount;
    }
}

@end
