//
//  SiteParamsViewController.h
//  lsReader
//
//  Created by Usov Sergei on 26.08.11.
//  Copyright 2011 LiveStreet Developers Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "S7ViewSlider.h"


@class S7ViewSlider;

@interface SiteParamsViewController : UIViewController {

	UITextField *siteName;
	UITextField *siteURL;
	UITextField *siteLogin;
	UITextField *sitePasswd;
	UITextField *countPerPage;
	
	UISwitch *showPics;
	
	UIButton *applyButton;
	
	
	NSMutableDictionary *siteParams;
	NSString *key;
	
	@private
	S7ViewSlider *_viewSlider;
}
@property (nonatomic, retain) IBOutlet UITextField *siteName;
@property (nonatomic, retain) IBOutlet UITextField *siteURL;
@property (nonatomic, retain) IBOutlet UITextField *siteLogin;
@property (nonatomic, retain) IBOutlet UITextField *sitePasswd;
@property (nonatomic, retain) IBOutlet UITextField *countPerPage;
@property (nonatomic, retain) IBOutlet UISwitch *showPics;
@property (nonatomic, retain) NSString *key;
@property (nonatomic, retain) NSMutableDictionary *siteParams;
@property (nonatomic, retain) IBOutlet S7ViewSlider *viewSlider;
@property (nonatomic, retain) IBOutlet UIButton *applyButton;


-(IBAction) testConnection;
-(IBAction) applyCahges;
-(IBAction) endEditing:(id) sender;


@end
