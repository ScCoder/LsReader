//
//  communicator.h
//  lsReader
//
//  Created by Usov Sergei on 11.09.11.
//  Copyright 2011 LiveStreet Developers Team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Communicator : NSCache {
	NSString *siteURL;
	NSString *countPerPage;
	NSCache *ls_cache;
	NSString *hash;

}

@property (nonatomic, retain) NSString *siteURL;
@property (nonatomic, retain) NSString *countPerPage;


+(Communicator *)sharedCommunicator;


-(void) loadCache;

-(void) saveCache;


-(NSDictionary *)commandByModule:(NSString*)module site:(NSString*)site method:(NSString*)method params:(NSString*)params;  

-(Boolean *)checkConnectionBySite:(NSString*)site  login:(NSString*)login password:(NSString*)password;

-(NSDictionary *) topPublicationsByPeriod:(NSString*)period; 

-(NSDictionary *) newPublications;

-(NSDictionary *) personalPublications:(NSString *)showType page:(NSInteger*)page;

-(NSDictionary *) readTopicById:(NSString*) topic_id;

@end
