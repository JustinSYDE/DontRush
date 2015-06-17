//
//  TutorialPopupView.m
//  
//
//  Created by Justin Wong on 2015-06-16.
//
//

#import "TutorialPopupView.h"

@implementation TutorialPopupView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.layer.cornerRadius = 8;
        self.clipsToBounds = YES;
        
        [self setupTitleLabelWithFrame:frame WithText:@"How to Play"];
        [self setupCommentLabelWithFrame:frame];
        [self setupPlayButtonWithFrame:frame WithText:@"Ready!"];
        [self setupHomeButtonWithFrame:frame WithText:@"Exit"];
    }
    
    return self;
}

- (void)setupCommentLabelWithFrame:(CGRect)frame {
    float const padding = 25.0;
    float const width = frame.size.width - 2*padding;
    CGRect newFrame = CGRectMake(padding, frame.size.height *3.0/8.0, width, frame.size.height / 0.75);
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

@end
