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
@property (nonatomic) BOOL reverse; // if true, user swipes left to match instead of right

+ (NSArray *)validColors;
+ (NSArray *)validNumberStrings;
- (void) generateColorSet:(BOOL)tonedCard;
- (NSDictionary *) generateNewQuestion;
- (BOOL) match;
- (void) updateScore;

@end
