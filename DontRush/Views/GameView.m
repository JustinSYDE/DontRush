//
//  GameView.m
//  DontRush
//
//  Created by Justin Wong on 2015-05-19.
//  Copyright (c) 2015 justinSYDE. All rights reserved.
//

#import "GameView.h"

@implementation GameView

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 6.0
#define NUM_COLUMNS 4
#define NUM_ROWS 4
#pragma mark - Initialization

- (NSMutableArray *)listOfShapes {
    if (!_listOfShapes) {
        _listOfShapes = [[NSMutableArray alloc] init];
    }
    
    return _listOfShapes;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self drawGrid:frame];
        self.overlayView = [[OverlayView alloc] initWithFrame:self.bounds];
        self.overlayView.alpha = 0;
        [self addSubview:self.overlayView];
    }
    
    return self;
}

- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

#pragma mark - Drawing

- (void)drawGrid:(CGRect)frame {
    float width = frame.size.width / 4.0;
    float height = frame.size.height / 4.0;
    float x = 0;
    float y = 0;
    
    for (int row = 0; row < NUM_ROWS; row++) {
        for (int column = 0 ; column < NUM_COLUMNS; column++) {
            CGRect newCell = CGRectMake(x, y, width, height);
            UILabel *shapeLabel = [[UILabel alloc] initWithFrame:newCell];
            /*if ([self isIPhone4]) {
                [shapeLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 50.0f]];
            } else {
                [shapeLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 100.0f]];
            }*/
            shapeLabel.text = @"●";
            shapeLabel.textAlignment = NSTextAlignmentCenter;
            [shapeLabel setBackgroundColor:[self colorFromHexString:@"#e3d4c3"]];
            
            shapeLabel.layer.borderWidth = 2;
            shapeLabel.layer.borderColor = [[self colorFromHexString:@"#dbc8b2"] CGColor];
            shapeLabel.layer.cornerRadius = 8;
            shapeLabel.clipsToBounds = YES;
            
            [self addSubview:shapeLabel];
            [self.listOfShapes addObject:shapeLabel];
            
            [self addSubview:[self.listOfShapes lastObject]];
            x += width;
        }
        
        x = 0;
        y += height;
    }
 }

- (void)updateOverlay:(CGFloat)distance
{
    if (distance > 0) {
        self.overlayView.mode = OverlayViewModeRight;
    } else if (distance <= 0) {
        self.overlayView.mode = OverlayViewModeLeft;
    }
    CGFloat overlayStrength = MIN(fabsf(distance) / 100, 0.6);
    self.overlayView.alpha = overlayStrength;
}

- (void)resetViewPositionAndTransformations
{
    [UIView animateWithDuration:0.2 animations:^{
        self.center = self.originalPoint;
        self.transform = CGAffineTransformMakeRotation(0);
        self.overlayView.alpha = 0;
        self.layer.borderColor = [[self colorFromHexString:@"#dbc8b2"] CGColor];
    }];
}

#pragma mark - Event handlers

- (void)dragBeganEvent {
    self.originalPoint = self.center;
};

- (void)draggingEventwithxDistance:(CGFloat)xDistance andWithYDistance:(CGFloat)yDistance AndReverse:(BOOL)reverse {
    
    CGFloat rotationStrength = MIN(xDistance / 320, 1);
    CGFloat rotationAngel = (CGFloat) (2*M_PI * rotationStrength / 16);
    CGFloat scaleStrength = 1 - fabsf(rotationStrength) / 4;
    CGFloat scale = MAX(scaleStrength, 0.93);
    CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngel);
    CGAffineTransform scaleTransform = CGAffineTransformScale(transform, scale, scale);
    self.transform = scaleTransform;
    self.center = CGPointMake(self.originalPoint.x + xDistance, self.originalPoint.y + yDistance);
    if (reverse){
        if (self.frame.origin.x > self.frame.size.width / 19.0) {
            self.layer.borderColor = [[self colorFromHexString:@"#dd465f"] CGColor];
        } else if (self.frame.origin.x < self.frame.size.width / 19.0) {
            self.layer.borderColor = [[self colorFromHexString:@"#17b287"] CGColor];
        }

        [self updateOverlay:-xDistance];
    } else {
        if (self.frame.origin.x > self.frame.size.width / 19.0) {
            self.layer.borderColor = [[self colorFromHexString:@"#17b287"] CGColor];
        } else if (self.frame.origin.x < self.frame.size.width / 19.0) {
            self.layer.borderColor = [[self colorFromHexString:@"#dd465f"] CGColor];
        }

        [self updateOverlay:xDistance];
    }
};

- (void)dragFinishedEventWithxDistance:(CGFloat)xDistance {
    if (xDistance > (self.bounds.size.width * (1.5/5))) {
        self.alpha = 0;
        self.transform = CGAffineTransformMakeRotation(0);
        self.center = self.originalPoint;
        self.overlayView.alpha = 0;
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 1;
        }];

    } else if (xDistance < - (self.bounds.size.width * (1.5/5))) {
        self.alpha = 0;
        self.transform = CGAffineTransformMakeRotation(0);
        self.center = self.originalPoint;
        self.overlayView.alpha = 0;
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 1;
        }];
    } else {
        [self resetViewPositionAndTransformations];
    }
};

- (void)resetGrid {
    for (UILabel *shapeLabel in self.listOfShapes) {
        shapeLabel.backgroundColor = [self colorFromHexString:@"#e3d4c3"];
    }
    self.layer.borderColor = [[self colorFromHexString:@"#dbc8b2"] CGColor];
}

@end
