//
//  ShadowView.m
//  DontRush
//
//  Created by Justin Wong on 2015-06-04.
//  Copyright (c) 2015 justinSYDE. All rights reserved.
//

#import "ShadowView.h"

@implementation ShadowView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0;
        self.hidden = YES;
    }
    
    return self;
}

- (void)hideShadow {
    self.hidden = YES;
    [UIView animateWithDuration:1.0 animations:^{
        self.alpha = 0;
    }];
}

- (void)showShadow {
    self.hidden = NO;
    self.alpha = 0;
    [UIView animateWithDuration:1.0 animations:^{
        self.alpha = 0.6;
    }];
}
@end
