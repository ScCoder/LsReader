//
//  communicator.m
//  lsReader
//
//  Created by Usov Sergei on 11.09.11.
//  Copyright 2011 LiveStreet Developers Team. All rights reserved.
//

#import "Communicator.h"
#import "JSONKit.h"
#import "Consts.h"


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

  if (!hash) {
	  
	  NSLog(@"not logged");
	  return NO;
	  
  }	else {
	  return YES;
  }
	
}


-(void) loadCache {
	
	// Получаем и запоминаем путь до файла кеша
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectoryPath = [paths objectAtIndex:0];	
	self.casheFilePath = [documentsDirectoryPath stringByAppendingString:CACHE_FILE_NAME];
	
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
	
}

-(void) saveCache {
		

	if ([NSKeyedArchiver archiveRootObject:self.ls_cache toFile:self.casheFilePath]) {
		
		NSLog(@"cache saved OK");
	}
	else {
		
		NSLog(@"cache saved FALSE");
	}

}


-(NSDictionary *)commandByModule:(NSString*)module site:(NSString*)site  method:(NSString*)method params:(NSString*)params
{
		
	
	UIApplication *app = [UIApplication sharedApplication];
	
	app.networkActivityIndicatorVisible = YES;
	
	
	NSString *api_command = [NSString stringWithFormat:@"http://%@/api/%@/%@/?%@&response_type=json",
							 site,module,method,params];
	
	NSString *api_cmd_hash = [NSString stringWithFormat:@"hash =%d",[api_command hash]];
	
	NSLog(@"api_comand=%@",api_command);
	
	
	// Пробуем взять из кеша 
	
	NSDictionary *response = [self.ls_cache objectForKey:api_cmd_hash];
		
	// Если нет в кеше то берем с сайта
	if (!response) {
		
		NSLog(@"not in cache");
	
		NSURL *url = [NSURL URLWithString:api_command];
	
		NSURLRequest *request = [NSURLRequest requestWithURL:url];
	
		NSData *tmpContainer = [NSURLConnection sendSynchronousRequest:request 
													 returningResponse:nil 
																 error:nil];
	
		if (!tmpContainer) {
			
			NSLog(@"commandByModule ошибка tmpContainer = nill");
			app.networkActivityIndicatorVisible = NO;
			return nil;
		}
		
		
		JSONDecoder *decoder = [JSONDecoder decoder];
	
		response = [decoder parseJSONData:tmpContainer];
		
		
		if (!response) {
			NSLog(@"commandByModule ошибка response = nill");
			app.networkActivityIndicatorVisible = NO;
			return nil;
		}

		
		if (![response objectForKey:@"response"]) {
			
			if ([response objectForKey:@"bStateError"]) {
				
				// Ошибка 
				NSLog(@"bStateError = %@",[response objectForKey:@"bStateError"]);
				NSLog(@"sMSG = %@", [response objectForKey:@"sMsg"]);
				NSLog(@"sMsgTitle = %@", [response objectForKey:@"sMsgTitle"]);
				
			} else {
				
				NSLog(@"Неизвестная ошибка(Нет response в ответе) текущий ответ = @%",response);
				
			}
			
		} else {
			
			// Все ок ложим в кеш !!!!!
			response = [response objectForKey:@"response"];						
			
			// Ложим в кеш
			
			[self.ls_cache setObject:response forKey:api_cmd_hash];

			NSLog(@"put to cache!");
			//NSLog(@"cache count =%d",[self.ls_cache count]);			
		   
		}
		
    }
	
	app.networkActivityIndicatorVisible = NO;
	
	return response;
			
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
			
			hash = NULL;
		    
			return YES;
		}
		
	}
	
	
	if ([response objectForKey:@"hash"] ){
		
		hash = [response objectForKey:@"hash"];
		
		self.siteURL = site;

		return YES;		
	
	}	
	else {
		
		return NO;
		
	}

}

-(NSDictionary *) topPublicationsByPeriod:(NSString*)period {
	
	NSString *tmpParams = [NSString stringWithFormat:@"period=%@&fields=topic_title,topic_id,topic_text_short",period];
	
	NSDictionary *response = [self commandByModule:@"topic" site:self.siteURL method:@"top" params:tmpParams]; 
	
    return response;

}

-(NSDictionary *) newPublications{
	
	NSString *tmpParams = [NSString stringWithFormat:@"fields=topic_title,topic_id,topic_text_short"];
	
	NSDictionary *response = [self commandByModule:@"topic" site:self.siteURL method:@"new" params:tmpParams]; 
	
	NSString *tmp = [response objectForKey:@"count"];
	
	
	if ( [tmp isEqualToString: @"0" ]) {
	 
		NSLog(@"good");
		return nil;
	 
	 }
	 else {
	 
		 return response;
	 }
	
}

-(NSDictionary *) personalPublications:(NSString *) showType page:(NSInteger *)page{
	
	
	NSString *tmpParams = [NSString stringWithFormat:@"show_type=%@&fields=topic_title,topic_id,topic_text_short&per_page=%@&page=%i",showType,self.countPerPage,page];
	
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
		
    return response;

}

-(NSString *) voteByTopicId:(NSString *) topic_id value: (NSInteger)value{

	NSString *tmpParams = [NSString stringWithFormat:@"id=%@&value=%i&hash=%@",topic_id,value,hash];
	
	NSDictionary *response = [self commandByModule:@"topic" site:self.siteURL method:@"vote" params:tmpParams]; 
	
	return [response objectForKey:@"rating"];
	

}

-(void) showCacheToLog{

	NSArray *keys = [self.ls_cache allKeys];
	
	for ( id key in keys){
	
		NSLog(@" key = %@", key);
	}
	
	
	if ([NSKeyedArchiver archiveRootObject:self.ls_cache toFile:self.casheFilePath]) {
	  NSLog(@"writed OK");
	}
	else {
		NSLog(@"writed FALSE");
	}
	
	NSLog(@"path=%@",self.casheFilePath);
		
	NSLog(@"writed");
	
}

- (void) loadTopicsToStorage: (NSDictionary *) response  {
 
	NSMutableDictionary *topics_collection = [[NSMutableDictionary alloc] initWithCapacity:1];
			
	[topics_collection addEntriesFromDictionary: [response objectForKey:@"collection"]];	
		
	NSMutableArray *keys = [NSMutableArray arrayWithArray: [topics_collection allKeys]];	
	
	for(id key in keys) {
		
		[self readTopicById:[[topics_collection objectForKey: key] objectForKey:@"topic_id" ]];
	}

}
-(void) loadContent{
    NSLog(@"start load content");
	// Загрузка публикацийыы
	
	//NSDictionary *response = [NSDictionary dictionaryWithObjectsAndKeys:nil] ;
	
    // Лучшие
	for ( id period in self.publicationPeriods){
	
	  //response = [self topPublicationsByPeriod:period];
		
	  [self loadTopicsToStorage: [self topPublicationsByPeriod:period]];
	}
	
	//[self loadTopicsToStorage: response];

	// Новые публикации
	
	[self loadTopicsToStorage: [[Communicator sharedCommunicator] newPublications]];
	
	//Персональные публикации
	
	 [self loadTopicsToStorage: 
	  [[Communicator sharedCommunicator] personalPublications:@"good" page:10]];
	
	 NSLog(@"end load content");	


}

@end
