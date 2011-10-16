//
//  lsCache.m
//  lsReader
//
//  Created by Сергей Усов on 15.10.11.
//  Copyright 2011 LiveStreet Developers Team. All rights reserved.
//

#import "lsCache.h"
#import "Consts.h"


@implementation lsCache

@synthesize cacher;

#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder{

	if (self = [super init]){
	
		cacher = [[aDecoder decodeObjectForKey:CACHE_KEY] retain];
	}
	
	return self;
	
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
	
	[aCoder encodeObject:cacher forKey:CACHE_KEY];	 
}

#pragma mark -
#pragma mark NSCopying

-(id)copyWithZone:(NSZone *)zone{

	lsCache *copy = [[[self class] allocWithZone:zone] init];
	copy.cacher = [[self.cacher copyWithZone:zone] autorelease];
	return copy;
}



@end
