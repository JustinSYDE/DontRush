//
//  TutorialPopupView.m
//  
//
//  Created by Justin Wong on 2015-06-16.
//
//

#import "TutorialPopupView.h"

@implementation TutorialPopupView

- (instancetype)initTutorialWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.layer.cornerRadius = 8;
        self.clipsToBounds = YES;
        
        [self setupTitleLabelWithFrame:frame WithText:@"How to Play"];
        self.subtitleLabel.hidden = YES;
        [self setupCommentLabelWithFrame:frame];
        [self setupPlayButtonWithFrame:frame WithText:@"Ready"];
        [self setupHomeButtonWithFrame:frame WithText:@"Exit"];
    }
    
    return self;
}

- (void)setupCommentLabelWithFrame:(CGRect)frame {
    float const padding = 25.0;
    float const width = frame.size.width - 2*padding;
    CGRect newFrame = CGRectMake(padding, frame.size.height * 0.2, width, frame.size.height * 0.55);
    self.commentLabel.frame = newFrame;
    
    CGRect otherFrame = CGRectMake(padding, 0, width*0.8, frame.size.height * 0.5);
    UILabel *comment = [[UILabel alloc] initWithFrame:otherFrame];
    comment.text = @"Swipe ☞ if the board has the same number of colored dots as specified by the colored word\n\nElse, swipe ☜ to draw a new card\n\nReach high scores to unlock game twists";
    comment.numberOfLines = 15.0;
    comment.font = [UIFont fontWithName:@"Courier" size:16.0f];
    comment.textColor = [self colorFromHexString:@"#4d4d4d"];
    comment.textAlignment = NSTextAlignmentJustified;
    self.commentLabel.layer.cornerRadius = 8;
    self.commentLabel.layer.borderColor = [[self colorFromHexString:@"#f0f0f0"] CGColor];
    self.commentLabel.layer.backgroundColor = [[self colorFromHexString:@"#f6f6f6"] CGColor];
    self.commentLabel.layer.borderWidth = 4;
    self.commentLabel.clipsToBounds = YES;
    [self.commentLabel addSubview:comment];
    [self addSubview:self.commentLabel];
}

- (void)setupPlayButtonWithFrame: (CGRect)frame WithText:(NSString *)text{
    float const padding = 25.0;
    //float const horizontalPadding = 75.0;
    float const verticalPadding = 25.0;
    float const width = (frame.size.width - 3*padding) / 2.0;
    CGRect newFrame = CGRectMake(padding, (frame.size.height *6.0/8.0) + verticalPadding , width, (2.0/3)*width);
    self.playButton.frame = newFrame;
    [self.playButton setTitle:text forState:UIControlStateNormal];
    self.playButton.font = [UIFont fontWithName:@"Helvetica-Bold" size:24.0f];
    self.playButton.backgroundColor = [self colorFromHexString:@"#17b287"];
    self.playButton.layer.borderColor = [[self colorFromHexString:@"#17b287"] CGColor];
    self.playButton.layer.borderWidth = 1;
    self.playButton.layer.cornerRadius = 8;
    self.playButton.clipsToBounds = YES;
    [self addSubview:self.playButton];
}

- (void)setupHomeButtonWithFrame: (CGRect)frame WithText: (NSString *)text {
    float const padding = 25.0;
    //float const horizontalPadding = 75.0;
    float const verticalPadding = 25.0;
    float const width = (frame.size.width - 3*padding) / 2.0;
    CGRect newFrame = CGRectMake(2*padding + width, (frame.size.height *6.0/8.0) + verticalPadding , width, (2.0/3)*width);
    self.homeButton.frame = newFrame;
    [self.homeButton setTitle:text forState:UIControlStateNormal];
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

- (void)slideTutorialViewIn {
    [UIView animateWithDuration:1.0 animations:^{
        CGRect screen = [[UIScreen mainScreen] bounds];
        CGPoint point = CGPointMake(self.center.x, screen.size.height / 2.0);
        self.center = point;
    }];
}

- (void)slideTutorialViewOut {
    [UIView animateWithDuration:1.0 animations:^{
        CGRect screen = [[UIScreen mainScreen] bounds];
        CGPoint point = CGPointMake(self.center.x, screen.size.height*1.5);
        self.center = point;
    }];
}

@end
