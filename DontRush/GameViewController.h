//
//  GameViewController.h
//  DontRush
//
//  Created by Justin Wong on 2015-05-18.
//  Copyright (c) 2015 justinSYDE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameView.h"

@interface GameViewController : UIViewController
@property (nonatomic, strong) GameView *frontCardView;
@property (nonatomic, strong) GameView *backCardView;

+ (UIColor *)colorFromHexString:(NSString *)hexString;
@end

