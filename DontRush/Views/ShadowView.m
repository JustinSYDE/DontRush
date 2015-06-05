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
        self.alpha = 0.6;
    }
    
    return self;
}

@end
