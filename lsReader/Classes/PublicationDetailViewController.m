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
@synthesize keys;
@synthesize topics_collection;
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

	[self.activityIndicator  setHidden:NO];
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
	
	NSDictionary *response = [NSDictionary dictionaryWithObjectsAndKeys:nil] ;

	if ([self.publication_type isEqualToString: PT_TOP]) {
			
		NSString *period = [ SharedCommunicator.publicationPeriods objectAtIndex: topPeriodSegControl.selectedSegmentIndex];
		
		response = [SharedCommunicator topPublicationsByPeriod:period];
				   
				
	}
	else if ( [self.publication_type isEqualToString: PT_NEW]){
		
		response = [SharedCommunicator newPublications];
		
	}
	else if ( [self.publication_type isEqualToString: PT_PERSONAL]){
		
		
		NSString *showType = [SharedCommunicator.publicationShowType objectAtIndex: showTypeSegControl.selectedSegmentIndex];
		
	    response = [SharedCommunicator personalPublications:showType page: current_page];
		
	}
	else {
		NSLog(@"other");
	}
	
	
	
	self.topics_collection = [[NSMutableDictionary alloc] initWithCapacity:1];
	
	
	[self.topics_collection addEntriesFromDictionary: [response objectForKey:@"collection"]];	
	
	
	self.keys = [NSMutableArray arrayWithArray: [topics_collection allKeys]];	
	
	[self.keys sortUsingSelector:@selector(compare:) ];	
	
	self.keys = [[ self.keys reverseObjectEnumerator] allObjects];
	
	[self.myTable reloadData];
	
	
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
	
		
	NSMutableDictionary *topic = [self.topics_collection objectForKey: [self.keys objectAtIndex:indexPath.row]];
		
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
	
	TopicViewController *topicVC = [[TopicViewController alloc] initWithNibName:@"TopicViewController" bundle:nil];
		
	NSDictionary *topic = [self.topics_collection objectForKey: [self.keys objectAtIndex:indexPath.row]];

    NSString *topic_id =  [topic objectForKey:@"topic_id"];

	topicVC.topicId = topic_id;
	
	[self.navigationController pushViewController:topicVC animated:YES];
		
	[topicVC release];
	
	
}

-(IBAction) addNext{

	//TODO Сделать что бы добавлялись из нужного метода зависит от pubType( персональные, новые и т.п.)
	current_page++;
	
	NSDictionary *response;

	response = [[Communicator sharedCommunicator] personalPublications:@"good" page:current_page];
	
	
	[self.topics_collection addEntriesFromDictionary: [response objectForKey:@"collection"]];
	

	
    self.keys = [NSMutableArray arrayWithArray: [topics_collection allKeys]];	
	
	[self.keys sortUsingSelector:@selector(compare:)];
	
	self.keys = [[ self.keys reverseObjectEnumerator] allObjects];
	
	
	[self.myTable reloadData];	
	
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
	[self.topics_collection release];
	self.topics_collection = nil;	
    [super viewDidUnload];
	

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
