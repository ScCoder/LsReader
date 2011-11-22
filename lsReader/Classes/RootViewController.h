//
//  RootViewController.h
//  lsReader
//
//  Created by Usov Sergei on 01.09.11.
//  Copyright 2011 LiveStreet Developers Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UITableViewController<UITabBarDelegate> {
	NSMutableArray *sites;
	UITabBarController *tabBarController;
	NSMutableDictionary *siteParams;
	
}
@property (nonatomic, retain) NSMutableArray *sites;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) NSMutableDictionary *siteParams;

-(IBAction) editParams;
-(IBAction) addSite;
-(IBAction) barItemClick;


@end
