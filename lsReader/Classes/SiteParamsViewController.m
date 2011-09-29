//
//  SiteParamsViewController.m
//  lsReader_001
//
//  Created by Сергей Усов on 26.08.11.
//  Copyright 2011 Стройкомплект. All rights reserved.
//

#import "SiteParamsViewController.h"
#import "JSONKit.h"

@implementation SiteParamsViewController


@synthesize siteName;
@synthesize siteURL;
@synthesize siteLogin;
@synthesize sitePasswd;
@synthesize key;
@synthesize siteParams;

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
	self.viewSlider.ySlideDistance = 70.0f;
	
	
	self.title = @"Настройки сайта";
	
	if (self.key != @"new") {
		siteName.text = key;
	}
	
	siteURL.text = [[siteParams objectForKey:key] objectForKey:@"url"];
	siteLogin.text = [[siteParams objectForKey:key] objectForKey:@"login"];
	sitePasswd.text = [[siteParams objectForKey:key] objectForKey:@"passwd"];
	
	
}



-(IBAction) applyCahges{

	
	if (self.key == @"new") {
		
		self.key  = siteName.text;
		
	}
	
	// Если изменилось название сайта, то нужно удалить запись с старым ключём чтобы создать новую запись, т.е. обновить ключ
	
	if (self.key != siteName.text){
	
		[self.siteParams removeObjectForKey:self.key];
		
		self.key = siteName.text;
		
	}
	

	
	
	NSDictionary *siteVals = [NSDictionary dictionaryWithObjectsAndKeys:
							  siteURL.text,@"url",
							  siteLogin.text,@"login",
							  sitePasswd.text,@"passwd",nil]; 
	 
	
	if ([self.siteParams count]<= 0) {
		
		self.siteParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:siteVals,self.key ,nil];
		
	}
	else {
		[self.siteParams setObject:siteVals forKey:self.key];

	}

	
	
	[self.siteParams writeToFile:@"settings.txt" atomically:YES];

	
	[self.navigationController popViewControllerAnimated:YES];
	
	
}

-(IBAction)testConnection{
	
	
	[[Communicator sharedCommunicator] testConnectionBySite:siteURL.text
													  login:siteLogin.text
												   password:sitePasswd.text];
	
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
