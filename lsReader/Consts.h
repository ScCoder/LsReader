//
//  Consts.h
//  lsReader
//
//  Created by Сергей Усов on 14.10.11.
//  Copyright 2011 LiveStreet Developers Team. All rights reserved.
//

#import <Foundation/Foundation.h>


#define CACHE_FILE_NAME  @"cachestorage.dat"
#define LS_READER_DIR @"LsReader"
#define CACHE_IMAGES_DIR @"images"
#define SITE_URL @"url"
#define SITE_LOGIN @"login"
#define SITE_PASSWD @"passwd"
#define COUNT_PER_PAGE @"countPerPage"
#define SHOW_PICS @"showPics"
#define NEW_KEY @"new"
#define PT_TOP @"Лучшие"
#define PT_NEW @"Новые"
#define PT_COLLECTIV @"Коллективные"
#define PT_PERSONAL @"Персональные"
#define PT_LINE @"Лента"
#define PT_ACTIVITY @"Активность"
#define FIELDS_FILTER @"topic_title,topic_id,topic_text_short,topic_type,topic_extra_array[url],blog[blog_title],topic_date_add,user[user_login]"

#define DOCUMENTS [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define SharedCommunicator [Communicator sharedCommunicator] 


#define MSG_CONNECTION_OK @"Соединие установленно успешно!!"
#define MSG_CONNECTION_FAILED @"Ошибка!!! Проверьте введенные данные..."


#define PUB_DETAIL_CELL_HEIGHT 129.0f
//extern const 
/*
 
 siteURL.text = [[siteParams objectForKey:key] objectForKey:@"url"];
 siteLogin.text = [[siteParams objectForKey:key] objectForKey:@"login"];
 sitePasswd.text = [[siteParams objectForKey:key] objectForKey:@"passwd"];
 countPerPage.value = [[siteParams objectForKey:key] objectForKey:@"countPerPage"];
 showPics.value =  [[siteParams objectForKey:key] objectForKey:@"showPics"];	
 
 */

