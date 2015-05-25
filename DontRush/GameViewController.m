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
#import "DontRushPlayingCard.h"
#import "GameView.h"

@interface GameViewController ()
@property (weak, nonatomic) IBOutlet UIView *gameCardView;
@property (nonatomic) DontRushGame *game;
@property (nonatomic) DontRushPlayingCard *card;
@property (nonatomic) GameView *gameView;
@property (nonatomic) NSMutableDictionary *colorsOnCard;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@end

@implementation GameViewController

// Assumes input like "#00FF00" (#RRGGBB).
+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

#pragma mark - Setup

- (void)viewDidLoad {
    [super viewDidLoad];
    self.colorsOnCard = [[self card] colorsOnCard];
    self.gameView = [[GameView alloc] initWithFrame:CGRectMake(16, 233, 288, 288)];
    [self.view addSubview:self.gameView];
    [self updateUI];
}

- (void)updateUI {
    /*for (UILabel *shapeLabel in self.shapeLabels) {
        int i = rand() % [[DontRushPlayingCard validColors] count];
        UIColor *color = [GameViewController colorFromHexString:[DontRushPlayingCard validColors][i]];
        shapeLabel.textColor = color;
    }*/
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
        _game = [[DontRushGame alloc]initWithCard:[self card]];
    }
    
    return _game;
}

- (DontRushPlayingCard *)card {
    if (!_card) {
        _card = [[DontRushPlayingCard alloc] init];
    }
    
    return _card;
}

#pragma mark - Dragging

- (IBAction)dragGesture:(UIPanGestureRecognizer *)sender {
    [self dragged:sender];
}

- (void)dragged:(UIPanGestureRecognizer *)gestureRecognizer {
    CGFloat xDistance = [gestureRecognizer translationInView:self.gameView].x;
    CGFloat yDistance = [gestureRecognizer translationInView:self.gameView].y;
    //NSLog(@"%f, %f", xDistance, yDistance);
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:{
            self.gameView.originalPoint = self.gameView.center;
            break;
        };
        case UIGestureRecognizerStateChanged:{
            CGFloat rotationStrength = MIN(xDistance / 320, 1);
            CGFloat rotationAngel = (CGFloat) (2*M_PI * rotationStrength / 16);
            CGFloat scaleStrength = 1 - fabsf(rotationStrength) / 4;
            CGFloat scale = MAX(scaleStrength, 0.93);
            //NSLog(@"Center: %f, %f", self.gameView.originalPoint.x + xDistance, self.gameView.originalPoint.y + yDistance);
            CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngel);
            CGAffineTransform scaleTransform = CGAffineTransformScale(transform, scale, scale);
            self.gameView.transform = scaleTransform;
            NSLog(@"Before: %f, %f", self.gameView.center.x, self.gameView.center.y);
            self.gameView.center = CGPointMake(self.gameView.originalPoint.x + xDistance, self.gameView.originalPoint.y + yDistance);
            
            NSLog(@"After: %f, %f", self.gameView.center.x, self.gameView.center.y);
            
            break;
        };
        case UIGestureRecognizerStateEnded: {
            //[self resetViewPositionAndTransformations];
            break;
        };
        case UIGestureRecognizerStatePossible:break;
        case UIGestureRecognizerStateCancelled:break;
        case UIGestureRecognizerStateFailed:break;
    }
}

- (void)resetViewPositionAndTransformations
{
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.gameView.center = self.gameView.originalPoint;
                         self.gameView.transform = CGAffineTransformMakeRotation(0);
                     }];
}

@end
