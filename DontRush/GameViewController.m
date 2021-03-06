//
//  GameViewController.m
//  DontRush
//
//  Created by Justin Wong on 2015-05-18.
//  Copyright (c) 2015 justinSYDE. All rights reserved.
//

#import "GameViewController.h"
#import "LandingViewController.h"
#import <sys/sysctl.h>

@interface GameViewController()
@property (nonatomic) NSArray *validFeedbackStrings;
@end

@implementation GameViewController

// Assumes input like "#00FF00" (#RRGGBB).
- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

- (BOOL)isIPhone4 {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone4,1"] || [platform isEqualToString:@"x86_64"]) {
        return true;
    }
    return false;
}

#pragma mark - Setup

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [self colorFromHexString:@"#f2eedc"];
    [self setupStatsView];
    [self.view addSubview:self.questionView];
    [self.view addSubview:self.twistIconView];
    [self setupGameView];
    [self.view addSubview:self.shadowView];
    [self setupPopupView];
    [self.view addSubview:self.gameMessageView];
    [self newGame];
    if (!self.game.tutorialFinished) {
        [self setupTutorialView];
        [NSTimer scheduledTimerWithTimeInterval:0.1
                                         target:self
                                       selector:@selector(slideTutorialViewIn)
                                       userInfo:nil
                                        repeats:NO];
    }
}

- (void)setupPopupView {
    [self.view addSubview:self.popupView];
    [self.popupView.playButton addTarget:self action:@selector(newGame) forControlEvents:UIControlEventTouchUpInside];
    [self.popupView.homeButton addTarget:self action:@selector(touchHomeButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)slideTutorialViewIn {
    [self.tutorialPopupView slideTutorialViewIn];
    [self.shadowView showShadow];
}

- (void)slideTutorialViewOut {
    [self.tutorialPopupView slideTutorialViewOut];
    [self.shadowView hideShadow];
}

- (void)setupTutorialView {
    [self.timer invalidate];
    [self.view addSubview:self.tutorialPopupView];
    self.shadowView.hidden = NO;
    [self.tutorialPopupView.playButton addTarget:self action:@selector(continueGame) forControlEvents:UIControlEventTouchUpInside];
    [self.tutorialPopupView.homeButton addTarget:self action:@selector(touchHomeButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupStatsView {
    self.statsView.highScoreLabel.text = [NSString stringWithFormat:@"BEST \n%ld", (long)self.game.highScore];
    [self.view addSubview:self.statsView];
}

- (void)setupGameView {
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragged:)];
    [self.gameView addGestureRecognizer:self.panGestureRecognizer];
    self.gameView.layer.borderColor = [[self colorFromHexString:@"#dbc8b2"] CGColor];
    self.gameView.layer.borderWidth = 4;
    self.gameView.layer.cornerRadius = 8;
    self.gameView.backgroundColor = [self colorFromHexString:@"#dbc8b2"];
    [self.view insertSubview:self.gameView belowSubview:self.shadowView];
}

#pragma mark - Initializers

- (GameView *)gameView {
    if (!_gameView) {
        float const height = self.view.frame.size.height / 2.0;
        float const width = height;
        float const padding = self.view.frame.size.width - width;
        float const x = padding / 2.0;
        float const y = (self.view.frame.size.height * 7 / 20.0) + self.headerPadding;
        CGRect newFrame = CGRectMake(x, y, width, height);
        _gameView = [[GameView alloc] initWithFrame:newFrame];
    }
    
    return _gameView;
}

- (float const)headerPadding {
    return self.view.frame.size.height / 15.0;
}

- (QuestionView *)questionView {
    if (!_questionView) {
        float const padding = self.view.frame.size.width / 20.0;
        float const x = padding / 2.0;
        float const y = self.view.frame.size.height / 10.0 + self.headerPadding;
        float const width = self.view.frame.size.width;
        float const height = self.view.frame.size.height / 4.0;
        CGRect newFrame = CGRectMake(x, y, width, height);
        _questionView = [[QuestionView alloc] initWithFrame:newFrame];
    }
    
    return _questionView;
}

- (StatsView *)statsView {
    if (!_statsView) {
        CGRect newFrame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + self.headerPadding, self.view.frame.size.width, self.view.frame.size.height / 10.0);
        _statsView = [[StatsView alloc] initWithFrame:newFrame];
    }
    
    return _statsView;
}

- (ShadowView *)shadowView {
    if (!_shadowView) _shadowView = [[ShadowView alloc] initWithFrame:self.view.frame];
    return _shadowView;
}

- (PopupView *)popupView {
    if (!_popupView) {
        float const width = self.view.frame.size.width * 0.9;
        float const height = self.view.frame.size.height *0.6;
        float const x = (self.view.frame.size.width - width) / 2.0;
        float const y = -self.view.frame.size.height/*(self.view.frame.size.height - height) / 2.0*/;
        CGRect newFrame = CGRectMake(x, y, width, height);
        _popupView = [[PopupView alloc] initWithFrame:newFrame];
    }
    
    return _popupView;
}

- (TutorialPopupView *)tutorialPopupView {
    if (!_tutorialPopupView) {
        float width;
        float height;
        
        if ([self isIPhone4]) {
            width = self.view.frame.size.width * 0.9;
            height = self.view.frame.size.height * 0.9;
        } else {
            width = self.view.frame.size.width * 0.9;
            height = self.view.frame.size.height* 0.8;
        }
        float const x = (self.view.frame.size.width - width) / 2.0;
        float const y = self.view.frame.size.height;
        CGRect newFrame = CGRectMake(x, y, width, height);
        _tutorialPopupView = [[TutorialPopupView alloc] initTutorialWithFrame:newFrame];

    }
    
    return _tutorialPopupView;
}

- (GameMessageView *)gameMessageView {
    if (!_gameMessageView) {
        float const height = self.view.frame.size.height * (0.9) - self.headerPadding;
        float const y = self.view.frame.size.height / 10.0 + self.headerPadding;
        CGRect newFrame = CGRectMake(0, y, self.view.frame.size.width, height);
        _gameMessageView = [[GameMessageView alloc] initWithFrame:newFrame];
    }
    
    return _gameMessageView;
}

- (TwistIconView *)twistIconView {
    if (!_twistIconView) {
        float const y = (self.view.frame.size.height * 4 / 20.0) + self.headerPadding;
        float const x = (self.view.frame.size.width - (self.view.frame.size.width / 5.0));
        CGRect newFrame = CGRectMake(x, y, 30, self.view.frame.size.height/20.0);
        _twistIconView = [[TwistIconView alloc] initWithFrame:newFrame];
    }
    
    return _twistIconView;
}

- (NSMutableDictionary *)colorsOnCard {
    if (!_colorsOnCard) _colorsOnCard = [[NSMutableDictionary alloc] init];
    return _colorsOnCard;
}

- (NSArray *)validFeedbackStrings {
    if (!_validFeedbackStrings) _validFeedbackStrings = @[@"YASS!", @"MMHMM!", @"LEGGO!", @"AYY!", @"SLAY!"];
    return _validFeedbackStrings;
}

- (DontRushGame *)game {
    if (!_game) _game = [[DontRushGame alloc] init];
    return _game;
}

- (void)restartTimer {
    [self.timer invalidate];
    [self.statsView updateTimerToStartState];
    self.game.timeCount = self.game.timeLimit; // Users only have 2 seconds to determine an answer
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0/10.0
                                                  target:self
                                                selector:@selector(updateTimer)
                                                userInfo:nil
                                                 repeats:YES];
}

#pragma mark - UI

- (void)applyColorToShapes {
    int i = 0;
    for (UILabel *shapeLabel in self.gameView.listOfShapes) {
        UIColor *color = [self colorFromHexString:self.game.orderedListOfColors[i]];
        [shapeLabel setTextColor:color];
        
        if (self.game.smallCircles) {
            if ([self isIPhone4]) {
                [shapeLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 10.0f]];
            } else {
                [shapeLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 20.0f]];
            }
        } else if ([self isIPhone4]) {
            [shapeLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 75.0f]];
        } else {
            [shapeLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 100.0f]];
        }
        
        i++;
    }
}

- (void)highlightMissedShapes {
    self.gameView.userInteractionEnabled = NO;
    self.gameView.layer.borderColor = [[self colorFromHexString:@"#dbc8b2"] CGColor];
    [self.questionView updateQuestionLabel:@"Lol" WithColor:[UIColor blackColor]];
    NSString *questionColor = self.game.questionObject[@"color"];
    int i = 0;
    for (UILabel *shapeLabel in self.gameView.listOfShapes) {
        if ([self.game.orderedListOfColors[i] isEqualToString:questionColor]) {
            shapeLabel.backgroundColor = [self colorFromHexString:@"#cbaf8f"];
        }
        i++;
    }
}

- (void)updateScoreUI {
    self.statsView.scoreLabel.text = [NSString stringWithFormat:@"SCORE \n%ld",(long)self.game.score];
}

- (void)updatePopupToGameOver {
    [self.gameView resetGrid];
    if ([self.game unlockNewGameTwists]) {
        self.popupView.titleLabel.text = @"Congratulations!";
        self.popupView.subtitleLabel.text = @"Unlocked new twist!";
    } else if (!self.game.score) {
        self.popupView.titleLabel.text = @"D0n't Rush!";
        self.popupView.subtitleLabel.text = @"R0fl";
    } else if (self.game.timeCount <= (NSInteger)0) {
        self.popupView.titleLabel.text = @"Don't Rush!";
        self.popupView.subtitleLabel.text = @"But don't be a snail.";
    } else if ([self.game match]) {
        self.popupView.titleLabel.text = @"Don't Rush!";
        self.popupView.subtitleLabel.text = @"Missed it.";
    } else {
        self.popupView.titleLabel.text = @"Don't Rush!";
        self.popupView.subtitleLabel.text = @"You rushed.";
    }

    self.popupView.commentLabel.text = [NSString stringWithFormat:@"Your score: %ld\nYour best: %ld", (long)self.game.score, (long)self.game.highScore];
    [self.popupView.playButton setTitle:@"Again" forState:UIControlStateNormal];
    
    
    [self.popupView slidePopupViewIn];
    [self.shadowView showShadow];
    self.twistIconView.hidden = YES;
}

- (void)updateTimer {
    self.game.timeCount--;
    self.statsView.timerLabel.text = [NSString stringWithFormat:@"TIME\n%ld", (long)self.game.timeCount];
    
    if (self.game.timeCount <= 0) {
        if ([self.game match]) {
            [self highlightMissedShapes];
            [self.timer invalidate];
            [NSTimer scheduledTimerWithTimeInterval:1.5
                                             target:self
                                           selector:@selector(endGame)
                                           userInfo:nil
                                            repeats:NO];
        } else {
            [self endGame];
        }
        
    } else if (self.game.timeCount <= 3) {
        [self.statsView updateTimerToEndState];
    } else if (self.game.timeCount <= 10) {
        [self.statsView updateTimerToWarningState];
    }
}

#pragma mark - Touch Gesture

- (void)newGame {
    if (self.game.tutorialFinished) {
        self.gameView.userInteractionEnabled = YES;
    } else {
        self.gameView.userInteractionEnabled = NO;
    }
    
    if (!self.popupView.hidden && self.shadowView.alpha != 0) {
        [self.popupView slidePopupViewOut];
        [self.shadowView hideShadow];
        
        [self continueNewGameSetup];
    } else {
        [self continueNewGameSetup];
    }
    
    if (self.game.tutorialFinished) {
        [NSTimer scheduledTimerWithTimeInterval:0.5
                                         target:self
                                       selector:@selector(restartTimer)
                                       userInfo:nil
                                        repeats:NO];
    }
}

- (void)continueNewGameSetup {
    [self.game resetCurrentGameData];
    [self updateScoreUI];
    [self.statsView updateTimerToStartState];
    [self popNewCard];
    [self popNewQuestion];
}

- (void)continueGame {
    [self slideTutorialViewOut];
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(continueGameSetup)
                                   userInfo:nil
                                    repeats:NO];
    }

- (void)continueGameSetup {
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"tutorialFinished"];
    self.game.tutorialFinished = [[NSUserDefaults standardUserDefaults] boolForKey:@"tutorialFinished"];
    self.gameView.userInteractionEnabled = YES;
    [self restartTimer];

}

- (void)touchHomeButton {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"tutorialFinished"];
    self.game.tutorialFinished = [[NSUserDefaults standardUserDefaults] boolForKey:@"tutorialFinished"];
    [self.popupView slidePopupViewOut];
    [self slideTutorialViewOut];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(navigateToLanding)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)navigateToLanding {
    LandingViewController *landingViewController = [[LandingViewController alloc] init];
    [self presentViewController:landingViewController animated:NO completion:NULL];
}

#pragma mark - Drag Gesture

- (BOOL)matchEventUsingDistance:(CGFloat)distance forMode:(BOOL)reverse{
    if (reverse) {
        return distance < - (self.gameView.bounds.size.width * (2.5/5));
    }
    
    return distance > (self.gameView.bounds.size.width * (2.5/5));
}

- (BOOL)rejectEventUsingDistance:(CGFloat)distance forMode:(BOOL)reverse{
    if (reverse) {
        return distance > (self.gameView.bounds.size.width * (2.5/5));
    }
    
    return distance < - (self.gameView.bounds.size.width * (2.5/5));
};

- (void)dragged:(UIPanGestureRecognizer *)gestureRecognizer {
    CGFloat xDistance = [gestureRecognizer translationInView:self.gameView].x;
    CGFloat yDistance = [gestureRecognizer translationInView:self.gameView].y;
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:{
            [self.gameView dragBeganEvent];
            break;
        };
        case UIGestureRecognizerStateChanged:{
            if (self.game.reverse) {
                [self.gameView draggingEventwithxDistance:xDistance andWithYDistance:yDistance AndReverse:self.game.reverse];
            } else {
                [self.gameView draggingEventwithxDistance:xDistance andWithYDistance:yDistance AndReverse:self.game.reverse];
            }
            break;
        };
            
        case UIGestureRecognizerStateEnded: {
            [self.gameView dragFinishedEventWithxDistance:xDistance];
            
            // Swipe right to match
            if ([self matchEventUsingDistance:xDistance forMode:self.game.reverse] && ![self gameEnded]) {
                if ([self.game match]  && ![self gameEnded]) {
                    [self newRoundAfter:[self.game match]];
                } else {
                    [self endGame];
                }
                
                [self updateScoreUI];
            }
            
            // Swipe left for no match
            else if ([self rejectEventUsingDistance:xDistance forMode:self.game.reverse]) {
                if (![self.game match] && ![self gameEnded]) {
                    [self newRoundAfter:[self.game match]];
                } else {
                    [self highlightMissedShapes];
                    [self.timer invalidate];
                    [NSTimer scheduledTimerWithTimeInterval:1.5
                                                     target:self
                                                   selector:@selector(endGame)
                                                   userInfo:nil
                                                    repeats:NO];
                }
                
                [self updateScoreUI];
            }
            
            // Cancel
            else {
                [self.gameView resetViewPositionAndTransformations];
            }
            
            break;
        };
        case UIGestureRecognizerStatePossible:break;
        case UIGestureRecognizerStateCancelled:break;
        case UIGestureRecognizerStateFailed:break;
    }
}

- (void)popNewCard {
    [self.gameView resetGrid];
    if (self.game.toned) {
        [self.game generateToneSet];
    } else {
        [self.game generateColorSet];
    }
    
    [self applyColorToShapes];
}

- (void)popNewQuestion {
    NSDictionary *questionObject = [self.game generateNewQuestion];
    NSString *color = questionObject[@"color"];
    NSString *numberString = questionObject[@"countAsString"];
    NSInteger count = [questionObject[@"count"] intValue];
    UIColor *newColor = [self colorFromHexString:color];
    
    if (self.game.circleQuestion) {
        NSMutableString *str = [[NSMutableString alloc] init];
        for (int i = 0; i < count; i++) {
            [str appendString:@"●"];
        }
        NSString *string = [NSString stringWithString:str];
        [self.questionView updateQuestionLabel:string WithColor:newColor];
        self.questionView.questionLabel.font = [UIFont fontWithName:@"Helvetica" size:60.0f];
    } else {
        [self.questionView updateQuestionLabel:numberString WithColor:newColor];
    }
}

#pragma mark - Game Events

- (void)newRoundAfter:(BOOL)match {
    [self.game updateScore];
    
    // GAME TWIST:
    if (![self gameEnded]) {
        if (match) {
            if (self.game.toned) {
                [self.game setupNewTone];
            }
            
            if (self.game.toneUnlocked && (self.game.score % 2 == 0) && match) {
                [self toggleTonesGameTwist];
            } else if (self.game.circleQuestionsUnlocked && (self.game.score % 3 == 0) && match) {
                [self toggleCircleQuestionGameTwist];
            } else {
                int randNum = arc4random() % [self.validFeedbackStrings count];
                [self.gameMessageView updateGameMessageWithText:self.validFeedbackStrings[randNum]];
            }
            
            [self popNewQuestion];
        } else {
            if (self.game.reverseUnlocked && (self.game.score % 7 == 0) && !match) {
                [self toggleReverseGameTwist];
            } else if (self.game.smallCirclesUnlocked && (self.game.score % 3 == 0) && !match) {
                [self toggleSmallCirclesGameTwist];
            }
        }
    }
    
    [self restartTimer];
    [self popNewCard];
}

- (void)toggleTonesGameTwist {
    self.game.toned = !self.game.toned;
    if (self.game.toned) {
        [self.gameMessageView updateGameMessageWithText:@"Tones!"];
        [self.game setupNewTone];
        self.game.timeLimit = 41;
    } else {
        [self.gameMessageView updateGameMessageWithText:@"Back to colors."];
        self.game.timeLimit = 21;
    }
}

- (void)toggleReverseGameTwist {
    self.game.reverse = !self.game.reverse;
    [self.gameMessageView updateGameMessageWithText:@"Reverse!"];
    if (self.game.reverse) {
        [self.twistIconView updateTwistIconLabelWithIcon:@"reverse"];
        self.twistIconView.hidden = NO;
    } else {
        self.twistIconView.hidden = YES;
    }
}

- (void)toggleSmallCirclesGameTwist {
    self.game.smallCircles = !self.game.smallCircles;
    if (self.game.smallCircles) {
        [self.gameMessageView updateGameMessageWithText:@"Squint friend, Squint!"];
    } else {
        [self.gameMessageView updateGameMessageWithText:@"Great Squinting."];
    }
}

- (void)toggleCircleQuestionGameTwist {
    self.game.circleQuestion = !self.game.circleQuestion;
    if (self.game.circleQuestion) {
        [self.gameMessageView updateGameMessageWithText:@"I can't read!"];
    } else {
        [self.gameMessageView updateGameMessageWithText:@"I can read."];
    }
}

- (BOOL)gameEnded {
    if (!self.game.timeCount || ![self.timer isValid]) {
        return true;
    }
    
    return false;
}

- (void)endGame {
    self.gameView.userInteractionEnabled = NO;
    [self.timer invalidate];
    if (self.game.score > self.game.highScore) {
        [[NSUserDefaults standardUserDefaults] setInteger:self.game.score forKey:@"HighScoreSaved"];
        self.statsView.highScoreLabel.text = [NSString stringWithFormat: @"BEST\n%ld", (long)self.game.score];
        self.game.highScore = self.game.score;
    }
    
    [self updatePopupToGameOver];
}

@end
