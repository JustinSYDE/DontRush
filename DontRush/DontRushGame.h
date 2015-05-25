//
//  dontRushGame.h
//  DontRush
//
//  Created by Justin Wong on 2015-05-19.
//  Copyright (c) 2015 justinSYDE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "dontRushPlayingCard.h"

@interface DontRushGame : NSObject

//- (void) chooseCard;
- (instancetype) initWithCard: (DontRushPlayingCard *)card;
//@property (nonatomic) NSInteger score;

@end
