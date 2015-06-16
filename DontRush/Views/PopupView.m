//
//  PopupView.m
//  DontRush
//
//  Created by Justin Wong on 2015-06-04.
//  Copyright (c) 2015 justinSYDE. All rights reserved.
//

#import "PopupView.h"

@implementation PopupView

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
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.layer.cornerRadius = 8;
        self.clipsToBounds = YES;
        
        [self setupTitleLabelWithFrame:frame];
        [self setupSubtitleLabelWithFrame:frame];
        [self setupCommentLabelWithFrame:frame];
        [self setupPlayButtonWithFrame:frame];
        [self setupHomeButtonWithFrame:frame];
    }
    
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
    }
    
    return _titleLabel;
}

- (UILabel *)subtitleLabel {
    if (!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc] init];
    }
    
    return _subtitleLabel;
}

- (UILabel *)commentLabel {
    if (!_commentLabel) _commentLabel = [[UILabel alloc] init];
    return _commentLabel;
}

- (UIButton *)playButton {
    if (!_playButton) _playButton = [[UIButton alloc] init];
    return _playButton;
}

- (UIButton *)homeButton {
    if (!_homeButton) _homeButton = [[UIButton alloc] init];
    return _homeButton;
}

- (void)setupTitleLabelWithFrame:(CGRect)frame {
    CGRect newFrame = CGRectMake(0, 0, frame.size.width, frame.size.height / 4.0);
    self.titleLabel.frame = newFrame;
    self.titleLabel.text = @"Don't Rush!";
    self.titleLabel.textColor = [self colorFromHexString:@"#4d4d4d"];
    self.titleLabel.font = [UIFont fontWithName:@"Courier-Bold" size:24.0f];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.clipsToBounds = YES;
    [self addSubview:self.titleLabel];
}

- (void)setupSubtitleLabelWithFrame: (CGRect)frame {
    CGRect newFrame = CGRectMake(0, frame.size.height / 4.0, frame.size.width, frame.size.height / 8.0);
    self.subtitleLabel.frame = newFrame;
    self.subtitleLabel.text = @"Here's how to play:";
    self.subtitleLabel.textColor = [self colorFromHexString:@"#4d4d4d"];
    self.subtitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0f];
    self.subtitleLabel.textAlignment = NSTextAlignmentCenter;
    self.subtitleLabel.backgroundColor = [UIColor clearColor];
    self.subtitleLabel.clipsToBounds = YES;
    [self addSubview:self.subtitleLabel];
}

- (void)setupCommentLabelWithFrame: (CGRect)frame {
    float const padding = 25.0;
    float const width = frame.size.width - 2*padding;
    CGRect newFrame = CGRectMake(padding, frame.size.height *3.0/8.0, width, frame.size.height / 4.0);
    self.commentLabel.frame = newFrame;
    self.commentLabel.text = @"Swipe ☜ to draw new card\nSwipe ☞ to match";
    self.commentLabel.numberOfLines = 2.0;
    self.commentLabel.font = [UIFont fontWithName:@"Courier" size:16.0f];
    self.commentLabel.textColor = [self colorFromHexString:@"#4d4d4d"];
    self.commentLabel.textAlignment = NSTextAlignmentCenter;
    self.commentLabel.layer.cornerRadius = 8;
    self.commentLabel.layer.borderColor = [[self colorFromHexString:@"#f0f0f0"] CGColor];
    self.commentLabel.layer.backgroundColor = [[self colorFromHexString:@"#f6f6f6"] CGColor];
    self.commentLabel.layer.borderWidth = 4;
    self.commentLabel.clipsToBounds = YES;
    [self addSubview:self.commentLabel];
}

- (void)setupPlayButtonWithFrame: (CGRect)frame {
    float const padding = 25.0;
    //float const horizontalPadding = 75.0;
    float const verticalPadding = 25.0;
    float const width = (frame.size.width - 3*padding) / 2.0;
    CGRect newFrame = CGRectMake(padding, (frame.size.height *5.0/8.0) + verticalPadding , width, (2.0/3)*width);
    self.playButton.frame = newFrame;
    [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
    self.playButton.font = [UIFont fontWithName:@"Helvetica-Bold" size:24.0f];
    self.playButton.backgroundColor = [self colorFromHexString:@"#17b287"];
    self.playButton.layer.borderColor = [[self colorFromHexString:@"#17b287"] CGColor];
    self.playButton.layer.borderWidth = 1;
    self.playButton.layer.cornerRadius = 8;
    self.playButton.clipsToBounds = YES;
    [self addSubview:self.playButton];
}

- (void)setupHomeButtonWithFrame: (CGRect)frame {
    float const padding = 25.0;
    //float const horizontalPadding = 75.0;
    float const verticalPadding = 25.0;
    float const width = (frame.size.width - 3*padding) / 2.0;
    CGRect newFrame = CGRectMake(2*padding + width, (frame.size.height *5.0/8.0) + verticalPadding , width, (2.0/3)*width);
    self.homeButton.frame = newFrame;
    [self.homeButton setTitle:@"Exit" forState:UIControlStateNormal];
    [self.homeButton setTitleColor:[self colorFromHexString:@"#4d4d4d"] forState:UIControlStateNormal];
    self.homeButton.font = [UIFont fontWithName:@"Helvetica" size:24.0f];
    self.homeButton.backgroundColor = [self colorFromHexString:@"#d3d3d3"];
    self.homeButton.layer.borderColor = [[self colorFromHexString:@"#d3d3d3"] CGColor];
    self.homeButton.layer.borderWidth = 1;
    self.homeButton.layer.cornerRadius = 8;
    self.homeButton.clipsToBounds = YES;
    [self.homeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:self.homeButton];
}
@end
