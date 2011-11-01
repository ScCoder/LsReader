//
//  PubDetailCell.h
//  lsReader
//
//  Created by Сергей Усов on 01.11.11.
//  Copyright 2011 LiveStreet Developers Team. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PubDetailCell : UITableViewCell {
	UILabel *blog_title;
	UILabel *topic_title;
	UILabel *topic_description;
	UILabel *topic_author;
	UILabel *topic_date;
	
	
}

@property (nonatomic,retain) IBOutlet UILabel *blog_title;
@property (nonatomic,retain) IBOutlet UILabel *topic_title;
@property (nonatomic,retain) IBOutlet UILabel *topic_description;
@property (nonatomic,retain) IBOutlet UILabel *topic_author;
@property (nonatomic,retain) IBOutlet UILabel *topic_date;
@end
