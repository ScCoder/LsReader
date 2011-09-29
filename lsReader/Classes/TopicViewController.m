//
//  TopicViewController.m
//  lsReader_002
//
//  Created by Сергей Усов on 26.09.11.
//  Copyright 2011 Стройкомплект. All rights reserved.
//

#import "TopicViewController.h"


@implementation TopicViewController

@synthesize webView;
@synthesize topicContent;
@synthesize topicURL;
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
    
	NSLog(@"st");
	[webView loadHTMLString:self.topicContent baseURL:[NSURL URLWithString:@"http://www.new.livestreet.ru"]];// baseURL:<#(NSURL *)baseURL#>
    NSLog(@"end");
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
