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
}

@property (nonatomic, retain) IBOutlet UIWebView *webView; 

@property (nonatomic, retain) NSString *topicId;

@end
