//
//  GameView.h
//  DontRush
//
//  Created by Justin Wong on 2015-05-19.
//  Copyright (c) 2015 justinSYDE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>
#import "OverlayView.h"

@interface GameView : UIView

@property (nonatomic) NSDictionary *shapesOnCard;
@property(nonatomic) CGPoint originalPoint;
@property (nonatomic, strong) NSMutableArray *listOfShapes;
@property(nonatomic, strong) OverlayView *overlayView;

+ (NSArray *)validColors;
- (void)updateOverlay:(CGFloat)distance;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)generateColoredShapesForList:(NSMutableArray *)list;

@end
