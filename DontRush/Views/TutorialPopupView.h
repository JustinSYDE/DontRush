//
//  TutorialPopupView.h
//  
//
//  Created by Justin Wong on 2015-06-16.
//
//

#import "PopupView.h"

@interface TutorialPopupView : PopupView

- (instancetype)initTutorialWithFrame:(CGRect)frame;
- (void)slideTutorialViewIn;
- (void)slideTutorialViewOut;
@end
