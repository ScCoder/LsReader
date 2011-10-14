//
//  PublicationDetailViewController.h
//  lsReader
//
//  Created by Usov Sergei on 25.09.11.
//  Copyright 2011 LiveStreet Developers Team. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PublicationDetailViewController : UIViewController<UITableViewDataSource> {

	IBOutlet UITableView *myTable;
	NSMutableArray *keys;
	NSMutableDictionary *topics_collection;
	NSString *publication_type;
	NSInteger *current_page;
	
	
}
@property (nonatomic, retain) IBOutlet UITableView *myTable;
@property (nonatomic, retain) NSMutableArray *keys;
@property (nonatomic, retain) NSMutableDictionary *topics_collection;
@property (nonatomic, retain) NSString *publication_type;

-(IBAction) addNext;

@end
