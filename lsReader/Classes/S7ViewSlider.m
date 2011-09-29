//
//  S7ViewSlider.m
//  lsReader
//
//

#import "S7ViewSlider.h"

@interface S7ViewSlider (PrivateMethods)

- (void)slideTableView:(S7SlideDirection)direction;

@end



@implementation S7ViewSlider

@synthesize viewToSlide = _viewToSlide;
@synthesize ySlideDistance = _ySlideDistance, heightSlideDistance = _heightSlideDistance, slideDuration = _slideDuration;
@synthesize hideKeyboardOnReturn = _hideKeyboardOnReturn;

- (id)init {
	
	if (self = [super init]) {
		_slideDuration = 0.3f;
	}
	return self;
}

- (void)dealloc {
	
	[_viewToSlide release];
	[super dealloc];
}

#pragma mark TextField Callbacks

- (void)textFieldDidBeginEditing:(UITextField *)textField {
		NSLog(@"startbeginediting");
	[self slideTableView:S7SlideDirectionUp];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	
	[self slideTableView:S7SlideDirectionDown];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	if (self.hideKeyboardOnReturn) {
		[textField resignFirstResponder];
	}
	
	return YES;
}

#pragma mark Private Methods

- (void)slideTableView:(S7SlideDirection)direction {
	
	NSLog(@"start");
	CGFloat y = S7SlideDirectionUp == direction ? -self.ySlideDistance : self.ySlideDistance;
	CGFloat height = S7SlideDirectionUp == direction ? -self.heightSlideDistance : self.heightSlideDistance;
	
	CGRect rect = self.viewToSlide.frame;
	rect = CGRectMake(rect.origin.x, rect.origin.y + y, rect.size.width, rect.size.height + height);
	
	[UIView beginAnimations:@"S7ViewSlider::slideView" context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:self.slideDuration];
	
	self.viewToSlide.frame = rect;
	
	[UIView commitAnimations];
    NSLog(@"end");
}

@end
