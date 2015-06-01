//
//  GameViewController.m
//  DontRush
//
//  Created by Justin Wong on 2015-05-18.
//  Copyright (c) 2015 justinSYDE. All rights reserved.
//

#import "GameViewController.h"
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>
#import "DontRushGame.h"
#import "GameView.h"

@interface GameViewController ()

#pragma mark - Properties

@property (nonatomic) DontRushGame *game;
@property (nonatomic) GameView *gameView;
@property (nonatomic) NSTimer *timer;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *highScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *popupTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *popupSubtitleLabel;

@property (weak, nonatomic) IBOutlet UIButton *startButton;

@property (weak, nonatomic) IBOutlet UIView *popupView;
@property (nonatomic) UIView *shadowView;
@property (weak, nonatomic) IBOutlet UIView *statsView;
@property (weak, nonatomic) IBOutlet UIView *gameWrapperView;

@property (nonatomic) NSMutableDictionary *colorsOnCard;
@property (nonatomic) NSArray *validFonts;

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@end

@implementation GameViewController

- (NSArray *) validFonts {
    return @[@"HelveticaNeue", @"Palatino-Roman", @"AmericanTypewriter", @"HiraKakuProN-W3", @"MarkerFelt-Thin", @"TrebuchetMS", @"Courier"];
}

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
    [self setupStats];
    [self setupPopupView];
    [self setupGameView];
    
    self.game.highScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"HighScoreSaved"];
    self.highScoreLabel.text = [NSString stringWithFormat:@"BEST: \n%ld", (long)self.game.highScore];
}

- (void)setupPopupView {
    self.startButton.backgroundColor = [self colorFromHexString:@"#6dac76"];
    self.startButton.layer.borderColor = [[self colorFromHexString:@"6dac76"] CGColor];
    self.startButton.layer.borderWidth = 1;
    self.startButton.layer.cornerRadius = 8;
    self.startButton.clipsToBounds = YES;
    
    self.popupView.layer.borderWidth = 1;
    self.popupView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.popupView.layer.cornerRadius = 8;
    self.startButton.clipsToBounds = YES;
    
    self.popupTextLabel.layer.cornerRadius = 8;
    self.popupTextLabel.layer.borderColor = [[self colorFromHexString:@"#f0f0f0"] CGColor];
    self.popupTextLabel.layer.backgroundColor = [[self colorFromHexString:@"#f6f6f6"] CGColor];
    self.popupTextLabel.layer.borderWidth = 4;
    self.popupTextLabel.clipsToBounds = YES;
    
    self.shadowView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.shadowView.backgroundColor = [UIColor blackColor];
    self.shadowView.alpha = 0.6;
    [self.view insertSubview:self.shadowView belowSubview:self.popupView];
}

- (void)setupStats {
    self.scoreLabel.backgroundColor = [self colorFromHexString:@"#475358"];
    self.scoreLabel.layer.cornerRadius = 4;
    self.scoreLabel.layer.borderWidth = 1.0;
    self.scoreLabel.layer.borderColor = [[self colorFromHexString:@"#475358"] CGColor];
    self.scoreLabel.clipsToBounds = YES;
    
    self.highScoreLabel.backgroundColor = [self colorFromHexString:@"#475358"];
    self.highScoreLabel.layer.cornerRadius = 4;
    self.highScoreLabel.layer.borderWidth = 1.0;
    self.highScoreLabel.layer.borderColor = [[self colorFromHexString:@"#475358"] CGColor];
    self.highScoreLabel.clipsToBounds = YES;
    
    self.timeLabel.backgroundColor = [self colorFromHexString:@"#f6ac6a"];
    self.timeLabel.layer.cornerRadius = 4;
    self.timeLabel.layer.borderWidth = 1.0;
    self.timeLabel.layer.borderColor = [[self colorFromHexString:@"#f6ac6a"] CGColor];
    self.timeLabel.clipsToBounds = YES;
}

- (void)setupGameView {
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragged:)];
    [self.gameView addGestureRecognizer:self.panGestureRecognizer];
    self.gameView.layer.borderColor = [[self colorFromHexString:@"#dbc8b2"] CGColor];
    self.gameView.layer.borderWidth = 4;
    self.gameView.layer.cornerRadius = 8;
    [self.gameWrapperView addSubview:self.gameView];
    [self.view sendSubviewToBack:self.gameView];
}

#pragma mark - Initializers

- (GameView *)gameView {
    if (!_gameView) {
        _gameView = [[GameView alloc] initWithFrame:self.gameWrapperView.bounds];
    }
    
    return _gameView;
}

- (NSMutableDictionary *)colorsOnCard {
    if (!_colorsOnCard) {
        _colorsOnCard = [[NSMutableDictionary alloc] init];
    }
    return _colorsOnCard;
}

- (DontRushGame *)game {
    if (!_game) {
        _game = [[DontRushGame alloc] init];
    }
    
    return _game;
}

- (void) startTimer {
    self.game.timeCount = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0/10.0
                                                 target:self
                                               selector:@selector(updateTimer)
                                               userInfo:nil
                                                repeats:YES];
}

- (void)restartTimer {
    [self.timer invalidate];
    self.game.timeCount = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0/10.0
                                                  target:self
                                                selector:@selector(updateTimer)
                                                userInfo:nil
                                                 repeats:YES];
    
}

#pragma mark - UI

- (void)applyColorToShapesInList:(NSMutableArray *)list {
    int i = 0;
    for (UILabel *shapeLabel in list) {
        UIColor *color = [self colorFromHexString:self.game.orderedListOfColors[i]];
        [shapeLabel setTextColor:color];
        i++;
    }
}

- (void)updateScoreUI {
    self.scoreLabel.text = [NSString stringWithFormat:@"SCORE \n%ld",(long)self.game.score];
}

- (void)updatePopupToGameOver {
    self.popupSubtitleLabel.text = @"Not too shabby.";
    self.popupTextLabel.text = [NSString stringWithFormat:@"Your score: %ld\nYour best: %ld", (long)self.game.score, (long)self.game.highScore];
    [self.startButton setTitle:@"Again!" forState:UIControlStateNormal];

}

- (void)updateTimer {
    self.game.timeCount++;
    self.timeLabel.text = [NSString stringWithFormat:@"TIME\n%ld", (long)self.game.timeCount];
}

- (void)gameOver {
    if (self.game.score > self.game.highScore) {
        [[NSUserDefaults standardUserDefaults] setInteger:self.game.score forKey:@"HighScoreSaved"];
        self.highScoreLabel.text = [NSString stringWithFormat: @"BEST:\n%ld", self.game.score];
        self.game.highScore = self.game.score;
    }
    
    [self updatePopupToGameOver];
}

#pragma mark - Touch Gesture

- (IBAction)touchStartButton:(id)sender {
    
    self.popupView.hidden = YES;
    self.shadowView.hidden = YES;
    self.game.score = 0;
    [self updateScoreUI];
    
    [self popNewQuestion];
    [self popNewCard];
    [self restartTimer];
}

#pragma mark - Drag Gesture

- (void)dragged:(UIPanGestureRecognizer *)gestureRecognizer {
    CGFloat xDistance = [gestureRecognizer translationInView:self.gameView].x;
    CGFloat yDistance = [gestureRecognizer translationInView:self.gameView].y;
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:{
            [self.gameView dragBeganEvent];
            break;
        };
        case UIGestureRecognizerStateChanged:{
            [self.gameView draggingEventwithxDistance:xDistance andWithYDistance:yDistance];
            break;
        };
        case UIGestureRecognizerStateEnded: {
            [self.gameView dragFinishedEventWithxDistance:xDistance];
            
            // Swipe right to match
            if (xDistance > (self.gameView.bounds.size.width * (3.5/5))) {
                if ([self.game match]) {
                    // Only reward points if player determined an answer in under 100 time units
                    if ((100 - self.game.timeCount) > 0) {
                        self.game.score += 100 - self.game.timeCount;
                    }
                    [self popNewQuestion];
                    [self popNewCard];
                    [self restartTimer];
                } else {
                    // end game
                    [self.timer invalidate];
                    self.shadowView.hidden = NO;
                    [self gameOver];
                    self.popupView.hidden = NO;
                }
                
                [self updateScoreUI];
            }
            
            // Swipe left for no match
            else if (xDistance < - (self.gameView.bounds.size.width * (3.5/5))) {
                if (![self.game match]) {
                    // Only reward points if player determined an answer in under 100 time units
                    if ((100 - self.game.timeCount) > 0) {
                        self.game.score += 100 - self.game.timeCount;
                    }
                    [self popNewCard];
                    [self restartTimer];
                } else {
                    // end game
                    [self.timer invalidate];
                    self.shadowView.hidden = NO;
                    [self gameOver];
                    self.popupView.hidden = NO;
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
    [self.game generateColorSet];
    [self applyColorToShapesInList: self.gameView.listOfShapes];
}

- (void)popNewQuestion {
    NSDictionary *questionObject = [self.game generateNewQuestion];
    NSString *color = [questionObject allKeys][0];
    NSString *number = questionObject[color];
    int randNum = arc4random() % [self.validFonts count];
    NSString *randomFont = self.validFonts[randNum];
    UIFont *font = [UIFont fontWithName:randomFont size:75.0];
    NSDictionary *attributes = @{NSForegroundColorAttributeName : [self colorFromHexString:color],
                                 NSFontAttributeName : font};
    
    NSAttributedString *newQuestion = [[NSAttributedString alloc] initWithString:number attributes:attributes];
    self.questionLabel.attributedText = newQuestion;
}

@end
