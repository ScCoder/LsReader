//
//  TopicViewController.m
//  lsReader
//
//  Created by Usov Sergei on 26.09.11.
//  Copyright 2011 LiveStreet Developers Team. All rights reserved.
//

#import "TopicViewController.h"
#import "commentsViewController.h"
#import "Consts.h"

@implementation TopicViewController

@synthesize webView;
@synthesize topicId;
@synthesize voteBar;
@synthesize voteSegControl;
@synthesize ratingLabel;
@synthesize comentsBtn;
@synthesize voteBtn;
@synthesize autorLabel;


@synthesize photosetView;
@synthesize photosetMainImage;
@synthesize photosetScrollView;
@synthesize photosetImageTitle;


@synthesize linkView;
@synthesize linkBtn;
@synthesize linkDescription;
@synthesize linkTitle;
@synthesize linkURL;

//@synthesize activityIndicator;



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
	
	topic_data = [[NSMutableDictionary alloc] initWithCapacity:1];
	
	[topic_data addEntriesFromDictionary:[SharedCommunicator readTopicById:self.topicId]];
}


- (void) costomizeView {
	
	
	
 // [self.voteBar setHidden:NO];
	
  [self.voteBtn setEnabled:[SharedCommunicator isLogedIn]];
	
	[self.webView setHidden:YES];
	[self.photosetView setHidden:YES];
	[self.linkView setHidden:YES];
	
	
	if ( [((NSString*)[topic_data objectForKey: @"topic_type"]) isEqualToString: @"photoset" ]   ){
	
		[self.photosetView setHidden:NO];
		
		[self.photosetView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.webView.frame.size.height)];
		[self.photosetMainImage setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.webView.frame.size.height - 100)];
		[self.photosetImageTitle setFrame:CGRectMake(0, self.webView.frame.size.height - 100, self.view.frame.size.width, 50)];
		
		[self.photosetScrollView setFrame:CGRectMake(0, self.webView.frame.size.height - 50, self.view.frame.size.width, 50)];
 
											
		
		
	} else if ([((NSString*)[topic_data objectForKey: @"topic_type"]) isEqualToString: @"link" ]  ) {
	
		[self.linkView setHidden:NO];
		
		[self.linkView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.webView.frame.size.height)];
		
	}
	else {
		
		[self.webView setHidden:NO];
		
		[self.webView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.webView.frame.size.height)];
	}

	
	
}
-(void) viewWillAppear:(BOOL)animated{
	
	
	NSMutableString *topicContent = [[NSMutableString alloc] initWithCapacity:10];
	
	[topicContent  appendString: [topic_data objectForKey: @"topic_text" ]];
	

	[self.ratingLabel setTitle:[NSString stringWithFormat:@"%@",[topic_data objectForKey: @"topic_rating" ]]];
	
	[self.comentsBtn setTitle:[NSString stringWithFormat:@"%@ коментариев", [topic_data objectForKey: @"topic_count_comment" ]]];
	
	if ([[topic_data objectForKey: @"topic_count_comment" ] isEqualToString: @"0"]) {
	
		[self.comentsBtn setEnabled:NO];
		
	}
	
	
	[self.autorLabel setTitle:[(NSDictionary *)[topic_data objectForKey: @"user"] objectForKey:@"user_login"]];
		
	
	if (SharedCommunicator.showPics) {
	
		//когда буду кешироватся нужно раскоментировать
		//[self changeImageNamesToCashed:topicContent];
	 	
	} else {
		
		[self cutImagesFromText:topicContent];
		
	}

	photosetImages = [[NSMutableArray alloc] initWithCapacity:5];
	
	if ( [((NSString*)[topic_data objectForKey: @"topic_type"]) isEqualToString: @"photoset" ]   ){
				
		
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
	else if ([((NSString*)[topic_data objectForKey: @"topic_type"]) isEqualToString: @"link" ] ) {
	
		
		self.linkTitle.text = [topic_data objectForKey: @"topic_title"];
		self.linkDescription.text = [topic_data objectForKey: @"topic_text_short"]; 
		self.linkURL.text = [[topic_data objectForKey: @"topic_extra_array"] objectForKey:@"url"];  
		/*
		NSMutableString *str_url = [NSMutableString stringWithString:[[topic objectForKey: @"topic_extra_array"] objectForKey:@"url" ]];
		
		if ( ![[str_url substringToIndex:3] isEqualToString:@"http"]){
			str_url =  [NSString stringWithFormat:@"http://%@",str_url];
		}
		
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:str_url]];
		*/
		
	}	
	else { //если не подошло то считаем что это просто топик
		
		NSURL *base_url = [NSURL URLWithString: [@"http://www." stringByAppendingString: SharedCommunicator.siteURL ]];	
		
		/* Не удалять!!! Для кешированных картинок
		 
		 NSMutableString *imagePath = [NSMutableString stringWithString: DOCUMENTS];
		 imagePath = [imagePath stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
		 imagePath = [imagePath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
		 
		 
		 
		 NSURL *base_url = [NSURL URLWithString: [NSString stringWithFormat:@"file:/%@//%@//%@//"
		 ,imagePath,LS_READER_DIR,CACHE_IMAGES_DIR]];
		 
		 */	
		[webView loadHTMLString:topicContent baseURL:base_url];
		
	}


	
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
	int val = 0;
	
	// Преобразуем buttonIndex в вал
	switch (val1) { 
		case 1:{ 
			val = 1; 
			break;
		}
		case 2:{
			val = 0; 
			break;
		}
		case 3:{
			val = -1;
			break;
		}
		default: break;
	}

	NSDictionary *response = [[NSDictionary alloc] initWithDictionary:[SharedCommunicator voteByTopicId:self.topicId  value: val] ];

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
				
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка" 
														message:[response objectForKey:@"sMsg"]
													   delegate:self 
											  cancelButtonTitle:@"Ok" 
											  otherButtonTitles:nil]; 
		
		[alert show]; 
		[alert release];
		
				
	} 		
	
	[response release];

}

-(void) cutImagesFromText:(NSMutableString *) intext{
	
	NSError *error = NULL;
	NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern: @"<img[^>]src=\"([^>\"]+)\"[^>]*>"
																			options:NSRegularExpressionCaseInsensitive
																			  error:&error];
	
    [regExp replaceMatchesInString:intext options:0 range:NSMakeRange(0,[intext length]) withTemplate:@"<a href = $1> picture </a>"];

}



-(IBAction) showTopicInfo{

	
	NSDateFormatter *formater = [[NSDateFormatter alloc] init];
	[formater setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
	
	NSDate *date = [formater dateFromString:[topic_data objectForKey: @"topic_date_add"]];
	
	[formater setDateFormat:@"dd.MM.YYYY HH:mm"];
	NSString *strDate = [formater stringFromDate:date]; 
	[formater release];
	
	
	NSString *alert_title = [NSString stringWithFormat:@"Автор %@ \n Дата %@ "
							,[(NSDictionary *)[topic_data objectForKey: @"user"] objectForKey:@"user_login"]
							,strDate//[topic_data objectForKey: @"topic_date_add"] 
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
	
	commentsViewController *commentVC = [[commentsViewController alloc] initWithNibName:@"commentsViewController" bundle:nil];
	
		
	commentVC.topicId = self.topicId;
	
	NSNumber *nextLevel = [NSNumber numberWithInt: 0];
		
	NSLog(@"topic_text = %@",[topic_data objectForKey: @"topic_text" ]);
	
	commentVC.headerTextString =  [topic_data objectForKey: @"topic_text" ];
	
	
	commentVC.level = nextLevel;
	
	[commentVC setCommentLevel:nextLevel ];//= nextLevel;
	
	[self.navigationController pushViewController:commentVC animated:YES];
	
	[commentVC release];
	
}

-(IBAction) bookmarkTopic{
	
	NSString *alert_title = @"Заглушка здесь будет добавление в закладки";
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alert_title 
													message:nil
												   delegate:self 
										  cancelButtonTitle:@"Ok"
										  otherButtonTitles:nil]; 
	
	[alert show]; 
	[alert release];
	
	
};

-(void) changeImageNamesToCashed:(NSMutableString*) topicContent {
	
	// когда картинки кешируются(сохраняются в каталог) то потм это метод заменяет все пути на локальные, временно отключено 
	
	NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern: @"<img[^>]src=\"([^>\"]+)\"[^>]*>"
																			options:NSRegularExpressionCaseInsensitive
																			  error:NULL];
	
	for (NSTextCheckingResult *match in [regExp matchesInString:topicContent options:0 range:NSMakeRange(0,[topicContent length])]){
		
		NSString* url = [topicContent substringWithRange:[match rangeAtIndex:1]]; 
				
		NSString *imgFileExt;
		
		if ([url rangeOfString:@".png"].location > 0){
			
			imgFileExt = @"png";
			
		} else if ([url rangeOfString:@".jpg"].location > 0) {
			
			imgFileExt = @"jpg";
	
		}else {
			NSLog(@"Error Unsupprted image file format, file url = %@",url );
			return;
		}
		
        NSString *cacheImageFileName = [NSString stringWithFormat:@"img_%d.%@",[url hash],imgFileExt];
				
		[topicContent replaceOccurrencesOfString:url withString: cacheImageFileName options:NSLiteralSearch range:NSMakeRange(0, [topicContent length])];
		
	}
	
}


-(IBAction) photosetImageTouched:(id) sender{
	
    //[self fadeView: self.mainImage fadeOut:YES];
	

	
	UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[photosetImages objectAtIndex:((UIButton *)sender).tag]]]];
	
	[self.photosetMainImage setImage:image];
	
	[image release];
	
	
	//[self fadeView: self.mainImage fadeOut:NO];
}

-(IBAction) linkBtnTouched:(id) sender{

	

	
	
	
	NSMutableString *str_url = [NSMutableString stringWithString:linkURL.text];
	
	if ( ![[str_url substringToIndex:3] isEqualToString:@"http"]){
		str_url =  [NSString stringWithFormat:@"http://%@",str_url];
	}
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:str_url]];

	
	
	

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
	self.webView = nil;
	self.voteBar = nil;
	self.voteSegControl = nil;
	self.ratingLabel = nil;
	self.comentsBtn = nil;
	self.voteBtn = nil;
	self.autorLabel = nil;
	
	self.photosetView = nil;
	self.photosetMainImage = nil;
	self.photosetScrollView = nil;
	self.photosetImageTitle = nil;

	
	self.linkView = nil;
	self.linkBtn = nil;
	self.linkDescription = nil;
	self.linkTitle = nil;
	self.linkURL = nil;
	
//	self.activityIndicator = nil;

	
}


- (void)dealloc {
	[topic_data release];
	[photosetImages release];
	//[voteSegControl release];
	//[webView release];

    [super dealloc];
}


@end
