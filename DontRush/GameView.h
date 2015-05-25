//
//  GameView.h
//  DontRush
//
//  Created by Justin Wong on 2015-05-19.
//  Copyright (c) 2015 justinSYDE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>

@interface GameView : UIView

@property (nonatomic) NSDictionary *shapesOnCard;
@property(nonatomic) CGPoint originalPoint;
@property (nonatomic, strong) NSMutableArray *arrayOfSubviews;

- (instancetype)initWithFrame:(CGRect)frame;
+ (NSArray *)validColors;

@end
