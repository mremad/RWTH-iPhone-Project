//
//  CalendarFetcher.h
//  Skedify
//
//  Created by Yigit Gunay on 1/19/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalendarFetcher : NSObject  <NSURLConnectionDataDelegate, NSXMLParserDelegate>

@property(retain) NSString  *accessToken;
- (void) fetchL2PCourseRooms;
- (void) fetchIphoneEvents;

@end
