//
//  GameMessageView.h
//  DontRush
//
//  Created by Justin Wong on 2015-06-06.
//  Copyright (c) 2015 justinSYDE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameMessageView : UIView

- (instancetype)initWithFrame:(CGRect)frame;
- (void)updateGameMessageWithText:(NSString *)text;

@end
