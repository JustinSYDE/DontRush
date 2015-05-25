//
//  dontRushGame.m
//  DontRush
//
//  Created by Justin Wong on 2015-05-19.
//  Copyright (c) 2015 justinSYDE. All rights reserved.
//

#import "DontRushGame.h"

@interface DontRushGame()

@property (nonatomic) DontRushPlayingCard *topCard;
@property (nonatomic) DontRushPlayingCard *nextCard;
@end

@implementation DontRushGame

- (instancetype)initWithCard:(DontRushPlayingCard *)card {
    self = [super init];
    
    if (self) {
        self.topCard = card;
    }
    
    return self;
}

@end
