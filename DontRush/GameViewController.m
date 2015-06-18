//
//  GameViewController.m
//  DontRush
//
//  Created by Justin Wong on 2015-05-18.
//  Copyright (c) 2015 justinSYDE. All rights reserved.
//

#import "GameViewController.h"
#import "LandingViewController.h"

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
        [NSTimer scheduledTimerWithTimeInterval:0.5
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
    [UIView animateWithDuration:1.0 animations:^{
        CGPoint point = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
        self.tutorialPopupView.center = point;
    }];
}

- (void)slideTutorialViewOut {
    [UIView animateWithDuration:1.0 animations:^{
        CGPoint point = CGPointMake(self.view.frame.size.width / 2.0, -self.view.frame.size.height);
        self.tutorialPopupView.center = point;
        self.shadowView.alpha = 0;
    }];
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
        float const height = self.view.frame.size.height * 0.6;
        float const x = (self.view.frame.size.width - width) / 2.0;
        float const y = (self.view.frame.size.height - height) / 2.0;
        CGRect newFrame = CGRectMake(x, y, width, height);
        _popupView = [[PopupView alloc] initWithFrame:newFrame];
    }
    
    return _popupView;
}

- (TutorialPopupView *)tutorialPopupView {
    if (!_tutorialPopupView) {
        float const width = self.view.frame.size.width * 0.9;
        float const height = self.view.frame.size.height * 0.8;
        float const x = (self.view.frame.size.width - width) / 2.0;
        float const y = self.view.frame.size.height*0.85; /*(self.view.frame.size.height - height) / 2.0;*/
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
            [shapeLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 25.0f]];
        } else {
            [shapeLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 100.0f]];
        }
        
        i++;
    }
}

- (void)highlightMissedShapes {
    self.gameView.userInteractionEnabled = NO;
    self.gameView.layer.borderColor = [[self colorFromHexString:@"#dbc8b2"] CGColor];
    [self.questionView updateQuestionLabel:[[NSAttributedString alloc] initWithString:@"Lol"]];
    NSString *questionColor = [self.game.questionObject allKeys][0];
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
    self.shadowView.hidden = NO;
    self.shadowView.alpha = 0.6;
    self.popupView.hidden = NO;
    self.twistIconView.hidden = YES;
    [self.gameView resetGrid];
    if ([self.game unlockNewGameTwists]) {
        self.popupView.titleLabel.text = @"Congratulations!";
        self.popupView.subtitleLabel.text = @"Unlocked new twist!";
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

}

- (void)updatePopupToTutorial {
    self.shadowView.hidden = NO;
    self.popupView.hidden = NO;
    self.twistIconView.hidden = YES;
    [self.gameView resetGrid];
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
    
    [self.game resetCurrentGameData];
    self.popupView.hidden = YES;
    self.shadowView.hidden = YES;
    [self updateScoreUI];
    [self.statsView updateTimerToStartState];
    [self popNewCard];
    [self popNewQuestion];
    if (self.game.tutorialFinished) {
        [self restartTimer];
    }
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
    self.tutorialPopupView.hidden = YES;
    self.shadowView.hidden = YES;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"tutorialFinished"];
    self.game.tutorialFinished = [[NSUserDefaults standardUserDefaults] boolForKey:@"tutorialFinished"];
    self.gameView.userInteractionEnabled = YES;
    [self restartTimer];

}
- (void)touchHomeButton {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"tutorialFinished"];
    self.game.tutorialFinished = [[NSUserDefaults standardUserDefaults] boolForKey:@"tutorialFinished"];
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
    NSAttributedString *newQuestion;
    NSDictionary *questionObject = [self.game generateNewQuestion];
    NSString *color = [questionObject allKeys][0];
    NSString *numberString = questionObject[color];
    NSInteger count = [questionObject[@"count"] intValue];
    NSDictionary *attributes = @{NSForegroundColorAttributeName : [self colorFromHexString:color]};
    
    if (self.game.circleQuestion) {
        NSMutableString *str = [[NSMutableString alloc] init];
        for (int i = 0; i < count; i++) {
            [str appendString:@"●"];
        }
        newQuestion = [[NSAttributedString alloc] initWithString:str attributes:attributes];
       self.questionView.questionLabel.font = [UIFont fontWithName:@"Helvetica" size:50.0f];
    } else {
        newQuestion = [[NSAttributedString alloc] initWithString:numberString attributes:attributes];
        self.questionView.questionLabel.font = [UIFont fontWithName:@"Helvetica" size:75.0f];
    }
    
    [self.questionView updateQuestionLabel:newQuestion];
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
