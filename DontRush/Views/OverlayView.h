#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger , OverlayViewMode) {
    OverlayViewModeLeft,
    OverlayViewModeRight
};

@interface OverlayView : UIView
@property (nonatomic) OverlayViewMode mode;
@end