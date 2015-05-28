//
//  GameViewController.m
//  DontRush
//
//  Created by Justin Wong on 2015-05-18.
//  Copyright (c) 2015 justinSYDE. All rights reserved.
//

#import "GameViewController.h"
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>
//#import <QuartzCore/CALayer.h>
#import "DontRushGame.h"
#import "GameView.h"

@interface GameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *highScoreLabel;
@property (nonatomic) DontRushGame *game;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (nonatomic) GameView *gameView;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic) NSMutableDictionary *colorsOnCard;
@property (nonatomic) NSArray *validFonts;
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
    [self roundLabelCorners];
    [self.view addSubview:self.gameView];
    
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragged:)];
    [self.gameView addGestureRecognizer:self.panGestureRecognizer];
    [self popNewQuestion];
    [self popNewCard];
}

- (void)applyColorToShapesInList:(NSMutableArray *)list {
    int i = 0;
    for (UILabel *shapeLabel in list) {
        UIColor *color = [self colorFromHexString:self.game.orderedListOfColors[i]];
        [shapeLabel setTextColor:color];
        i++;
    }
}

- (void)roundLabelCorners {
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

#pragma mark - Initializers

- (GameView *)gameView {
    if (!_gameView) {
        _gameView = [[GameView alloc] initWithFrame:CGRectMake(16, 233, 288, 288)];
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

#pragma mark - UI

- (void)updateUI {
    // Update score label
    self.scoreLabel.text = [NSString stringWithFormat:@"SCORE \n%ld",(long)self.game.score];
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
                    self.game.score += 1;
                } else {
                    self.game.score += -1;
                }
                
                [self updateUI];
                [self popNewQuestion];
                [self popNewCard];
            }
            
            // Swipe left for no match
            else if (xDistance < - (self.gameView.bounds.size.width * (3.5/5))) {
                [self popNewCard];
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
