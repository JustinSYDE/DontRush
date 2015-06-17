//
//  StatsView.m
//  DontRush
//
//  Created by Justin Wong on 2015-06-03.
//  Copyright (c) 2015 justinSYDE. All rights reserved.
//

#import "StatsView.h"

@implementation StatsView

// Assumes input like "#00FF00" (#RRGGBB).
- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

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
    BOOL tutorialFinished = [[NSUserDefaults standardUserDefaults] boolForKey:@"tutorialFinished"];
    if (tutorialFinished)
        self.timerLabel = [[StatsLabel alloc] initWithText:@"TIME \n20" withBackgroundColor:@"#17b287"];
    else
        self.timerLabel = [[StatsLabel alloc] initWithText:@"TIME \n∞" withBackgroundColor:@"#17b287"];
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

- (void)updateTimerToWarningState {
    self.timerLabel.backgroundColor = [self colorFromHexString:@"#f6ac6a"];
    self.timerLabel.layer.borderColor = [[self colorFromHexString:@"#f6ac6a"] CGColor];
}

- (void)updateTimerToEndState {
    self.timerLabel.backgroundColor = [self colorFromHexString:@"#dd465f"];
    self.timerLabel.layer.borderColor = [[self colorFromHexString:@"#dd465f"] CGColor];
}

- (void)updateTimerToStartState {
    self.timerLabel.backgroundColor = [self colorFromHexString:@"#17b287"];
    self.timerLabel.layer.borderColor = [[self colorFromHexString:@"#17b287"] CGColor];
}

@end
