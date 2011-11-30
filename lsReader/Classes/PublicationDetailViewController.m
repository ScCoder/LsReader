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
#import "Consts.h"
#import "PubDetailCell.h"

@implementation PublicationDetailViewController



@synthesize myTable;
@synthesize publication_type;
@synthesize addNextButton;
@synthesize topPeriodSegControl;
@synthesize topPeriodToolBar;

@synthesize showTypeSegControl;	
@synthesize showTypeToolBar;

@synthesize activityIndicator;


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
	
	self.title = self.publication_type;
	
	current_page = 1;

	topics_collection = [[NSMutableDictionary alloc] initWithCapacity:10];	
	
	[self.activityIndicator  setHidden:NO];
	
	keys = [[NSMutableArray alloc] initWithCapacity:10];
	
	[self loadTopicsList];
	
	[self.activityIndicator setHidden:YES];
	
	
	
	
}

-(void) costomizeView {
	// настройка интерфейса
	
	[addNextButton setHidden:NO]; 
	[topPeriodToolBar setHidden:YES];
	[showTypeToolBar setHidden:YES];
	
	self.myTable.frame = CGRectMake(self.myTable.frame.origin.x
									, self.topPeriodToolBar.frame.origin.y
									,self.myTable.frame.size.width
									,self.view.frame.size.height); 
	
	
	if ([self.publication_type isEqualToString: PT_TOP]) {
		
		[addNextButton setHidden:YES];
		[topPeriodToolBar setHidden:NO];
		
		self.myTable.frame = CGRectMake(self.myTable.frame.origin.x
										,self.topPeriodToolBar.frame.origin.y + self.topPeriodToolBar.frame.size.height
										,self.myTable.frame.size.width
										,self.view.frame.size.height - self.topPeriodToolBar.frame.size.height);
		
		
	}
	else if ( [self.publication_type isEqualToString: PT_NEW]){
		
				
	}
	else if ( [self.publication_type isEqualToString: PT_PERSONAL]){
		
		[showTypeToolBar setHidden:NO];
		self.showTypeToolBar.frame = topPeriodToolBar.frame;
		
		self.myTable.frame = CGRectMake(self.myTable.frame.origin.x
										,self.topPeriodToolBar.frame.origin.y + self.topPeriodToolBar.frame.size.height
										,self.myTable.frame.size.width
										,self.view.frame.size.height - self.topPeriodToolBar.frame.size.height);
		
		
				
		
	}
	else {
		NSLog(@"other");
	}
	
	

	
}

-(IBAction)loadTopicsList{

    // Получение данных
	

	
	if ([self.publication_type isEqualToString: PT_TOP]) {
			
		NSString *period = [ SharedCommunicator.publicationPeriods objectAtIndex: topPeriodSegControl.selectedSegmentIndex];
	
		receivedData = [SharedCommunicator topPublicationsByPeriod:period];
	
	}
	else if ( [self.publication_type isEqualToString: PT_NEW]){
		
		receivedData = [SharedCommunicator newPublications];
		
		
	}
	else if ( [self.publication_type isEqualToString: PT_PERSONAL]){
		
		
		NSString *showType = [SharedCommunicator.publicationShowType objectAtIndex: showTypeSegControl.selectedSegmentIndex];
		
	    receivedData = [SharedCommunicator personalPublications:showType page: current_page];
		
	}
	
	else {
		NSLog(@"other");
	}
	
	
	[keys removeAllObjects];
	
	if (receivedData) {
	
	  [topics_collection addEntriesFromDictionary: [receivedData objectForKey:@"collection"] ];	
	
	  [keys addObjectsFromArray:[topics_collection allKeys]]; 
	
	  [keys sortUsingSelector:@selector(compare:) ];	
	
	  [[keys reverseObjectEnumerator] allObjects];
	}
	
	[self.myTable reloadData];
	
	
receivedData = nil;
		
}

-(void)viewWillAppear:(BOOL)animated{

	//Смена видимости контроллеров навгации
	
	lsReaderAppDelegate *appDeligate;
	
	appDeligate = (lsReaderAppDelegate *) [[UIApplication sharedApplication] delegate];
	
	[appDeligate.navigationController setNavigationBarHidden:YES];
		
	[self.navigationController setNavigationBarHidden: NO];
	
	[self costomizeView];

}



// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [keys count];
	
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	return PUB_DETAIL_CELL_HEIGHT;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	
	static NSString *CellIdentifier = @"CustomCell";
	PubDetailCell *cell = (PubDetailCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		NSArray *outlets = [[NSBundle mainBundle] loadNibNamed:@"PubDetailCell" owner:self options:nil];
		for (id currentObject in outlets) {
			if ([currentObject isKindOfClass:[UITableViewCell class]]){
				cell =  (PubDetailCell *) currentObject;
				break;
			}
		}
	}
	
		
	NSMutableDictionary *topic = [topics_collection objectForKey: [keys objectAtIndex:indexPath.row]];
		
	cell.topic_title.text = [topic objectForKey: @"topic_title"] ;
	    
	cell.blog_title.text = [[topic objectForKey:@"blog"] objectForKey:@"blog_title"];
	
	cell.topic_author.text =  [[topic objectForKey:@"user"] objectForKey:@"user_login"];  
	
	
	NSString *str = [NSString stringWithString: [topic objectForKey: @"topic_text_short"]];
	
	cell.topic_description.text = [SharedCommunicator cutHtmlTagsFromString:str];
	
	
	//форматирование даты
	
	NSDateFormatter *formater = [[NSDateFormatter alloc] init];
	
	[formater setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
	
	NSDate *date = [formater dateFromString:[topic objectForKey: @"topic_date_add"]];
	
	[formater setDateFormat:@"dd.MM.YYYY HH:mm"];
			
	cell.topic_date.text = [formater stringFromDate:date];
	
	[formater release];
	

	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	
	return cell;
	
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	NSLog(@"read topic");
	
	
	NSDictionary *topic = [topics_collection objectForKey: [keys objectAtIndex:indexPath.row]];
	
		
	TopicViewController *topicVC = [[TopicViewController alloc] initWithNibName:@"TopicViewController" bundle:nil];
			
	NSString *topic_id = [topic objectForKey:@"topic_id"];
	
	topicVC.topicId = topic_id;
	
	[self.navigationController pushViewController:topicVC animated:YES];
		
	[topicVC release];
	
		
	
}

-(IBAction) addNext{
	
	
	current_page++;
	
	[self loadTopicsList];

	[self.myTable scrollsToTop];	
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
	
	self.myTable = nil;
	self.addNextButton = nil;
	self.topPeriodSegControl = nil;
	self.topPeriodToolBar = nil;
	self.showTypeSegControl = nil;	
	self.showTypeToolBar = nil;
	self.activityIndicator = nil;
	self.publication_type = nil;
	
	
	
    [super viewDidUnload];
	

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	
	//[receivedData release];
	[publication_type release];
	[myTable release];
	[addNextButton release];
	[topPeriodSegControl release];
	[topPeriodToolBar release];
	[showTypeSegControl release];
	[showTypeToolBar release];
	[activityIndicator release];
	[publication_type release];
	
	[topics_collection release];
	[keys release];
    [super dealloc];
}


@end
