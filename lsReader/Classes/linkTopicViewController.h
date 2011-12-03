//
//  linkTopicViewController.h
//  lsReader
//
//  Created by Сергей Усов on 03.12.11.
//  Copyright 2011 LiveStreet Developers Team. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface linkTopicViewController : UIViewController {

	UIButton *linkBtn;
	UILabel *linkDescription;
	UILabel *linkTitle;
	UILabel *linkURL;

	
	NSMutableDictionary *topic_data;
	
}



@property (nonatomic, retain) IBOutlet UIButton *linkBtn;
@property (nonatomic, retain) IBOutlet UILabel *linkDescription;
@property (nonatomic, retain) IBOutlet UILabel *linkTitle;
@property (nonatomic, retain) IBOutlet UILabel *linkURL;

@property (nonatomic, retain) NSMutableDictionary *topic_data;

-(IBAction) linkBtnTouched:(id) sender;


@end
