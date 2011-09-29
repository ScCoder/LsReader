//
//  PublicationViewController.h
//  lsReader
//
//  Created by Usov Sergei on 28.08.11.
//  Copyright 2011 LiveStreet Developers Team. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface PublicationViewController : UIViewController<UITableViewDataSource> {

	UILabel *testLabel;
	IBOutlet UITableView *myTable;
	NSArray *publicTypes;
	UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic, retain) IBOutlet UILabel *testLabel;
@property (nonatomic, retain) IBOutlet UITableView *myTable;
@property (nonatomic, retain) NSArray *publicTypes;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
-(IBAction) testJSON;



@end
