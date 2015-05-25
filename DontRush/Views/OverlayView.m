#import "OverlayView.h"

@interface OverlayView ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation OverlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    self.backgroundColor = [UIColor whiteColor];
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trollface_300x200"]];
    [self addSubview:self.imageView];

    return self;
}

- (void)setMode:(OverlayViewMode)mode
{
    if (_mode == mode) return;

    _mode = mode;
    if (mode == OverlayViewModeLeft) {
        self.imageView.image = [UIImage imageNamed:@"trollface_300x200"];
    } else {
        self.imageView.image = [UIImage imageNamed:@"thumbs_up_300x300"];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(50, 50, 100, 100);
}

@end