//
//  GameView.m
//  DontRush
//
//  Created by Justin Wong on 2015-05-19.
//  Copyright (c) 2015 justinSYDE. All rights reserved.
//

#import "GameView.h"

@interface GameView()
@end

@implementation GameView

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 6.0
#define NUM_COLUMNS 4
#define NUM_ROWS 4

+ (NSArray *)validColors {
    return @[@"#f8ae6c", @"#cae59c", @"#6b3b4e", @"#dd465f", @"#475358"];
}

- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

#pragma mark - Properties

- (void)setShapesOnCard:(NSDictionary *)shapesOnCard {
    _shapesOnCard = shapesOnCard;
    [self setNeedsDisplay];
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
    
    //[[UIColor blackColor] setStroke];
    //[roundedRect stroke];
    
    CGRect testRect;
    testRect.origin = CGPointMake([self cornerOffSet], [self cornerOffSet]);
    //testRect.size = [testText size];
}

- (void)drawGrid:(CGRect)frame {
    float width = 60;
    float height = 60;
    float x = frame.origin.x;
    float y = frame.origin.y - 223;
    
    for (int row = 0; row < NUM_ROWS; row++) {
        for (int column = 0 ; column < NUM_COLUMNS; column++) {
            int randNum = rand() % 5;
            
            CGRect newCell = CGRectMake(x, y, width, height);
            
            UILabel *shapeLabel = [[UILabel alloc] initWithFrame:newCell];
            shapeLabel.text = @"●";
            shapeLabel.textAlignment = NSTextAlignmentCenter;
            [shapeLabel setTextColor:[self colorFromHexString:[GameView validColors][randNum]]];
            [shapeLabel setBackgroundColor:[UIColor clearColor]];
            [shapeLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 100.0f]];
            [self addSubview:shapeLabel];
            
            [self.arrayOfSubviews addObject:shapeLabel];
            [self addSubview:[self.arrayOfSubviews lastObject]];
            x += width + 6;
        }
        
        x = frame.origin.x;
        y += height + 6;
    }
 }


#pragma mark - Initialization

- (NSMutableArray *)arrayOfSubviews {
    if (!_arrayOfSubviews) {
        _arrayOfSubviews = [[NSMutableArray alloc] init];
    }
    
    return _arrayOfSubviews;
}

- (void)setup {
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib {
    [self setup]; // the view will be created in the story board
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    [self setBackgroundColor:[UIColor whiteColor]];
    [self drawGrid:frame];
    
    return self;
}

@end
