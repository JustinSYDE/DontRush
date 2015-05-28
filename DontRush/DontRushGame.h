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
@property (nonatomic) NSMutableDictionary *collectionOfColors;
@property (nonatomic) NSMutableArray *orderedListOfColors;
@property (nonatomic) NSMutableDictionary *questionObject;

+ (NSArray *)validColors;
+ (NSArray *)validNumberStrings;
- (void) generateColorSet;
- (NSDictionary *) generateNewQuestion;
- (BOOL) match;

@end
