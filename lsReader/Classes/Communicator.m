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


static Communicator * communicator =  NULL;


+(Communicator *)sharedCommunicator {

	if (!communicator || communicator == NULL) {
	
		communicator = [Communicator new];
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
	
	ls_cache = [[NSCache alloc] init];
	
	/*
	NSData *data = [[NSData alloc] initWithContentsOfFile:CACHE_FILE_NAME];
	NSKeyedUnarchiver *unarhiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
	
	
	
	ls_cache = [unarhiver decodeObjectForKey:CACHE_KEY];
	
	if (!ls_cache){
		ls_cache = [[NSCache alloc] init];
	}
	
	
	[unarhiver finishDecoding];
	[unarhiver release];
	[data release];
	*/
	
}

-(void) saveCache {

	NSLog(@"saveCache");
/*
	if (ls_cache) {
		

	
	NSMutableData *data = [[NSMutableData alloc] init];
	
	NSKeyedArchiver *arhiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	
	[arhiver encodeObject:ls_cache forKey:CACHE_KEY];
	[arhiver finishEncoding];
	[data writeToFile:CACHE_FILE_NAME atomically:YES];
	
		
	[ls_cache release];

	[arhiver release];
	[data release];
	
	}
 */
	[ls_cache release];
}


-(NSDictionary *)commandByModule:(NSString*)module site:(NSString*)site  method:(NSString*)method params:(NSString*)params
{
		
	
	UIApplication *app = [UIApplication sharedApplication];
	
	app.networkActivityIndicatorVisible = YES;
	
	
	NSString *api_command = [NSString stringWithFormat:@"http://%@/api/%@/%@/?%@&response_type=json",
							 site,module,method,params];
	
	NSLog(@"api_comand=%@",api_command);
	
	
	// Пробуем взять из кеша (текущий класс наследник от NSCashe TODO наверно нужно переделать по другому)
	NSDictionary *response = [ls_cache objectForKey:api_command];
		
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
			[ls_cache setObject:response forKey:api_command];
			
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

@end
