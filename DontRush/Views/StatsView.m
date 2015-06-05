//
//  StatsView.m
//  DontRush
//
//  Created by Justin Wong on 2015-06-03.
//  Copyright (c) 2015 justinSYDE. All rights reserved.
//

#import "StatsView.h"

@implementation StatsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setupStatsLabels];
        [self addLabelsToViewUsingFrame:frame];
        self.clipsToBounds = YES;
    }
    
    return self;
}

- (NSMutableArray *)listOfStatsLabels {
    if (!_listOfStatsLabels) {
        _listOfStatsLabels = [[NSMutableArray alloc] init];
    }
    
    return _listOfStatsLabels;
}

- (void)setupStatsLabels {
    self.timerLabel = [[StatsLabel alloc] initWithText:@"TIME \n0" withBackgroundColor:@"#f6ac6a"];
    self.highScoreLabel = [[StatsLabel alloc] initWithText:@"BEST \n0" withBackgroundColor:@"#475358"];
    self.scoreLabel = [[StatsLabel alloc] initWithText:@"SCORE \n0" withBackgroundColor:@"#475358"];
    [self.listOfStatsLabels addObject:self.timerLabel];
    [self.listOfStatsLabels addObject:self.highScoreLabel];
    [self.listOfStatsLabels addObject:self.scoreLabel];
}

- (void)addLabelsToViewUsingFrame:(CGRect)frame {
    float const gapBetweenLabels = 5;
    float const padding = frame.size.width / 20.0;
    float widthOfLabel = (frame.size.width - (2*padding) - (gapBetweenLabels * ([self.listOfStatsLabels count] - 1))) / [self.listOfStatsLabels count];
    float heightOfLabel = frame.size.height;
    float x = 0 + padding;
    float y = 0;
    
    for (int i = 0; i < [self.listOfStatsLabels count]; i++) {
        UILabel *statsLabel = [self.listOfStatsLabels objectAtIndex:i];
        CGRect newFrame = CGRectMake(x, y, widthOfLabel, heightOfLabel);
        statsLabel.frame = newFrame;
        [self addSubview:statsLabel];
        x = x + gapBetweenLabels + widthOfLabel;
    }
}

@end
