//
//  SiteParamsViewController.m
//  lsReader
//
//  Created by Usov Sergei on 26.08.11.
//  Copyright 2011 LiveStreet Developers Team. All rights reserved.
//

#import "SiteParamsViewController.h"
#import "JSONKit.h"
#import "lsReaderAppDelegate.h"
#import "Consts.h"

@implementation SiteParamsViewController


@synthesize siteName;
@synthesize siteURL;
@synthesize siteLogin;
@synthesize sitePasswd;
@synthesize key;
@synthesize siteParams;
@synthesize countPerPage;
@synthesize showPics;

@synthesize viewSlider = _viewSlider;

@synthesize applyButton;

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
	
		
	self.viewSlider.hideKeyboardOnReturn = YES;
	self.viewSlider.ySlideDistance = 76.0f;
	
	
	self.title = @"Настройки сайта";
	
	if (self.key != NEW_KEY) {
		siteName.text = key;
	}
	
	siteURL.text = [[siteParams objectForKey:key] objectForKey:SITE_URL];
	siteLogin.text = [[siteParams objectForKey:key] objectForKey:SITE_LOGIN];
	sitePasswd.text = [[siteParams objectForKey:key] objectForKey:SITE_PASSWD];
	countPerPage.text = [[siteParams objectForKey:key] objectForKey:COUNT_PER_PAGE];
	
	showPics.on =  [[[siteParams objectForKey:key] objectForKey:SHOW_PICS] isEqualToString: @"YES"];
	
}



-(IBAction) applyCahges{

	
	if (self.key == NEW_KEY) {
		
		self.key  = siteName.text;
		
	}
	
	// Если изменилось название сайта, то нужно удалить запись с старым ключём чтобы создать новую запись, т.е. обновить ключ
	
	if (self.key != siteName.text){
	
		[self.siteParams removeObjectForKey:self.key];
		
		self.key = siteName.text;
		
	}
	

	//NSLog(@" %@",showPics.on);
	
	NSDictionary *siteVals = [NSDictionary dictionaryWithObjectsAndKeys:
							  siteURL.text,SITE_URL,
							  siteLogin.text,SITE_LOGIN,
							  sitePasswd.text,SITE_PASSWD,
							  countPerPage.text,COUNT_PER_PAGE,
							  showPics.on ? @"YES":@"NO",SHOW_PICS,
							  nil
							  ]; 
	 
	
	if ([self.siteParams count]<= 0) {
		
		self.siteParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:siteVals,self.key ,nil];
		
	}
	else {
		
		[self.siteParams setObject:siteVals forKey:self.key];

	}

	lsReaderAppDelegate *appDeligate = (lsReaderAppDelegate *) [[UIApplication sharedApplication] delegate];	
	
	[self.siteParams writeToFile:appDeligate.settingsFilePath atomically:YES];

	
	[self.navigationController popViewControllerAnimated:YES];
	
	
}

-(IBAction)testConnection{
	
	
	BOOL * connOk = [[Communicator sharedCommunicator] checkConnectionBySite:siteURL.text
													  login:siteLogin.text
												   password:sitePasswd.text];
	
	NSString *msg;
	
	if (connOk) {
		
		msg = @"Соединие установленно успешно!!";
		
	}
	else {
		
		msg = @"Ошибка!!! Проверьте введенные данные...";
		
	}

	
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
													message:msg 
												   delegate:self 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles:nil]; 
	
	[alert show]; 
	[alert release];
	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (IBAction) endEditing:(id) sender {
   [sender resignFirstResponder]; 
}


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
	[self.siteParams release];
	[applyButton release];
	[_viewSlider release];
    [super dealloc];
}


@end
