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
    return @[@"#17b287", @"#f6ac6a", @"#dd465f", @"#475358"];
}

+ (NSArray *)validTonesOfGreen {
    return @[@"#17b287", @"#0e6e54", @"#118565", @"#149b76"];
}

+ (NSArray *)validNumberStrings {
    return @[@"One", @"Two", @"Three", @"Four", @"Five", @"Six", @"Seven", @"Eight", @"Nine"];
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
        NSMutableArray *arrayOfTones = [[NSMutableArray alloc] init];
        arrayOfTones[0] = [DontRushGame validTonesOfGreen];
        arrayOfTones[1] = [DontRushGame validTonesOfGreen];
        arrayOfTones[2] = [DontRushGame validTonesOfGreen];
        arrayOfTones[3] = [DontRushGame validTonesOfGreen];
        
        _collectionOfColors = [[NSMutableDictionary alloc] initWithObjects:arrayOfTones forKeys:[DontRushGame validColors]];
    };
    
    return _collectionOfColors;
}

- (NSMutableDictionary *)collectionOfTones {
    if (!_collectionOfTones) {
        NSMutableArray *initCount = [[NSMutableArray alloc] init];
        for (int i = 0; i < [[DontRushGame validColors] count]; i++) {
            initCount[i] = @0;
        }
        
        //_collectionOfTones = [NSMutableDictionary alloc] initWithObjects:initCount forKeys:<#(NSArray *)#>
    }
    
    return _collectionOfTones;
}

- (BOOL)reverse {
    if (!_reverse) {
        _reverse = NO;
    }
    
    return _reverse;
}

#pragma mark - Question

- (NSString *)drawRandomColor:(BOOL)tonedCard {
    int random = arc4random()%([DontRushGame.validColors count]);
    return DontRushGame.validColors[random];
}

- (void) generateColorSet:(BOOL)tonedCard {
    [self.orderedListOfColors removeAllObjects];
    [self.collectionOfColors removeAllObjects];
    NSNumber *countForColor = @0;
    NSString *randomColor;
    for (int i = 0; i < 16; i++) {
        if (tonedCard) {
            randomColor = [self drawRandomColor:YES];
            NSDictionary *tones = [self collectionOfTones][randomColor];
            
        } else {
            randomColor = [self drawRandomColor:NO];
            countForColor = [self collectionOfColors][randomColor];
        }
        
        countForColor = @([countForColor integerValue] + 1);
        [self.collectionOfColors setObject:countForColor forKey:randomColor];
        [self.orderedListOfColors addObject:randomColor];
    }
}

- (NSDictionary *)generateNewQuestion {
    int i = arc4random() % [DontRushGame.validColors count];
    
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
    if (answeredNumber > [DontRushGame.validColors count] || answeredNumber < 1)
        return false;
    
    NSString *answeredNumberString = [DontRushGame validNumberStrings][--answeredNumber]; // because the array starts at index 0
    if ([answeredNumberString isEqualToString:questionNumber])
        return true;

    return false;
}

- (void) updateScore {
    if (self.timeCount > 0) {
        self.score += self.timeCount;
    }
}

@end
