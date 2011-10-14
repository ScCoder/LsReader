//
//  PublicationDetailViewController.m
//  lsReader
//
//  Created by Usov Sergei on 25.09.11.
//  Copyright 2011 LiveStreet Developers Team. All rights reserved.
//

#import "TopicViewController.h"
#import "PublicationDetailViewController.h"
#import "lsReaderAppDelegate.h"


@implementation PublicationDetailViewController

@synthesize myTable;
@synthesize keys;
@synthesize topics_collection;
@synthesize publication_type;

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
	current_page = 0;
	current_page++;
	
	NSLog(@"pub detail");
//	NSLog(self.publication_type);
	
	// Получение данных
	
	NSDictionary *response = [NSDictionary dictionaryWithObjectsAndKeys:nil] ;
	
	if ([self.publication_type isEqualToString: @"Лучшие"]) {
	
		response = [[Communicator sharedCommunicator] topPublicationsByPeriod:@"all"];
	
	}
	else if ( [self.publication_type isEqualToString: @"Новые"]){
	 
		response = [[Communicator sharedCommunicator] newPublications];
		
	}
	else if ( [self.publication_type isEqualToString: @"Персональные"]){
		
	    response = [[Communicator sharedCommunicator] personalPublications:@"good" page:current_page];
	}
	else {
		NSLog(@"other");
	}

	
	NSLog(@"response = ");
	NSLog(@" %@",response);
		
    if (response == nil) { NSLog(@"nIIIL");  }; 
	
	self.topics_collection = [[NSMutableDictionary alloc] initWithCapacity:1];
		
	[self.topics_collection addEntriesFromDictionary: [response objectForKey:@"collection"]];	
	
	//self.topics_collection = [response objectForKey:@"collection"];
	
	self.keys = [NSMutableArray arrayWithArray: [topics_collection allKeys]];	
	
//	self.keys = [self.topics_collection allKeys];
	
}

-(void)viewWillAppear:(BOOL)animated{
	
	//Смена видимости контроллеров навгации
	
	lsReaderAppDelegate *appDeligate;
	
	appDeligate = (lsReaderAppDelegate *) [[UIApplication sharedApplication] delegate];
	
	[appDeligate.navigationController setNavigationBarHidden:YES];
		
	[self.navigationController setNavigationBarHidden: NO];

}



// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [keys count];
	
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
	
	
	
	
	NSDictionary *topic = [self.topics_collection objectForKey: [self.keys objectAtIndex:indexPath.row]];
		
	cell.textLabel.text = [topic objectForKey: @"topic_title"] ;
	cell.detailTextLabel.text = [topic objectForKey:@"topic_text_short"];
	
	
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	
	return cell;
	
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	// TODO читать топик
	
	NSLog(@"read topic");
	
	TopicViewController *topicVC = [[TopicViewController alloc] initWithNibName:@"TopicViewController" bundle:nil];
	
	
	NSDictionary *topic = [self.topics_collection objectForKey: [self.keys objectAtIndex:indexPath.row]];

    NSString *topic_id =  [topic objectForKey:@"topic_id"];

	//NSDictionary *topic_data = [[Communicator sharedCommunicator] readTopicById:topic_id];

	//NSLog(@"topic = %@",topic_data)	;
	
	//topicVC.topicContent =	[topic_data objectForKey: @"topic_text" ];
	topicVC.topicId = topic_id;
	
	[self.navigationController pushViewController:topicVC animated:YES];
	
	
	[topicVC release];
	
	
}

-(IBAction) addNext{

	
	current_page++;
	
	NSDictionary *response;

	response = [[Communicator sharedCommunicator] personalPublications:@"good" page:current_page];
	
	
	[self.topics_collection addEntriesFromDictionary: [response objectForKey:@"collection"]];
	

	
    self.keys = [NSMutableArray arrayWithArray: [topics_collection allKeys]];	
	
	[self.myTable reloadData];	
	
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
	
	[self.topics_collection release];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
