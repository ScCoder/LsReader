//
//  PhotosetTopicViewContoller.m
//  lsReader
//
//  Created by Сергей Усов on 03.12.11.
//  Copyright 2011 LiveStreet Developers Team. All rights reserved.
//

#import "PhotosetTopicViewContoller.h"


@implementation PhotosetTopicViewContoller


@synthesize photosetMainImage;
@synthesize photosetScrollView;
@synthesize photosetImageTitle;
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


    photosetImages = [[NSMutableArray alloc] initWithCapacity:5];
	
	
	NSDictionary *photos = [topic_data objectForKey: @"photoset_photos"] ;
	
	CGFloat x = 0;
	CGFloat btnWidth = 50;
	CGFloat btnHeight = 50;
	
	
	
	NSInteger imgIndex = 0;
	
	for (id photo in photos){
		
		UIButton *btn = [[UIButton alloc] initWithFrame: CGRectMake(x,0,btnWidth, btnHeight)];
		
		x += btnWidth;
		
		
		
		NSMutableString *img_url = [[NSMutableString alloc] initWithString:[photo objectForKey:@"path"]];			
		[img_url replaceOccurrencesOfString:@".jpg" withString:@"_50crop.jpg" options:0 range: NSMakeRange(0,[img_url length])];
		[img_url replaceOccurrencesOfString:@".png" withString:@"_50crop.png" options:0 range: NSMakeRange(0,[img_url length])];
		
		
		UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:img_url]]];
		
		[img_url release];
		
		[btn setImage:image forState:UIControlStateNormal];
		
		[btn setTag:imgIndex];
		
		
		NSMutableString *img_url_hq = [[NSMutableString alloc] initWithString:[photo objectForKey:@"path"]];			
		[img_url_hq replaceOccurrencesOfString:@".jpg" withString:@"_500.jpg" options:0 range: NSMakeRange(0,[img_url_hq length])];
		[img_url_hq replaceOccurrencesOfString:@".png" withString:@"_500.png" options:0 range: NSMakeRange(0,[img_url_hq length])];
		
		[photosetImages addObject:img_url_hq];
		
		[img_url_hq release];
		
		imgIndex++;
		
		
		[image release];
		
		[btn addTarget: self action: @selector( photosetImageTouched: ) forControlEvents: UIControlEventTouchDown ];
		
		[self.photosetScrollView addSubview:btn];
		
		[btn release];
	}
	
	NSDictionary *mainPhoto = [topic_data objectForKey: @"photoset_main_photo"];
	
	
	NSMutableString *img_url = [[NSMutableString alloc] initWithString:[mainPhoto objectForKey:@"path"]];
	
	[img_url replaceOccurrencesOfString:@".jpg" withString:@"_500.jpg" options:0 range: NSMakeRange(0,[img_url length])];
	[img_url replaceOccurrencesOfString:@".png" withString:@"_500.png" options:0 range: NSMakeRange(0,[img_url length])];
	
	
	UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:img_url]]];
	
	[img_url release];
	
	[self.photosetMainImage setImage:image];
	
	[image release];
	
	[self.photosetImageTitle setText:[mainPhoto objectForKey:@"description"] ];
	
	[self.photosetScrollView setContentSize:CGSizeMake(x, btnHeight)];
	

}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(IBAction) photosetImageTouched:(id) sender{
	
    //[self fadeView: self.mainImage fadeOut:YES];
	
	
	
	UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[photosetImages objectAtIndex:((UIButton *)sender).tag]]]];
	
	[self.photosetMainImage setImage:image];
	
	[image release];
	
	
	//[self fadeView: self.mainImage fadeOut:NO];
}


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
	
	[photosetImages release];
}


@end
