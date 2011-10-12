//
//  TopicViewController.m
//  lsReader
//
//  Created by Usov Sergei on 26.09.11.
//  Copyright 2011 LiveStreet Developers Team. All rights reserved.
//

#import "TopicViewController.h"


@implementation TopicViewController

@synthesize webView;
@synthesize topicId;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
    [super viewDidLoad];
	
}


-(void) viewWillAppear:(BOOL)animated{

	NSDictionary *topic_data = [[Communicator sharedCommunicator] readTopicById:self.topicId];
		
	NSString *topicContent =	[topic_data objectForKey: @"topic_text" ];
	
	NSURL *base_url = [NSURL URLWithString: [@"http://www." stringByAppendingString: [Communicator sharedCommunicator].siteURL ]];	
		
	[webView loadHTMLString:topicContent baseURL:base_url];//
	
	
	
	//[[UIApplication sharedApplication] openURL:base_url];
    	
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
	
	// 
	
	if (navigationType != UIWebViewNavigationTypeLinkClicked) {
	
		return YES;
	}
    else {

		// Запус сафариы
		[[UIApplication sharedApplication] openURL:request.URL ];
	
	return NO;
	}
}



/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
