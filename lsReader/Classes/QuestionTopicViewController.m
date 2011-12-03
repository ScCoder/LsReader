//
//  QuestionTopicViewController.m
//  lsReader
//
//  Created by Сергей Усов on 03.12.11.
//  Copyright 2011 LiveStreet Developers Team. All rights reserved.
//

#import "QuestionTopicViewController.h"


@implementation QuestionTopicViewController


@synthesize topic_data;


- (void)viewDidLoad {
	
	selectedAnswer = -1;
	
	keys = [[NSArray alloc] initWithArray:[topic_data allKeys]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	return [keys count];
	
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

	
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil) {
		
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		
    }
	
	;
	/*
	cell.textLabel.text = [[[topic_data  
							objectForKey:@"topic_extra_array"]
							objectForKey:@"answers"]
						   objectForKey:@"text"]
						   ;
	
	 */
	if (indexPath.row == selectedAnswer) {
		
		//cell.accessoryType = UITableViewCellAccessoryCheckmark;
		cell.imageView.image = [UIImage imageNamed:@"radiobutton_checked.png"];
		
	} else {
		
			cell.imageView.image = [UIImage imageNamed:@"radiobutton_unchecked.png"];
		
	}

	
	
	return cell;
	 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	selectedAnswer = indexPath.row;
	
    [tableView reloadData];
	
}

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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

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
	topic_data = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[topic_data release];
	[keys release];
}


@end
