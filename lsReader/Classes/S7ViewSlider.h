//
//  S7ViewSlider.h
//  lsReader_002
//
//  Created by Сергей Усов on 04.09.11.
//  Copyright 2011 Стройкомплект. All rights reserved.
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
