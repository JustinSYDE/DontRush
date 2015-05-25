//
//  dontRushPlayingCard.m
//  DontRush
//
//  Created by Justin Wong on 2015-05-19.
//  Copyright (c) 2015 justinSYDE. All rights reserved.
//

#import "DontRushPlayingCard.h"

@implementation DontRushPlayingCard

+ (NSArray *)validColors {
    return @[@"#f8ae6c", @"#cae59c", @"#6b3b4e"];
}

- (int) randomNum: (int)max {
    return rand() % max;
}

- (NSMutableDictionary *)colorsOnCard {
    if (!_colorsOnCard) {
        NSMutableArray *colorCount = [[NSMutableArray alloc] init];
        for (int i = 0; i < [[DontRushPlayingCard validColors] count]; i++) {
            colorCount[i] = @0;
        }
        
        _colorsOnCard = [[NSMutableDictionary alloc] initWithObjects:colorCount forKeys:[DontRushPlayingCard validColors]];
    }
    
    return _colorsOnCard;
}
// Designated initializer
- (instancetype) init {
    self = [super init];

    if (self) {
        int numShapes = 16/*[self randomNum:9]*/;
        
        if (numShapes > 0) {
            int max =  [[DontRushPlayingCard validColors] count]; // # shape types == # shape sizes == # fill colors
            
            for (int i = 0; i < numShapes; i++) {
                NSString *shapeColor = [DontRushPlayingCard validColors][[self randomNum:max]];
                NSNumber *countForColor = self.colorsOnCard[shapeColor];
                [self.colorsOnCard setObject:countForColor forKey:shapeColor];
            }
        }
        
        else {
            NSLog(@"Invalid numShapes initializer variable: %d", numShapes);
            self = nil;
        }
    }
    
    return self;
}

@end
