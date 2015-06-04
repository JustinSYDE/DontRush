//
//  StatsView.h
//  DontRush
//
//  Created by Justin Wong on 2015-06-03.
//  Copyright (c) 2015 justinSYDE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatsLabel.h"

@interface StatsView : UIView

@property (nonatomic) StatsLabel *timerLabel;
@property (nonatomic) StatsLabel *highScoreLabel;
@property (nonatomic) StatsLabel *scoreLabel;
@property (nonatomic) NSMutableArray *listOfStatsLabels;

- (instancetype)initWithFrame:(CGRect)frame;

@end
