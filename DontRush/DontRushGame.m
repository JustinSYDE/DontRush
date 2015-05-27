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
    return @[@"#f8ae6c", @"#cae59c", @"#6b3b4e", @"#dd465f", @"#475358"];
}

#pragma mark - Initializers

- (instancetype)init {
    self = [super init];
    
    if (self) {
       // do stuff
    }
    
    return self;
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

- (NSString *)drawRandomColor {
    int random = arc4random()%[DontRushGame.validColors count];
    return DontRushGame.validColors[random];
}

- (void) generateColorSet {
    [self.orderedListOfColors removeAllObjects];
    for (int i = 0; i < 16; i++) {
        NSString *randomColor = [self drawRandomColor];
        NSNumber *countForColor = [self collectionOfColors][randomColor];
        countForColor = @([countForColor integerValue] + 1);
        [self.collectionOfColors setObject:countForColor forKey:randomColor];
        [self.orderedListOfColors addObject:randomColor];
    }
}

- (NSString *)generateNewQuestion {
    int i = arc4random() % 10;
    NSArray *arrayOfNumberStrings = @[@"Zero", @"One", @"Two", @"Three", @"Four", @"Five", @"Six", @"Seven", @"Eight", @"Nine"];
    NSString *question = [[NSString alloc] initWithString:arrayOfNumberStrings[i]];
    
    return question;
}


@end
