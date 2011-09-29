//
//  RootViewController.h
//  lsReader_002
//
//  Created by Сергей Усов on 01.09.11.
//  Copyright 2011 Стройкомплект. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UITableViewController {
	NSMutableArray *sites;
	IBOutlet UITabBarController *tabBarController;
	NSMutableDictionary *siteParams;
	


}
@property (nonatomic, retain) NSMutableArray *sites;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) NSMutableDictionary *siteParams;
-(IBAction) editParams;
-(IBAction) addSite;


@end
