//
//  PopupView.h
//  DontRush
//
//  Created by Justin Wong on 2015-06-04.
//  Copyright (c) 2015 justinSYDE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopupView : UIView

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *subtitleLabel;
@property (nonatomic) UILabel *commentLabel;
@property (nonatomic) UIButton *playButton;
@property (nonatomic) UIButton *homeButton;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)setupTitleLabelWithFrame:(CGRect)frame WithText: (NSString *)text;
- (void)setupCommentLabelWithFrame:(CGRect)frame;
- (void)setupPlayButtonWithFrame:(CGRect)frame WithText: (NSString *)text;
- (void)setupHomeButtonWithFrame:(CGRect)frame WithText: (NSString *)text;
- (UIColor *)colorFromHexString:(NSString *)hexString;
- (void)slidePopupViewIn;
- (void)slidePopupViewOut;

@end
