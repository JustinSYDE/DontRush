//
//  GameTwistView.m
//  DontRush
//
//  Created by Justin Wong on 2015-06-06.
//  Copyright (c) 2015 justinSYDE. All rights reserved.
//

#import "GameTwistView.h"

@implementation GameTwistView

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
        self.frame = frame;
        self.backgroundColor = [self colorFromHexString:@"#f2eedc"];
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        self.twistLabel.frame = newFrame;
        [self addSubview:self.twistLabel];
        self.alpha = 0;
    }
    
    return self;
}

- (UILabel *)twistLabel {
    if (!_twistLabel) {
        _twistLabel = [[UILabel alloc] init];
    }
    
    return _twistLabel;
}

- (void)updateGameTwistWithText:(NSString *)text {
    self.alpha = 1;
    self.twistLabel.alpha = 1;
    self.twistLabel.text = text;
    self.twistLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:50.0f];
    self.twistLabel.textAlignment = NSTextAlignmentCenter;
    [NSTimer scheduledTimerWithTimeInterval:0.5
        target:self
        selector:@selector(fadeOut)
        userInfo:nil
        repeats:NO];
}

- (void)fadeOut {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    }];
}

@end
