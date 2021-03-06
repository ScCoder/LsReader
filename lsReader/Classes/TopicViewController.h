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
	UIBarButtonItem *ratingLabel;
	UIBarButtonItem *comentsBtn;
	UIBarButtonItem *voteBtn;
	
	UIBarButtonItem *autorLabel;
	NSMutableDictionary *topic_data;


	UIActivityIndicatorView *waitView;
	NSOperationQueue *opQueue;
	
	UIView *contentView;
	//UIActivityIndicatorView *activityIndicator;

}

@property (nonatomic, retain) IBOutlet UIWebView *webView; 

@property (nonatomic, retain) IBOutlet UIToolbar *voteBar;

@property (nonatomic, retain) NSString *topicId;

@property (nonatomic, retain) IBOutlet UISegmentedControl *voteSegControl;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *ratingLabel;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *comentsBtn;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *voteBtn;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *autorLabel;



@property (nonatomic, retain) IBOutlet UIView *contentView;

//@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;

-(void) cutImagesFromText:(NSMutableString *) intext;

-(void) loadData:(NSMutableDictionary*)data;
- (void) done;

-(IBAction) votingForTopic:(id) sender;
-(IBAction) showTopicInfo;
-(IBAction) showRating;
-(IBAction) showComents;
-(IBAction) bookmarkTopic;


@end
