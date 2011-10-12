//
//  lsReaderAppDelegate.h
//  lsReader
//
//  Created by Usov Sergei on 01.09.11.
//  Copyright 2011 LiveStreet Developers Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface lsReaderAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
	NSString *settingsFilePath;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) NSString *settingsFilePath;
@end

