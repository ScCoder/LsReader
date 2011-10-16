//
//  lsCache.h
//  lsReader
//
//  Created by Сергей Усов on 15.10.11.
//  Copyright 2011 LiveStreet Developers Team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface lsCache : NSObject <NSCoding,NSCopying> {
	NSCache *cacher;
}

@property (nonatomic, retain) NSCache *cacher;

@end
