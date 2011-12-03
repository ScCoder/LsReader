//
//  linkTopicViewController.m
//  lsReader
//
//  Created by Сергей Усов on 03.12.11.
//  Copyright 2011 LiveStreet Developers Team. All rights reserved.
//

#import "linkTopicViewController.h"


@implementation linkTopicViewController


@synthesize linkBtn;
@synthesize linkDescription;
@synthesize linkTitle;
@synthesize linkURL;

@synthesize topic_data;

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
 
	
	self.linkTitle.text = [topic_data objectForKey: @"topic_title"];
	self.linkDescription.text = [topic_data objectForKey: @"topic_text_short"]; 
	self.linkURL.text = [[topic_data objectForKey: @"topic_extra_array"] objectForKey:@"url"]; 
	
	

}


-(IBAction) linkBtnTouched:(id) sender{
	
	NSMutableString *url = [NSMutableString stringWithString:linkURL.text];
	
	if ( ![[url substringToIndex:3] isEqualToString:@"http"]){
		url =  [NSString stringWithFormat:@"http://%@",url];
	}
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];

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
	
	
	self.linkBtn = nil;
	self.linkDescription = nil;
	self.linkTitle = nil;
	self.linkURL = nil;
	
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
