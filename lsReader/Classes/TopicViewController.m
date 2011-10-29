//
//  TopicViewController.m
//  lsReader
//
//  Created by Usov Sergei on 26.09.11.
//  Copyright 2011 LiveStreet Developers Team. All rights reserved.
//

#import "TopicViewController.h"


@implementation TopicViewController

@synthesize webView;
@synthesize topicId;
@synthesize voteBar;
@synthesize voteSegControl;
@synthesize ratingLabel;
@synthesize comentsBtn;
@synthesize voteBtn;
@synthesize autorLabel;

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
	
}


- (void) costomizeView {
	
  [self.voteBar setHidden:NO];
	
  [self.voteBtn setEnabled:[[Communicator sharedCommunicator] isLogedIn]];

	
  /*	
	
  if ([[Communicator sharedCommunicator] isLogedIn]) {
	
		[self.voteBtn setEnabled:YES];
		
	
	//  webView.frame = CGRectMake(webView.frame.origin.x
	//								 ,webView.frame.origin.y
	//								 ,webView.frame.size.width
	//								 ,self.view.frame.size.height - voteBar.frame.size.height);
	 
	 }
	 else{
		 [self.voteBtn setEnabled:NO];
		 webView.frame = CGRectMake(webView.frame.origin.x
									 ,webView.frame.origin.y
									 ,webView.frame.size.width
									 ,self.view.frame.size.height);
		 
	 }
*/
	
}
-(void) viewWillAppear:(BOOL)animated{

	topic_data = [[Communicator sharedCommunicator] readTopicById:self.topicId];
		
	//OLD   NSString *topicContent =	[topic_data objectForKey: @"topic_text" ];
	
	
	
	NSMutableString *topicContent = [[NSMutableString alloc] initWithCapacity:10];
	
	[topicContent  appendString: [topic_data objectForKey: @"topic_text" ]];
	

	[self.ratingLabel setTitle:[NSString stringWithFormat:@"%@",[topic_data objectForKey: @"topic_rating" ]]];
	
	[self.comentsBtn setTitle:[NSString stringWithFormat:@"%@ коментариев", [topic_data objectForKey: @"topic_count_comment" ]]];
	
	
	[self.autorLabel setTitle:[(NSDictionary *)[topic_data objectForKey: @"user"] objectForKey:@"user_login"]];
		
	if (![Communicator sharedCommunicator].showPics) {
	
	  //Обрезать картинки
		[self cutImagesFromText:topicContent];
		
	}
	
	
	NSURL *base_url = [NSURL URLWithString: [@"http://www." stringByAppendingString: [Communicator sharedCommunicator].siteURL ]];	
		
	[webView loadHTMLString:topicContent baseURL:base_url];//

	[topicContent release];
	
	
	[self costomizeView];

    	
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
	

	if (navigationType != UIWebViewNavigationTypeLinkClicked) {
	
		return YES;
	}
    else {

		// Запуск сафари
		[[UIApplication sharedApplication] openURL:request.URL ];
	
	return NO;
	}
	
	 
	
	
	
}



-(IBAction) votingForTopic:(id) sender{
 
	NSLog( @" %i",[(UIBarButtonItem *)sender tag] );
	
	//NSString *newRating = [[Communicator sharedCommunicator] voteByTopicId:self.topicId 
	//																 value:[(UIBarButtonItem *)sender tag]
	//					   ];
	
	//NSLog(@"new Rating = %@",newRating);
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Голосование за топик" 
													message:@"Понравился топик?" 
												   delegate:self 
										  cancelButtonTitle:@"Отмена" 
										  otherButtonTitles:@"Хорошо",@"Средне",@"Плохо",nil]; 
	
	[alert show]; 
	[alert release];
	
		
}

-(void) alertView: (UIAlertView *) alertView clickedButtonAtIndex: (NSInteger *) buttonIndex 
{	
	
	if (buttonIndex==0) {
		return;
	}
	
	int val1 = buttonIndex;
	int val;
	
	// Преобразуем buttonIndex в вал
	switch (val1) {
		case 1:
			val = 1;
			break;
		case 2:
			val = 0;
			break;
		case 3:
			val = -1;
			break;
		default:
			break;
	}

	
	NSDictionary *response = [[Communicator sharedCommunicator] voteByTopicId:self.topicId  value: val];
		

	// Сообщаем что голос принят если все ок
	
	if ([response objectForKey:@"rating"]){
		
		NSString *msg = [NSString stringWithFormat:@"Новый рейтинг = %@",[response objectForKey:@"rating"]];
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Голос принят!" 
														message:msg
													   delegate:self 
											  cancelButtonTitle:@"Ok" 
											  otherButtonTitles:nil]; 
		
		[alert show]; 
		[alert release];
		
		[self.ratingLabel setTitle:[response objectForKey:@"rating"]];
		
	}
	
	
	// Вывод ошибки если была
	
	if ([response objectForKey:@"bStateError"]) {
		
		NSString *msg = [NSString stringWithFormat:@"Новый рейтинг = %@",[response objectForKey:@"rating"]];
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка" 
														message:[response objectForKey:@"sMsg"]
													   delegate:self 
											  cancelButtonTitle:@"Ok" 
											  otherButtonTitles:nil]; 
		
		[alert show]; 
		[alert release];
		
				
	} 		
	
	
	
	

}

-(void) cutImagesFromText:(NSMutableString *) intext{
	
	NSError *error = NULL;
	NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern: @"<img[^>]src=\"([^>\"]+)\"[^>]*>"
																			options:NSRegularExpressionCaseInsensitive
																			  error:&error];
	
    [regExp replaceMatchesInString:intext options:0 range:NSMakeRange(0,[intext length]) withTemplate:@"<a href = $1> picture </a>"];

}



-(IBAction) showTopicInfo{

	NSString *alert_title = [NSString stringWithFormat:@"Автор %@ \n дата публикации %@ "
							,[(NSDictionary *)[topic_data objectForKey: @"user"] objectForKey:@"user_login"]
							,[topic_data objectForKey: @"topic_date_add"] 
							];
							
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alert_title 
													message:nil
												   delegate:self 
										  cancelButtonTitle:@"Ok"
										  otherButtonTitles:nil]; 
	
	[alert show]; 
	[alert release];
	//[alert_title release];
	
	
}

-(IBAction) showRating{
	
	NSString *alert_title = [NSString stringWithFormat:@"Рейтинг %@ \n проголосовало %@ \n прочитали %@"
							,[topic_data objectForKey: @"topic_rating"] 
							,[topic_data objectForKey: @"topic_count_vote"]
							,[topic_data objectForKey: @"topic_count_read"] 
							];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alert_title 
													message:nil
												   delegate:self 
										  cancelButtonTitle:@"Ok"
										  otherButtonTitles:nil]; 
	
	[alert show]; 
	[alert release];


}

-(IBAction) showComents{
	NSString *alert_title = @"Заглушка сдесь должен быть метод показа топиков";
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alert_title 
													message:nil
												   delegate:self 
										  cancelButtonTitle:@"Ok"
										  otherButtonTitles:nil]; 
	
	[alert show]; 
	[alert release];
	

}

-(IBAction) bookmarkTopic{
	NSString *alert_title = @"Заглушка сдесь будет добавление в закладки";
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alert_title 
													message:nil
												   delegate:self 
										  cancelButtonTitle:@"Ok"
										  otherButtonTitles:nil]; 
	
	[alert show]; 
	[alert release];
	
	
};

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
	[voteSegControl release];
	[webView release];
    [super dealloc];
}


@end
