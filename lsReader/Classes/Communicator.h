//
//  communicator.h
//  lsReader_002
//
//  Created by Сергей Усов on 11.09.11.
//  Copyright 2011 Стройкомплект. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Communicator : NSObject {
	NSString *siteURL;

}

@property (nonatomic, retain) NSString *siteURL;

+(Communicator *)sharedCommunicator;

-(NSString *)login;



-(NSDictionary *)commandByModule:(NSString*)module site:(NSString*)site method:(NSString*)method params:(NSString*)params;  

-(Boolean *)testConnectionBySite:(NSString*)site  login:(NSString*)login password:(NSString*)password;

-(NSDictionary *) topPublicationsByPeriod:(NSString*)period; 

-(NSDictionary *) newPublications;

-(NSDictionary *) readTopicById:(NSString*) topic_id;

@end
