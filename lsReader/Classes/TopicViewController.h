//
//  TopicViewController.h
//  lsReader
//
//  Created by Usov Sergei on 26.09.11.
//  Copyright 2011 LiveStreet Developers Team. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TopicViewController : UIViewController<UIWebViewDelegate>{

	UIWebView *webView;
	NSString *tiopicId;
	UIToolbar *voteBar;
	UISegmentedControl *voteSegControl;
	UISegmentedControl *voteSegControl1;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView; 

@property (nonatomic, retain) IBOutlet UIToolbar *voteBar;

@property (nonatomic, retain) NSString *topicId;

@property (nonatomic, retain) IBOutlet UISegmentedControl *voteSegControl;
@property (nonatomic, retain) IBOutlet UISegmentedControl *voteSegControl1;
-(IBAction) voting;
-(void) cutImagesFromText:(NSMutableString *) intext;

@end
