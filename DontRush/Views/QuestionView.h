//
//  QuestionView.h
//  DontRush
//
//  Created by Justin Wong on 2015-06-04.
//  Copyright (c) 2015 justinSYDE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionView : UIView
@property (nonatomic) UILabel *questionLabel;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)updateQuestionLabel:(NSAttributedString *)text;

@end
