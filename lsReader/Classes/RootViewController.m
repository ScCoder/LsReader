//
//  RootViewController.m
//  lsReader_002
//
//  Created by Сергей Усов on 01.09.11.
//  Copyright 2011 Стройкомплект. All rights reserved.
//

#import "RootViewController.h"
#import "SiteParamsViewController.h"
#import "JSONKit.h"

@implementation RootViewController


@synthesize sites;
@synthesize tabBarController;
@synthesize siteParams;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    
	[super viewDidLoad];
	
	self.title = @"Ваши сайты";
	

	// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(void) viewWillAppear:(BOOL)animated{
	
	self.siteParams = [NSMutableDictionary dictionaryWithContentsOfFile:@"settings.txt"];
	
    self.tableView.allowsSelectionDuringEditing = YES;
	
	[self.tableView reloadData];
	
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.siteParams count];

}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
	UIImage *image = [UIImage imageNamed:@"rightArrow.png"];
	
	
	
	NSArray *tmpSiteNames = [self.siteParams allKeys];

	cell.textLabel.text = [tmpSiteNames objectAtIndex: indexPath.row];
	
	cell.detailTextLabel.text = [[siteParams objectForKey:cell.textLabel.text] objectForKey:@"url"];

    cell.imageView.image = image;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    return cell;
	//
	[tmpSiteNames release];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
		
		
		NSArray *keys = [self.siteParams allKeys] ;
		
		
		[self.siteParams removeObjectForKey: [keys objectAtIndex:indexPath.row]]; 
		
	
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];

    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}



/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   	
	NSArray *keys = [self.siteParams allKeys] ;
	
	
	if (self.tableView.editing){
		
		// В режиме редактирования вызываем форму настроек сайта
	
		SiteParamsViewController *siteParamsVC = [[SiteParamsViewController alloc] initWithNibName:@"SiteParamsViewController" bundle:nil];
		
		siteParamsVC.key = [keys objectAtIndex:indexPath.row];
		
		siteParamsVC.siteParams = self.siteParams;
				
		[self.navigationController pushViewController:siteParamsVC animated:YES];
				
		//self.siteParams = siteParamsVC.siteParams;
		
		[siteParamsVC release];
	
	}
	else {
		
		// Обычный режим - Перекючение на TabViewController
		
				
		if (self.tabBarController == nil){
			UITabBarController *tabBar = [[UITabBarController alloc] 
									  initWithNibName:@"RootViewController" bundle:[NSBundle mainBundle]];
			self.tabBarController = tabBar;				
		[	tabBar release];
		
		}
		
		//Запоминаем урл выбранного сайта в коммуникаторе
		
		[Communicator sharedCommunicator].siteURL = [[self.siteParams objectForKey:[keys objectAtIndex:indexPath.row]] objectForKey:@"url"];
	
		//Переход к основному виду
		[self.navigationController pushViewController:self.tabBarController animated: YES ];
	}
//	[self.tableView reloadData];
	
}

-(IBAction) editParams{
	
		
	[self.tableView setEditing:!self.tableView.editing animated:YES];
	
	if (self.tableView.editing){
		[self.navigationItem.rightBarButtonItem setTitle:@"Done"];
	}
	else {
		[self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
		[self.siteParams writeToFile:@"settings.txt" atomically:YES]; 
	}
	
}

-(IBAction) addSite{

	SiteParamsViewController *siteParamsVC = [[SiteParamsViewController alloc] 
											  initWithNibName:@"SiteParamsViewController" 
											  bundle:nil];
	
	siteParamsVC.key = @"new";
	
	siteParamsVC.siteParams = self.siteParams;
	
	[self.navigationController pushViewController:siteParamsVC animated:YES];

	self.siteParams = siteParamsVC.siteParams;
	
	[siteParamsVC release];
	 
	
}



#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	self.sites = nil;
	self.tabBarController = nil;
}


- (void)dealloc {
	[tabBarController release];
	[sites release];
    [super dealloc];
}


@end

