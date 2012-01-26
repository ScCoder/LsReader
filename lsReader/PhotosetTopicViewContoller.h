//
//  PhotosetTopicViewContoller.h
//  lsReader
//
//  Created by Сергей Усов on 03.12.11.
//  Copyright 2011 LiveStreet Developers Team. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PhotosetTopicViewContoller : UIViewController {

	UIImageView *photosetMainImage;
	UIScrollView *photosetScrollView;
	UILabel *photosetImageTitle;
	NSMutableArray *photosetImages;
	NSMutableArray *photosetDescriptions;
	
	NSMutableDictionary *topic_data;
}



@property (nonatomic, retain) IBOutlet UIImageView *photosetMainImage;
@property (nonatomic, retain) IBOutlet UIScrollView *photosetScrollView;
@property (nonatomic, retain) IBOutlet UILabel *photosetImageTitle;

@property (nonatomic, retain) NSMutableDictionary *topic_data;

-(IBAction) photosetImageTouched:(id) sender;

@end
