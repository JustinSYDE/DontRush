//
//  TwistIconView.m
//  DontRush
//
//  Created by Justin Wong on 2015-06-07.
//  Copyright (c) 2015 justinSYDE. All rights reserved.
//

#import "TwistIconView.h"

@interface TwistIconView()

@property (nonatomic) UIImageView *iconImage;

@end

@implementation TwistIconView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.frame = frame;
    }
    
    return self;
}

- (void)updateTwistIconLabelWithIcon:(NSString *)iconName {
    self.iconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
    float const x = (self.frame.size.width - 35) / 2.0;
    CGRect newFrame = CGRectMake(0, 0, 25, self.frame.size.height);
    self.iconImage.frame = newFrame;
    [self addSubview:self.iconImage];
}

@end
