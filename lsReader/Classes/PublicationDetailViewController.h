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
	NSArray *keys;
	NSDictionary *topics_collection;
	NSString *publication_type;
}
@property (nonatomic, retain) IBOutlet UITableView *myTable;
@property (nonatomic, retain) NSArray *keys;
@property (nonatomic, retain) NSDictionary *topics_collection;
@property (nonatomic, retain) NSString *publication_type;

@end
