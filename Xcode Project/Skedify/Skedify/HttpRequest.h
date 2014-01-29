//
//  GKHttpRequest.h
//  Skedify
//
//  Created by Yigit Gunay on 1/28/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import <Foundation/Foundation.h>

/*

    HttpRequest is used for sending data to a server. There are two public methods. initRequestWithURL:dictionary:completionHandler:errorHandler initiates and asynchronous request, and the other one a synchronous one.
 
    All of the parameters that are to be passed to the server must be included in the dictionary whose keys must be strings. In order to pass an array, the keys must be named as key[0], key[1] etc. The dictionary must always contain the key 'action'.
 
    Example:
    The following example sends an HTTP request to https://www.myserver.com/ajax.php with the arguments written below. If we need to use the server response, we must set a non-nil callback as completion handler.
    NSDictionary* requestDictionary = @{@"action" : @"Login",
    @"username" : @"yigit.guenay@rwth-aachen.de"};
    HttpRequest* req = [[HttpRequest alloc] initRequestWithURL:@"https://www.myserver.com/ajax.php" dictionary:requestDictionary completionHandler:^(NSDictionary* dictionary) {
    NSLog(@"Login completed with dictionary: %@", dictionary);
    } errorHandler:nil];
 
*/


@interface HttpRequest : NSObject

- (id) initRequestWithURL:(NSString*)url dictionary:(NSDictionary*)dictionary completionHandler:(void(^)(NSDictionary*))completionHandler errorHandler:(void(^)(NSError*))errorHandler;
- (id) initSynchronousRequestWithURL:(NSString*)url dictionary:(NSDictionary*)dictionary completionHandler:(void(^)(NSDictionary*))completionHandler;
- (void) cancel;
@end
