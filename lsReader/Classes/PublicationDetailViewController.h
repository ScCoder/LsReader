//
//  PublicationDetailViewController.h
//  lsReader
//
//  Created by Usov Sergei on 25.09.11.
//  Copyright 2011 LiveStreet Developers Team. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PublicationDetailViewController : UIViewController<UITableViewDataSource> {

	UITableView *myTable;
	NSMutableArray *keys;
	NSMutableDictionary *topics_collection;
	NSString *publication_type;
	NSInteger *current_page;
	UIButton *addNextButton;
	UISegmentedControl *topPeriodSegControl;	
	UIToolbar *topPeriodToolBar;
	
	UISegmentedControl *showTypeSegControl;	
	UIToolbar *showTypeToolBar;
	UIActivityIndicatorView *activityIndicator;



}
@property (nonatomic, retain) IBOutlet UITableView *myTable;
//@property (nonatomic, retain) NSMutableArray *keys;
//@property (nonatomic, retain) NSMutableDictionary *topics_collection;
@property (nonatomic, retain) NSString *publication_type;
@property (nonatomic, retain) IBOutlet UIButton *addNextButton;
@property (nonatomic, retain) IBOutlet UISegmentedControl *topPeriodSegControl;
@property (nonatomic, retain) IBOutlet UIToolbar *topPeriodToolBar;
@property (nonatomic, retain) IBOutlet UISegmentedControl *showTypeSegControl;	
@property (nonatomic, retain) IBOutlet UIToolbar *showTypeToolBar;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;



-(IBAction) addNext;

-(IBAction)loadTopicsList;

-(void) costomizeView;

@end
