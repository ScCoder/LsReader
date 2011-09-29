//
//  PublicationViewController.m
//  lsReader_001
//
//  Created by Сергей Усов on 28.08.11.
//  Copyright 2011 Стройкомплект. All rights reserved.
//

#import "PublicationViewController.h"
#import "JSONKit.h"
#import "PublicationDetailViewController.h"


@implementation PublicationViewController

@synthesize testLabel;
@synthesize myTable;
@synthesize publicTypes;
@synthesize activityIndicator;
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
	
	UIImage *image = [UIImage imageNamed:@"checkmarkControllerIcon.png"];
	
	cell.textLabel.text = [self.publicTypes objectAtIndex:indexPath.row];
	
	
    cell.imageView.image = image;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	
	return cell;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	// TODO Зделать что бы выбиралось в зависимости от publicTypes
	
	PublicationDetailViewController *pdVC = [[PublicationDetailViewController alloc] initWithNibName:@"PublicationDetailViewController" bundle:nil];
	
	pdVC.publication_type = [self.publicTypes objectAtIndex:indexPath.row];
	
	[self.navigationController pushViewController:pdVC animated:YES];
	
	[pdVC release];
	
	
}


-(IBAction) testJSON{
	/*	
	NSLog(@"log: ");
	
	NSString *api_command = [NSString stringWithFormat:@"http://new.livestreet.ru/api/topic/read/?id=8149&response_type=json"];
	
	NSURL *url = [NSURL URLWithString:api_command];
	
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	
	NSData *tmpContainer = [NSURLConnection sendSynchronousRequest:request 
												 returningResponse:nil 
															 error:nil];
	
	JSONDecoder *decoder = [JSONDecoder decoder];
	
	NSDictionary *params = [decoder parseJSONData:tmpContainer];
	
	NSLog(@"test data %@",params);
	
	NSLog(@"topic_text = %@",[[params objectForKey:@"response"] objectForKey:@"topic_text"]);
	
	testLabel.text = [[params objectForKey:@"response"] objectForKey:@"topic_text"];
	
*/
		
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	NSLog(@" viewDidLoad: ");	
	self.title = @"Публикации";
	
	self.publicTypes = [NSArray arrayWithObjects:@"Лучшие", @"Новые", @"Коллективные", @"Персональные",@"Лента",@"Активность",nil];
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