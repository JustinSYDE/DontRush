//
//  dontRushPlayingCard.h
//  DontRush
//
//  Created by Justin Wong on 2015-05-19.
//  Copyright (c) 2015 justinSYDE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DontRushPlayingCard : NSObject

@property (nonatomic, getter =isMatched) BOOL matched;
@property (nonatomic) NSMutableDictionary *colorsOnCard;

- (instancetype) init;
+ (NSArray *)validColors;

@end
