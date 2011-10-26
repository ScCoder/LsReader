//
//  PublicationViewController.m
//  lsReader
//
//  Created by Usov Sergei on 28.08.11.
//  Copyright 2011 LiveStreet Developers Team. All rights reserved.
//

#import "PublicationViewController.h"
#import "JSONKit.h"
#import "PublicationDetailViewController.h"
#import "Consts.h"



@implementation PublicationViewController

@synthesize testLabel;
@synthesize myTable;
@synthesize publicTypes;
@synthesize activityIndicator;
@synthesize parentNav;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.publicTypes count];
	
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
	
	UIImage *image = [UIImage imageNamed:@"Star-full-32.png"];
	
	cell.textLabel.text = [self.publicTypes objectAtIndex:indexPath.row];
	
	
    cell.imageView.image = image;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	
	return cell;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	NSLog(@" DidSelect: ");	
	
	PublicationDetailViewController *pdVC = [[PublicationDetailViewController alloc] initWithNibName:@"PublicationDetailViewController" bundle:nil];
	
	pdVC.publication_type = [self.publicTypes objectAtIndex:indexPath.row];
	
	//[pdVC autorelease];
	
	// TODO: Здесь возможно утечка, нужно подумать где сделать релеазе для pdVC
	[self.navigationController pushViewController:[pdVC retain] animated:YES];
	
	[pdVC release];
	
	
}




// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

- (void)viewDidLoad {
    
	[super viewDidLoad];
	
	self.title = @"Публикации";
	
	
	self.publicTypes = [Communicator sharedCommunicator].publicTypes;  
	
}

- (void) viewWillAppear:(BOOL)animated{
	
	
  [self.navigationController setNavigationBarHidden:YES];	
  lsReaderAppDelegate *appDeligate;
 
  appDeligate = (lsReaderAppDelegate *) [[UIApplication sharedApplication] delegate];
  [appDeligate.navigationController setNavigationBarHidden:NO];
	
 
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
    [self.publicTypes release];
	[super dealloc];
	
}


@end
