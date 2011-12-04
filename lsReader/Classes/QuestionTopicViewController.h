//
//  QuestionTopicViewController.h
//  lsReader
//
//  Created by Сергей Усов on 03.12.11.
//  Copyright 2011 LiveStreet Developers Team. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface QuestionTopicViewController : UIViewController<UITableViewDataSource>{

	
		NSMutableDictionary *topic_data;
		NSInteger selectedAnswer;
		NSArray *answers;
	    NSInteger countVote;
	    UILabel *topic_question;
}

@property (nonatomic, retain) NSMutableDictionary *topic_data;
@property (nonatomic, retain) IBOutlet  UILabel *topic_question;

@end
