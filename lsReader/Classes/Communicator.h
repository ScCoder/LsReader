//
//  communicator.h
//  lsReader
//
//  Created by Usov Sergei on 11.09.11.
//  Copyright 2011 LiveStreet Developers Team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface 

Communicator : NSObject {
	NSString *siteURL;
	NSString *countPerPage;
	NSMutableDictionary *ls_cache;
	NSString *hash;
	NSString *casheFilePath;
	BOOL showPics; 
	NSArray *publicationPeriods;
	NSArray *publicTypes;
	NSArray *publicTypesIcons;

}

@property (nonatomic, retain) NSString *siteURL;
@property (nonatomic, retain) NSString *countPerPage;
@property (nonatomic, retain) NSString *casheFilePath;
@property (nonatomic, retain) NSMutableDictionary *ls_cache;
@property BOOL showPics;
@property (nonatomic, retain) NSArray *publicationPeriods;
@property (nonatomic, retain) NSArray *publicTypes;
@property (nonatomic, retain) NSArray *publicTypesIcons;
@property (nonatomic, retain) NSArray *publicationShowType;


+(Communicator *)sharedCommunicator;


-(void) loadCache;

-(void) saveCache;

-(void) cleanCache;

-(void) showCacheToLog;



-(NSDictionary *)commandByModule:(NSString*)module site:(NSString*)site method:(NSString*)method params:(NSString*)params;  

-(Boolean *)checkConnectionBySite:(NSString*)site  login:(NSString*)login password:(NSString*)password;

-(NSDictionary *) topPublicationsByPeriod:(NSString*)period; 

-(NSDictionary *) newPublications;

-(NSDictionary *) personalPublications:(NSString *)showType page:(NSInteger*)page;

-(NSDictionary *) readTopicById:(NSString*) topic_id;

-(NSString *) voteByTopicId:(NSString *) topic_id value: (NSInteger)value;

-(Boolean *) isLogedIn;

-(NSDictionary *) commentsByTopicId:(NSString *) topic_id;

-(void) saveContentToStorage;

-(void) cacheImages:(NSString*) topicContent;


@end
