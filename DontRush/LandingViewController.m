//
//  LandingViewController.m
//  DontRush
//
//  Created by Justin Wong on 2015-06-12.
//  Copyright (c) 2015 justinSYDE. All rights reserved.
//

#import "LandingViewController.h"
#import "GameViewController.h"
#import "StatsLabel.h"

@interface LandingViewController()
@property (nonatomic) float const headerPadding;
@property (nonatomic) UIButton *playButton;
@property (nonatomic) UIButton *howToButton;
@end

@implementation LandingViewController

// Assumes input like "#00FF00" (#RRGGBB).
- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

- (void)viewDidLoad {
    self.view.backgroundColor = [self colorFromHexString:@"#f2eedc"];
    [self setTitleView];
    [self setHighScoreView];
    [self setAchievementsView];
    [self setButtonsView];
}

- (float const)headerPadding {
    return self.view.frame.size.height / 15.0;
}

- (void)setTitleView {
    CGRect newFrame = CGRectMake(0, self.headerPadding, self.view.frame.size.width, self.view.frame.size.height / 5.0);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:newFrame];
    titleLabel.text = @"Don't Rush!";
    titleLabel.font = [UIFont fontWithName:@"Helvetica" size:36.0f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
}

- (void)setHighScoreView {
    CGRect newFrame = CGRectMake(0, self.headerPadding + self.view.frame.size.height / 5.0, self.view.frame.size.width, self.view.frame.size.height / 10.0);
    UILabel *highScoreLabel = [[UILabel alloc] initWithFrame:newFrame];
    NSInteger highScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"HighScoreSaved"];
    highScoreLabel.text = [NSString stringWithFormat:@"High Score: %li", (long)highScore];
    highScoreLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
    highScoreLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:highScoreLabel];
}

- (void)setAchievementsView {
    CGRect newFrame = CGRectMake(0, self.headerPadding + self.view.frame.size.height * 3.0/10, self.view.frame.size.width, self.view.frame.size.height / 5.0);
    UILabel *achievementsLabel = [[UILabel alloc] initWithFrame:newFrame];
    achievementsLabel.text = @"Unlocked:";
    achievementsLabel.textAlignment = NSTextAlignmentCenter;
    achievementsLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
    [self.view addSubview:achievementsLabel];
}

- (void)setButtonsView {
    CGRect newFrame = CGRectMake(0, self.headerPadding + self.view.frame.size.height * 0.5, self.view.frame.size.width, self.view.frame.size.height / 2.0);
    UIView *buttonsView = [[UIView alloc] initWithFrame:newFrame];
    float const width = self.view.frame.size.width / 2.0;
    float const height = self.view.frame.size.height / 7.0;
    float const x = (self.view.frame.size.width - width) / 2.0;
    float const y = 0;;
    
    CGRect howToFrame = CGRectMake(x, y, width, height);
    CGRect playFrame = CGRectMake(x, y + height + self.headerPadding, width, height);

    
    self.howToButton = [[UIButton alloc] initWithFrame:howToFrame];
    self.playButton = [[UIButton alloc] initWithFrame:playFrame];
    
    [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
    self.playButton.font = [UIFont fontWithName:@"Helvetica-Bold" size:24.0f];
    [self.playButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.playButton setBackgroundColor:[self colorFromHexString:@"#17b287"]];
    self.playButton.layer.cornerRadius = 8.0;
    
    [self.howToButton setTitle:@"Instructions" forState:UIControlStateNormal];
    self.howToButton.font = [UIFont fontWithName:@"Helvetica" size:24.0f];
    [self.howToButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.howToButton setBackgroundColor:[self colorFromHexString:@"#bdc3c7"]];
    self.howToButton.layer.cornerRadius = 8.0;
    
    [buttonsView addSubview:self.howToButton];
    [buttonsView addSubview:self.playButton];
    [self.view addSubview:buttonsView];
    
    [self.playButton addTarget:self action:@selector(touchPlayButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)touchPlayButton {
    GameViewController *gameViewController = [[GameViewController alloc] init];
    [self presentViewController:gameViewController animated:NO completion:NULL];
}

@end
