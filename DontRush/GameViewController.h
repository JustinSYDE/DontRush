//
//  GameViewController.h
//  DontRush
//
//  Created by Justin Wong on 2015-05-18.
//  Copyright (c) 2015 justinSYDE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameView.h"
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>
#import "DontRushGame.h"
#import "GameView.h"
#import "StatsView.h"
#import "PopupView.h"
#import "ShadowView.h"
#import "QuestionView.h"
#import "GameMessageView.h"
#import "TwistIconView.h"

@interface GameViewController : UIViewController

@property (nonatomic) DontRushGame *game;
@property (nonatomic) GameView *gameView;
@property (nonatomic) StatsView *statsView;
@property (nonatomic) PopupView *popupView;
@property (nonatomic) ShadowView *shadowView;
@property (nonatomic) QuestionView *questionView;
@property (nonatomic) GameMessageView *gameMessageView;
@property (nonatomic) TwistIconView *twistIconView;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) float const headerPadding;
@property (nonatomic) NSMutableDictionary *colorsOnCard;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@end

