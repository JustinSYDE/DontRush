#import "OverlayView.h"

@interface OverlayView ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation OverlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"reject"]];
        CGRect newFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.imageView.frame = newFrame;

        [self addSubview:self.imageView];
    }

    return self;
}

- (void)setMode:(OverlayViewMode)mode
{
    if (_mode == mode) return;

    _mode = mode;
    if (mode == OverlayViewModeLeft) {
        self.imageView.image = [UIImage imageNamed:@"reject"];
    } else {
        self.imageView.image = [UIImage imageNamed:@"accept"];
    }
}

@end