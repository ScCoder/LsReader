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
	IBOutlet UITabBarController *tabBarController;
	NSMutableDictionary *siteParams;
	IBOutlet UINavigationController * innerNavController; 
	
	


}
@property (nonatomic, retain) NSMutableArray *sites;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet UINavigationController * innerNavController;
@property (nonatomic, retain) NSMutableDictionary *siteParams;

-(IBAction) editParams;
-(IBAction) addSite;
-(IBAction) barItemClick;


@end
