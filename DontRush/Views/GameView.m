//
//  GameView.m
//  DontRush
//
//  Created by Justin Wong on 2015-05-19.
//  Copyright (c) 2015 justinSYDE. All rights reserved.
//

#import "GameView.h"

@interface GameView()
//@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@end

@implementation GameView

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 6.0
#define NUM_COLUMNS 4
#define NUM_ROWS 4

+ (NSArray *)validColors {
    return @[@"#f8ae6c", @"#cae59c", @"#6b3b4e", @"#dd465f", @"#475358"];
}

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
    if (!self) return nil;
    [self setBackgroundColor:[UIColor clearColor]];
    [self drawGrid:frame];
    //[self generateColoredShapesForList:self.listOfShapes];
    self.overlayView = [[OverlayView alloc] initWithFrame:self.bounds];
    self.overlayView.alpha = 0;
    [self addSubview:self.overlayView];
    
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

- (CGFloat)cornerScaleFactor {
    return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT;
}

- (CGFloat)cornerRadius {
    return CORNER_RADIUS * [self cornerScaleFactor];
}

- (CGFloat)cornerOffSet {
    return [self cornerRadius] / 3.0;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    
    [roundedRect addClip]; // dont ever want to draw outside the rounded rect
    [[self colorFromHexString:@"#f2eedc"] setFill];
    UIRectFill(self.bounds); //fills the rectangle
}

- (void)drawGrid:(CGRect)frame {
    float width = 60;
    float height = 60;
    float x = frame.origin.x;
    float y = frame.origin.y - 223;
    
    for (int row = 0; row < NUM_ROWS; row++) {
        for (int column = 0 ; column < NUM_COLUMNS; column++) {
            //int randNum = rand() % 5;
            
            CGRect newCell = CGRectMake(x, y, width, height);
            
            UILabel *shapeLabel = [[UILabel alloc] initWithFrame:newCell];
            shapeLabel.text = @"●";
            shapeLabel.textAlignment = NSTextAlignmentCenter;
            [shapeLabel setBackgroundColor:[UIColor clearColor]];
            [shapeLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 100.0f]];
            [self addSubview:shapeLabel];
            
            [self.listOfShapes addObject:shapeLabel];
            [self addSubview:[self.listOfShapes lastObject]];
            x += width + 6;
        }
        
        x = frame.origin.x;
        y += height + 6;
    }
 }

- (void)updateOverlay:(CGFloat)distance
{
    if (distance > 0) {
        self.overlayView.mode = OverlayViewModeRight;
    } else if (distance <= 0) {
        self.overlayView.mode = OverlayViewModeLeft;
    }
    CGFloat overlayStrength = MIN(fabsf(distance) / 100, 0.4);
    self.overlayView.alpha = overlayStrength;
}

- (void)resetViewPositionAndTransformations
{
    [UIView animateWithDuration:0.2 animations:^{
        self.center = self.originalPoint;
        self.transform = CGAffineTransformMakeRotation(0);
        self.overlayView.alpha = 0;
    }];
}

#pragma mark - Event handlers

- (void)dragBeganEvent {
    self.originalPoint = self.center;
};

- (void)draggingEventwithxDistance:(CGFloat)xDistance andWithYDistance:(CGFloat)yDistance {
    CGFloat rotationStrength = MIN(xDistance / 320, 1);
    CGFloat rotationAngel = (CGFloat) (2*M_PI * rotationStrength / 16);
    CGFloat scaleStrength = 1 - fabsf(rotationStrength) / 4;
    CGFloat scale = MAX(scaleStrength, 0.93);
    CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngel);
    CGAffineTransform scaleTransform = CGAffineTransformScale(transform, scale, scale);
    self.transform = scaleTransform;
    self.center = CGPointMake(self.originalPoint.x + xDistance, self.originalPoint.y + yDistance);
    [self updateOverlay:xDistance];
};

- (void)dragFinishedEventWithxDistance:(CGFloat)xDistance {
    if (xDistance > (self.bounds.size.width * (3.5/5))) {
        self.alpha = 0;
        //[self generateColoredShapesForList: self.listOfShapes];
        self.transform = CGAffineTransformMakeRotation(0);
        self.center = self.originalPoint;
        self.overlayView.alpha = 0;
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 1;
        }];

    } else if (xDistance < - (self.bounds.size.width * (3.5/5))) {
        self.alpha = 0;
        //[self generateColoredShapesForList: self.listOfShapes];
        self.transform = CGAffineTransformMakeRotation(0);
        self.center = self.originalPoint;
        self.overlayView.alpha = 0;
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 1;
        }];
    } else {
        [self resetViewPositionAndTransformations];
    }
};

@end
