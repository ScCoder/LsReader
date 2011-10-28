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
@synthesize voteBar;
@synthesize voteSegControl;

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


- (void) costomizeView {
  if ([[Communicator sharedCommunicator] isLogedIn]) {
	
		[voteBar setHidden: NO];
		webView.frame = CGRectMake(webView.frame.origin.x
									 ,webView.frame.origin.y
									 ,webView.frame.size.width
									 ,self.view.frame.size.height - voteBar.frame.size.height);
	 
	 }
	 else{
		 [voteBar setHidden: YES];
		 webView.frame = CGRectMake(webView.frame.origin.x
									 ,webView.frame.origin.y
									 ,webView.frame.size.width
									 ,self.view.frame.size.height);
		 
	 }

}
-(void) viewWillAppear:(BOOL)animated{

	NSDictionary *topic_data = [[Communicator sharedCommunicator] readTopicById:self.topicId];
		
	//OLD   NSString *topicContent =	[topic_data objectForKey: @"topic_text" ];
	
	
	
	NSMutableString *topicContent = [[NSMutableString alloc] initWithCapacity:10];
	
	[topicContent  appendString: [topic_data objectForKey: @"topic_text" ]];
	
	if (![Communicator sharedCommunicator].showPics) {
	
	  //Обрезать картинки
		[self cutImagesFromText:topicContent];
		
	}
	
	
	NSURL *base_url = [NSURL URLWithString: [@"http://www." stringByAppendingString: [Communicator sharedCommunicator].siteURL ]];	
		
	[webView loadHTMLString:topicContent baseURL:base_url];//

	[topicContent release];
	
	
	[self costomizeView];

    	
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
	

	if (navigationType != UIWebViewNavigationTypeLinkClicked) {
	
		return YES;
	}
    else {

		// Запуск сафари
		[[UIApplication sharedApplication] openURL:request.URL ];
	
	return NO;
	}
	
	 
	
	
	
}



-(IBAction) votingForTopic:(id) sender{
 
	NSLog( @" %i",[(UIBarButtonItem *)sender tag] );
	
	NSString *newRating = [[Communicator sharedCommunicator] voteByTopicId:self.topicId 
																	 value:[(UIBarButtonItem *)sender tag]
						   ];
	
	NSLog(@"new Rating = %@",newRating);
		
}

-(void) cutImagesFromText:(NSMutableString *) intext{
	
	NSError *error = NULL;
	NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern: @"<img[^>]src=\"([^>\"]+)\"[^>]*>"
																			options:NSRegularExpressionCaseInsensitive
																			  error:&error];
	
    [regExp replaceMatchesInString:intext options:0 range:NSMakeRange(0,[intext length]) withTemplate:@"<a href = $1> picture </a>"];

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
	[voteSegControl release];
	[webView release];
    [super dealloc];
}


@end
