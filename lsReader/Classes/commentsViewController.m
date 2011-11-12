//
//  commentsViewController.m
//  lsReader
//
//  Created by Сергей Усов on 30.10.11.
//  Copyright 2011 LiveStreet Developers Team. All rights reserved.
//

#import "commentsViewController.h"


@implementation commentsViewController

@synthesize topicId;
@synthesize keys;
@synthesize commentsCollection;
@synthesize commentParentId;
@synthesize commentLevel;
@synthesize level;
#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	
	
	NSDictionary *response = [NSDictionary dictionaryWithObjectsAndKeys:nil] ;
	response = [[Communicator sharedCommunicator] commentsByTopicId:self.topicId];
	//NSLog(@"%@",response);
	
	self.commentsCollection = [[NSDictionary alloc] initWithDictionary:[response objectForKey:@"collection"]];
	
	
	//NSLog (@"cl = %d",[[self.commentsCollection objectForKey:[self.keys objectAtIndex: 1]] objectForKey:@"commnet_level" ]);
	
	NSSet *mySet = [self.commentsCollection keysOfEntriesPassingTest:^(id key, id obj, BOOL *stop) {
		
		//Если нулевой левел, то просто выбираем с уровнем ноль
		// иначе сортируем по парент_ид
		if ([self.commentLevel isEqualToNumber: [NSNumber numberWithInt: 0]]) {
			
		    if ([[obj objectForKey:@"comment_level"]  isEqualToNumber:self.commentLevel ]) 
			{
				return YES;
			}
		    else
			{
				return NO;
			}
						
		}
		else 
		{
			if ([obj objectForKey:@"comment_pid"] == (id)[NSNull null])
			{
				return NO;

			}
			else 
			{
				NSLog(@"pid = %@",[obj objectForKey:@"comment_pid"]);
				if ([[obj objectForKey:@"comment_pid"] isEqualToString: self.commentParentId ]) {
					return YES;
				}
				else {
					return NO;
				}
			}
			
			
		}
	}	];
					
	//NSLog(@"myset = %d",[mySet count]);	
	
	self.keys = [mySet allObjects]; 
	
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

/*

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	 
	
	
}
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [self.keys count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{


	return @"footer";
}

- (NSString *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
	

	NSDictionary *comment = [self.commentsCollection objectForKey:[self.keys objectAtIndex:section]];
	
	UIView *footerView = [[UIView alloc] init];


	footerView.frame = CGRectMake(0.0, 0.0,	self.tableView.frame.size.width , 15);
	
	UILabel *lbAutor = [[UILabel alloc] init];
	//lbAutor.text = @"sc_coder";
	
	lbAutor.text = [[comment objectForKey: @"user"] objectForKey:@"user_login"];

	[lbAutor setBackgroundColor:[UIColor clearColor]];
	lbAutor.font = [UIFont fontWithName:@"Arial"size:12];
	lbAutor.textColor = [UIColor blueColor];
	
	
	
	lbAutor.frame = CGRectMake(20, 3, 70, 15);

	
	
	UILabel *lbTime = [[UILabel alloc] init];
	
	
	
	//форматирование даты
	
	NSDateFormatter *formater = [[NSDateFormatter alloc] init];
	[formater setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
	NSDate *date = [formater dateFromString:[comment objectForKey: @"comment_date"]];
	
	[formater setDateFormat:@"HH:mm"];
	//NSString *strDate = [formater stringFromDate:date]; 
	
	
	lbTime.text = [formater stringFromDate:date]; //[topic objectForKey: @"topic_date_add"];
	[formater release];
	
	
	

	
	
	
	[lbTime setBackgroundColor:[UIColor clearColor]];
	lbTime.font = [UIFont fontWithName:@"Arial"size:12];
	lbTime.textColor = [UIColor grayColor];
	
	lbTime.frame = CGRectMake(self.tableView.frame.size.width-50, 3, 50, 15);
	
	
	[footerView insertSubview:lbAutor atIndex: 0];
	[footerView insertSubview:lbTime atIndex: 1];
					  
	return footerView;
	
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
	
	
	return 25;

}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ControlRowIdentifier = @"ControlRowIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ControlRowIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
									   reuseIdentifier:ControlRowIdentifier] autorelease];
    }
    
    NSNumber *nextLevel = [NSNumber numberWithInt: [self.commentLevel intValue] + 1];
	
	//NSNumber *comment_pid = [NSNumber numberWithInt:
							 
	//						 : [self.keys objectAtIndex:indexPath.section]] ;
	
	NSSet *mySet = [self.commentsCollection keysOfEntriesPassingTest:^(id key, id obj, BOOL *stop) {
		
		if ( ([[obj objectForKey:@"comment_level"]  isEqualToNumber: nextLevel])
			&& ([[obj objectForKey:@"comment_pid"] isEqualToString:[self.keys objectAtIndex:indexPath.section]])  )
			return YES;
		else
		    return NO;
	}	];
	
    // Configure the cell...
    NSString *childCount = [NSString stringWithFormat:@"%d",[mySet count]];
 
	
	UIImage *image = [UIImage imageNamed:@"180-stickynote.png"];
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
	
	[button setBackgroundImage:image forState:UIControlStateNormal];
	[button setTitle: childCount forState:UIControlStateNormal];
	[button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
	cell.accessoryView = button;
	
	cell.lineBreakMode = UILineBreakModeWordWrap;

	
	cell.font = [UIFont fontWithName:@"Arial"size:12];
	cell.textLabel.text = [[self.commentsCollection objectForKey:[self.keys objectAtIndex:indexPath.section]] objectForKey:@"comment_text"];
	//@"textLabel.text";
	
	
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


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
	
	
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
	
	
	commentsViewController *commentVC = [[commentsViewController alloc] initWithNibName:@"commentsViewController" bundle:nil];
	
	
	commentVC.topicId = self.topicId;
	
	NSNumber *nextLevel = [NSNumber numberWithInt: [self.commentLevel intValue] + 1];
	
	commentVC.commentLevel = nextLevel;
	commentVC.commentParentId = [self.keys objectAtIndex:indexPath.section];
	
	[self.navigationController pushViewController:commentVC animated:YES];
	
	[commentVC release];
	
	
	
	
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {

	[self.commentsCollection release];
	[self.keys release];
	self.commentsCollection = nil;
	self.keys = nil;
    
	// Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

