//
//  commentsViewController.h
//  lsReader
//
//  Created by Сергей Усов on 30.10.11.
//  Copyright 2011 LiveStreet Developers Team. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface commentsViewController : UITableViewController {
	NSString *tiopicId;
	NSArray *keys;
	NSDictionary *commentsCollection;
	NSString *commentParentId;
	NSArray *childComentsCounts;
	NSNumber *commentLevel;
	NSNumber *level;
	UILabel *headerText;
	NSString *headerTextString;

}


@property (nonatomic, retain) NSString *topicId;
@property (nonatomic, retain) NSArray *keys;
@property (nonatomic, retain) NSDictionary *commentsCollection;
@property (nonatomic, retain) NSString *commentParentId;
@property (nonatomic, retain) NSArray *childComentsCounts;
@property (nonatomic, retain) NSNumber *commentLevel;
@property (nonatomic, retain) NSNumber *level;
@property (nonatomic, retain) IBOutlet UILabel *headerText;
@property (nonatomic, retain) NSString *headerTextString;



@end
