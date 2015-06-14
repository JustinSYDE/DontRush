//
//  QuestionView.m
//  DontRush
//
//  Created by Justin Wong on 2015-06-04.
//  Copyright (c) 2015 justinSYDE. All rights reserved.
//

#import "QuestionView.h"

@interface QuestionView()

@end

@implementation QuestionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        [self setupQuestionLabelWithFrame:frame];
    }
    
    return self;
}

- (UILabel *)questionLabel {
    if (!_questionLabel) {
        _questionLabel = [[UILabel alloc] init];
    }
    
    return _questionLabel;
}

- (void)setupQuestionLabelWithFrame:(CGRect)frame {
    CGRect newFrame = CGRectMake(25, 0, frame.size.width, frame.size.height);
    self.questionLabel.frame = newFrame;
    self.questionLabel.textAlignment = NSTextAlignmentLeft;
    self.questionLabel.font = [UIFont fontWithName:@"Helvetica" size:75.0f];
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.questionLabel];
}

- (void)updateQuestionLabel:(NSAttributedString *)text {
    if (!text) return;
    self.questionLabel.attributedText = text;
}

@end
