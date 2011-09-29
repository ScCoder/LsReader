//
//  S7ViewSlider.h
//  lsReader
//
//

#import <Foundation/Foundation.h>

typedef enum {
	S7SlideDirectionUp,
	S7SlideDirectionDown
} S7SlideDirection;



@interface S7ViewSlider : NSObject<UITextFieldDelegate> {

@private
	UIView *_viewToSlide;
	CGFloat _ySlideDistance;
	CGFloat _heightSlideDistance;
	CGFloat _slideDuration;
	BOOL _hideKeyboardOnReturn;
	
}

@property (nonatomic, retain) IBOutlet UIView *viewToSlide;
@property (nonatomic, assign) CGFloat ySlideDistance;
@property (nonatomic, assign) CGFloat heightSlideDistance;
@property (nonatomic, assign) CGFloat slideDuration;
@property (nonatomic, assign) BOOL hideKeyboardOnReturn;

@end
