//
//  StatsLabel.h
//  DontRush
//
//  Created by Justin Wong on 2015-06-03.
//  Copyright (c) 2015 justinSYDE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatsLabel : UILabel

+ (UIColor *)colorFromHexString:(NSString *)hexString;

- (instancetype)initWithText:(NSString *)textLabel withBackgroundColor:(NSString *)hexColor;

@end
