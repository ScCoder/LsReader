//
//  communicator.m
//  lsReader
//
//  Created by Usov Sergei on 11.09.11.
//  Copyright 2011 LiveStreet Developers Team. All rights reserved.
//

#import "Communicator.h"
#import "JSONKit.h"
#import "SDURLCache.h"
#import "lsReaderAppDelegate.h"


@implementation Communicator

@synthesize siteURL;
@synthesize countPerPage;
@synthesize showPics;
@synthesize casheFilePath;
@synthesize ls_cache;
@synthesize publicationPeriods;
@synthesize publicTypes;
@synthesize publicTypesIcons;
@synthesize publicationShowType;

static Communicator * communicator =  NULL;

static JSONDecoder *decoder = nil;

+(Communicator *)sharedCommunicator {

	if (!communicator || communicator == NULL) {
	
		communicator = [Communicator new];
		
		communicator.publicationPeriods = [NSArray arrayWithObjects:@"24h",@"7d",@"30d",@"all",nil];
		communicator.publicationShowType = [NSArray arrayWithObjects:@"good",@"bad",@"new",nil];
		
		
		communicator.publicTypes = [NSArray arrayWithObjects:PT_TOP,PT_NEW,PT_COLLECTIV
									,PT_PERSONAL,PT_LINE,PT_ACTIVITY,nil];
		
		communicator.publicTypesIcons = [NSArray arrayWithObjects:@"28-star.png",@"06-magnify.png"
										 ,@"112-group.png",@"111-user.png",@"58-bookmark.png"
										 ,@"81-dashboard.png",nil];
		
		
		
	}
	return communicator;
}


-(Boolean *) isLogedIn {

  if (!user_login_hash1) {
	  
	  NSLog(@"not logged");
	  return NO;
	  
  }	else {
	  return YES;
  }
	
}


-(void) loadCache {
	
	[self createDirs];
	
	// Получаем и запоминаем путь до файла кеша
	self.casheFilePath = [NSString stringWithFormat:@"%@/%@/%@",DOCUMENTS,LS_READER_DIR,CACHE_FILE_NAME];
	
	// Пытаемся загрузить кешь

	self.ls_cache = [NSKeyedUnarchiver unarchiveObjectWithFile:self.casheFilePath];

	// Если не загрузили то создаем
	
	if (!self.ls_cache) {
	
		self.ls_cache = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"start",@"cache",nil];
		NSLog(@"cache created!");
		
	}
	else {
		
		NSLog(@"cahe loaded!");
		
	}
	
	
	/*
	SDURLCache *urlCache = [[SDURLCache alloc] initWithMemoryCapacity:1024*1024   // 1MB mem cache
														 diskCapacity:1024*1024*5 // 5MB disk cache
															 diskPath:[SDURLCache defaultCachePath]];
	[NSURLCache setSharedURLCache:urlCache];
	[urlCache release];	
	 */
	
    container = [[NSMutableDictionary alloc] initWithCapacity:1];
	user_login_hash1 = [[NSMutableString alloc] initWithCapacity:10];
}

-(void) saveCache {
		

	if ([NSKeyedArchiver archiveRootObject:self.ls_cache toFile:self.casheFilePath]) {
		
		NSLog(@"cache saved OK");
	}
	else {
		
		NSLog(@"cache saved FALSE");
	}
	[user_login_hash1 release];
	
	[container release];

}



-(NSDictionary *)commandByModule:(NSString*)module site:(NSString*)site  method:(NSString*)method params:(NSString*)params
{
	
	


	
	//UIApplication* app = [UIApplication sharedApplication]; 
	//app.networkActivityIndicatorVisible = YES;
	

	
	NSString *api_command = [NSString stringWithFormat:@"http://%@/api/%@/%@/?%@&response_type=json",site,module,method,params];
	
	NSLog(@"api_comand=%@", api_command);
	
	
	NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:api_command]];
		
	NSData *tmpContainer = [NSURLConnection sendSynchronousRequest:request 
												 returningResponse:nil 
															 error:nil];
		
	if (!tmpContainer) {
	  NSLog(@"commandByModule ошибка tmpContainer = nill");
	//  app.networkActivityIndicatorVisible = NO;
	  return nil;
	}
		
		
	if (!decoder)  decoder = [[JSONDecoder alloc] init] ;
	
	NSDictionary *response = [decoder objectWithData:tmpContainer error: nil ] ;
	
	[decoder release];
	
	decoder = nil;

	


	
	//app.networkActivityIndicatorVisible = NO;
	
	
	if (!response) {
	  NSLog(@"commandByModule ошибка response = nill");
	  return nil;
	}

	if (![response objectForKey:@"response"]) {
			
		if ([response objectForKey:@"bStateError"]) {
			NSLog(@"bStateError = %@",[response objectForKey:@"bStateError"]);
			NSLog(@"sMSG = %@", [response objectForKey:@"sMsg"]);
			NSLog(@"sMsgTitle = %@", [response objectForKey:@"sMsgTitle"]);
				
		} else {
				
			NSLog(@"Неизвестная ошибка(Нет response в ответе) текущий ответ = @%",response);
				
		}
			
	} else {
			
		response = [response objectForKey:@"response"];		
		
	}
	
		

		
	[container removeAllObjects];
    [container addEntriesFromDictionary:response];
	
	//NSLog(@"container = %@ ",container);
	
	
	
	return container ;		
			
	
}



-(Boolean *)checkConnectionBySite:(NSString*)site  login:(NSString*)login password:(NSString*)password{
	
	NSString *tmpParams = [NSString stringWithFormat:@"login=%@&password=%@",login,password];
	
	NSDictionary *response = [self commandByModule:@"common" site:site method:@"login" params:tmpParams]; 
		
	//если логин пустой то просто проверяем есть ответ или нет

	if (!login) { 	
		
		if (!response) {
			
			return NO;
			
		} else {
			
			self.siteURL = site;
			
			user_login_hash1 = NULL;
		    
			return YES;
		}
		
	}
	
	
	if ([response objectForKey:@"hash"] ){
		
		[user_login_hash1 deleteCharactersInRange:NSMakeRange(0, [user_login_hash1 length])];
		[user_login_hash1 appendString:[response objectForKey:@"hash"]];
		
		NSLog(@"hash = %@",user_login_hash1);
		self.siteURL = site;

		return YES;		
	
	}	
	else {
		
		return NO;
		
	}

}

-(NSDictionary *) topPublicationsByPeriod:(NSString*)period {
	
	NSString *tmpParams = [NSString stringWithFormat:@"period=%@&fields=%@",period,FIELDS_FILTER];

	return [self commandByModule:@"topic" site:self.siteURL method:@"top" params:tmpParams];
	
}

-(NSDictionary *) newPublications{
	
	NSString *tmpParams = [NSString stringWithFormat:@"fields=%@",FIELDS_FILTER];
	
	NSDictionary *response =  [self commandByModule:@"topic" site:self.siteURL method:@"new" params:tmpParams]; 
	
	NSString *tmp = [response objectForKey:@"count"];
	
	
	if ( [tmp isEqualToString: @"0" ]) {
	 
		NSLog(@"good");
		return nil;
	 
	 }
	 else {
	 
		 //return response ;
		 return container;
	 }
	 
	
}

-(NSDictionary *) personalPublications:(NSString *) showType page:(NSInteger *)page{
	
	
	NSString *tmpParams = [NSString stringWithFormat:@"show_type=%@&fields=%@&per_page=%@&page=%i",showType,FIELDS_FILTER,self.countPerPage,page];
	
	NSDictionary *response = [self commandByModule:@"topic" site:self.siteURL method:@"personal" params:tmpParams]; 
	
	NSString *tmp = [response objectForKey:@"count"];
	
	
	if ( [tmp isEqualToString: @"0" ]) {
		
		return nil;
		
	}
	else {
		
		return response;
	}
	
	
}

-(NSDictionary *) readTopicById:(NSString*) topic_id {
	
	NSString *tmpParams = [NSString stringWithFormat:@"id=%@",topic_id];
	
	NSDictionary *response = [self commandByModule:@"topic" site:self.siteURL method:@"read" params:tmpParams]; 
	
	NSLog(@"topic data = %@",response);
    
	return response;

}

-(NSDictionary *) voteByTopicId:(NSString *) topic_id value: (NSInteger)value{


	NSLog(@"voteByTopicId =%@",user_login_hash1);

	NSString *tmpParams = [NSString stringWithFormat:@"id=%@&value=%i&hash=%@",topic_id,value,user_login_hash1];
	
	NSLog(@"tmpParams = %@",tmpParams);
	return  [self commandByModule:@"topic" site:self.siteURL method:@"vote" params:tmpParams];

}

-(NSDictionary *) commentsByTopicId:(NSString *) topic_id{
	
	NSString *tmpParams = [NSString stringWithFormat:
	  @"id=%@&type=topic&fields=user[user_login],comment_date,comment_text,comment_level,comment_id,comment_pid,target_id,target_parent_id,target_type",topic_id];
		
    return [self commandByModule:@"comment" site:self.siteURL method:@"list" params:tmpParams]; 	
	
}


- (void) saveTopicsToStorage: (NSDictionary *) response  {
 
	NSMutableDictionary *topics_collection = [[NSMutableDictionary alloc] initWithCapacity:1];
			
	[topics_collection addEntriesFromDictionary: [response objectForKey:@"collection"]];	
		
	NSMutableArray *keys = [NSMutableArray arrayWithArray: [topics_collection allKeys]];	
	
	for(id key in keys) {
		
		[self readTopicById:[[topics_collection objectForKey: key] objectForKey:@"topic_id" ]];
	}
	[topics_collection release];

}

-(void) saveContentToStorage{
	
    NSLog(@"start save content");
	// Загрузка публикацийыы
	
	//NSDictionary *response = [NSDictionary dictionaryWithObjectsAndKeys:nil] ;
	
    // Лучшие
	for ( id period in self.publicationPeriods){
	
	  //response = [self topPublicationsByPeriod:period];
		
	  [self saveTopicsToStorage: [self topPublicationsByPeriod:period]];
	}
	
	//[self loadTopicsToStorage: response];

	// Новые публикации
	
	[self saveTopicsToStorage: [[Communicator sharedCommunicator] newPublications]];
	
	//Персональные публикации
	
	 [self saveTopicsToStorage: 
	  [[Communicator sharedCommunicator] personalPublications:@"good" page:10]];
	
	 NSLog(@"end load content");	


}

-(void) createDirs {
	
	// Создание директории
	
	
	NSFileManager *NSFm= [NSFileManager defaultManager]; 
	BOOL isDir = YES;
    
	NSString *lsReaderDir = [NSString stringWithFormat:@"%@/%@",DOCUMENTS,LS_READER_DIR];
						
	if(![NSFm fileExistsAtPath:lsReaderDir isDirectory:&isDir])
		if(![NSFm createDirectoryAtPath:lsReaderDir attributes:nil])
			NSLog(@"Error: Create folder failed");
	
  	
	NSString *cacheImagesDir = [NSString stringWithFormat:@"%@/%@/%@",DOCUMENTS,LS_READER_DIR,CACHE_IMAGES_DIR];
	
	if(![NSFm fileExistsAtPath:cacheImagesDir isDirectory:&isDir])
		if(![NSFm createDirectoryAtPath:cacheImagesDir attributes:nil])
			NSLog(@"Error: Create folder failed");

}
-(void) cacheImages:(NSString*) topicContent {

	NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern: @"<img[^>]src=\"([^>\"]+)\"[^>]*>"
																			options:NSRegularExpressionCaseInsensitive
																			  error:NULL];
	
	for (NSTextCheckingResult *match in [regExp matchesInString:topicContent options:0 range:NSMakeRange(0,[topicContent length])]){
		
		NSString* url = [topicContent substringWithRange:[match rangeAtIndex:1]]; 
				
		UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
		
		
		NSMutableString *imgFileExt;// = [[NSMutableString alloc] init];
		
		if ([url rangeOfString:@".png"].location > 0){
		
			imgFileExt =  [NSMutableString stringWithString: @"png"];
			
		} else if ([url rangeOfString:@".jpg"].location > 0) {
		
			imgFileExt =  [NSMutableString stringWithString: @"jpg"];
		
		}else {
			NSLog(@"Error Unsupprted image file format, file url = %@",url );
			[image release];
			return;
		}
		
		
		
		NSString *cacheImageFilePath = [NSString stringWithFormat:@"%@/%@/%@/img_%d.%@"
									,DOCUMENTS,LS_READER_DIR,CACHE_IMAGES_DIR,[url hash],imgFileExt];
		
		//[imgFileExt release];
		//Сохранение файла
		
		NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(image)];
		[data1 writeToFile:cacheImageFilePath atomically:YES];
		
		[image release];
	
	}
		
}

-(void)cutHtmlTagsFromText: (NSMutableString *) intext
{
	
	
	NSError *error = NULL;
	NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:@"<[^>]*>"             //@"</?([a-oq-z][^>]*|p[^>]+)>" // @"<img([^<]+)>" 
																			options:NSRegularExpressionCaseInsensitive
																			  error:&error];
	
    [regExp replaceMatchesInString:intext options:0 range:NSMakeRange(0,[intext length]) withTemplate:@""];
	
	
	//if ([intext length] > 100) {
		
	//	[intext deleteCharactersInRange:NSMakeRange(100,[intext length]-100)];
	//}
	
	

}

-(NSString *)cutHtmlTagsFromString: (NSString *) instring{
	
	NSError *error = NULL;
	NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:@"<[^>]*>"             //@"</?([a-oq-z][^>]*|p[^>]+)>" // @"<img([^<]+)>" 
																			options:NSRegularExpressionCaseInsensitive
																			  error:&error];
	
	NSMutableString *str = [[NSMutableString alloc] initWithCapacity:10];
	
	[str appendString: instring]; 	
	
    [regExp replaceMatchesInString:str options:0 range:NSMakeRange(0,[str length]) withTemplate:@""];
	
	return [str autorelease];

}

-(void) testCache{
	
	
	
	NSURLCache *sharedCache = 
	[[NSURLCache alloc] initWithMemoryCapacity:10 * 1000000 
								  diskCapacity:10 * 1000000 
									  diskPath:self.casheFilePath];
	[NSURLCache setSharedURLCache:sharedCache];
	[sharedCache release];
}



@end
