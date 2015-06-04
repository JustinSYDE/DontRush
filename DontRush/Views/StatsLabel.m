//
//  StatsLabel.m
//  DontRush
//
//  Created by Justin Wong on 2015-06-03.
//  Copyright (c) 2015 justinSYDE. All rights reserved.
//

#import "StatsLabel.h"

@implementation StatsLabel

// Assumes input like "#00FF00" (#RRGGBB).
+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

- (instancetype)initWithText:(NSString *)textLabel withBackgroundColor:(NSString *)hexColor{
    self = [super init];
    if (self) {
        self.text = textLabel;
        self.textAlignment = NSTextAlignmentCenter;
        self.numberOfLines = 2;
        [self setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
        [self setTextColor:[UIColor whiteColor]];
        self.backgroundColor = [StatsLabel colorFromHexString:hexColor];
        self.layer.cornerRadius = 4;
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [[StatsLabel colorFromHexString:hexColor] CGColor];
        self.clipsToBounds = YES;
    }
    
    return self;
}

@end
