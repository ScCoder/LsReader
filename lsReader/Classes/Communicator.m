//
//  communicator.m
//  lsReader
//
//  Created by Usov Sergei on 11.09.11.
//  Copyright 2011 LiveStreet Developers Team. All rights reserved.
//

#import "Communicator.h"
#import "JSONKit.h"

@implementation Communicator

@synthesize siteURL;


static Communicator * communicator =  NULL;


+(Communicator *)sharedCommunicator {

	if (!communicator || communicator == NULL) {
	
		communicator = [Communicator new];
	}
	return communicator;
}

-(NSString *)login{
	
	NSString *api_command = [NSString stringWithFormat:@"http://new.livestreet.ru/api/common/login/?login=sc_coder&password=62b183f&response_type=json"];
	
	NSURL *url = [NSURL URLWithString:api_command];
	
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	
	NSData *tmpContainer = [NSURLConnection sendSynchronousRequest:request 
												 returningResponse:nil 
															 error:nil];
	
	JSONDecoder *decoder = [JSONDecoder decoder];
	
	NSDictionary *params = [decoder parseJSONData:tmpContainer];
	
	NSLog(@"test data %@",params);
	
	NSLog(@"hash = %@",[[params objectForKey:@"response"] objectForKey:@"hash"]);
	
	return [[params objectForKey:@"response"] objectForKey:@"hash"];
	
}

-(NSDictionary *)commandByModule:(NSString*)module site:(NSString*)site  method:(NSString*)method params:(NSString*)params
{
	
	
	NSString *api_command = [NSString stringWithFormat:@"http://%@/api/%@/%@/?%@&response_type=json",
							 site,module,method,params];
	NSLog(api_command);
	
	NSURL *url = [NSURL URLWithString:api_command];
	
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	
	NSData *tmpContainer = [NSURLConnection sendSynchronousRequest:request 
												 returningResponse:nil 
															 error:nil];
	
	JSONDecoder *decoder = [JSONDecoder decoder];
	
	NSDictionary *response = [decoder parseJSONData:tmpContainer];
	
	return [response objectForKey:@"response"] ;
	

}

-(Boolean *)testConnectionBySite:(NSString*)site  login:(NSString*)login password:(NSString*)password{
	
	NSString *tmpParams = [NSString stringWithFormat:@"login=%@&password=%@",login,password];
	
	NSDictionary *response = [self commandByModule:@"common" site:site method:@"login" params:tmpParams]; 
	
	
	if ([response objectForKey:@"hash"] == NULL ) {
		
		NSLog(@"test connection NO!!");
		return NO;
	}
	else{
		
		NSLog(@"test connection ok hash = %@",[response objectForKey:@"hash"]);
		return YES;
	}
	
	//
}

-(NSDictionary *) topPublicationsByPeriod:(NSString*)period {
	
	NSString *tmpParams = [NSString stringWithFormat:@"period=%@&fields=topic_title,topic_id,topic_text_short",period];
	
	NSDictionary *response = [self commandByModule:@"topic" site:self.siteURL method:@"top" params:tmpParams]; 
	
    return response;

}

-(NSDictionary *) newPublications{
	
	NSString *tmpParams = [NSString stringWithFormat:@"fields=topic_title,topic_id,topic_text_short"];
	
	NSDictionary *response = [self commandByModule:@"topic" site:self.siteURL method:@"new" params:tmpParams]; 
	
    return response;
	
}

-(NSDictionary *) readTopicById:(NSString*) topic_id {
	
	NSString *tmpParams = [NSString stringWithFormat:@"id=%@",topic_id];
	
	NSDictionary *response = [self commandByModule:@"topic" site:self.siteURL method:@"read" params:tmpParams]; 
		
    return response;

}

@end
