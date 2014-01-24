//
//  L2PFetcher.h
//  Skedify
//
//  Created by Yigit Gunay on 1/19/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface L2PFetcher : NSObject  <NSURLConnectionDataDelegate, NSXMLParserDelegate>

@property(retain) NSString  *accessToken;
-(void)getL2PCourseRooms;
- (void) getL2PCourseDates;

@end
