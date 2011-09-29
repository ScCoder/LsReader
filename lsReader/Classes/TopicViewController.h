//
//  TopicViewController.h
//  lsReader
//
//  Created by Usov Sergei on 26.09.11.
//  Copyright 2011 LiveStreet Developers Team. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TopicViewController : UIViewController {

	UIWebView *webView;
	NSString *topicContent;
	NSURL *topicURL;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView; 

@property (nonatomic, retain) NSString *topicContent;

@property (nonatomic, retain) NSURL *topicURL;

@end
