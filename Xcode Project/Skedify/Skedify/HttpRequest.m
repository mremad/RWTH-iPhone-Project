//
//  GKHttpRequest.m
//  Skedify
//
//  Created by Yigit Gunay on 1/28/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import <UIKit/UIKit.h>

#warning - PRIVATE API! This should not be used while uploading the app to AppStore.
@implementation NSURLRequest(AllowAllCerts)

+ (BOOL) allowsAnyHTTPSCertificateForHost:(NSString *) host {
    return YES;
}

@end

#define kTIMEOUTINTERVAL 60.0

#import "HttpRequest.h"

@interface HttpRequest ()

/* set callback properties weak in order to avoid potential retain cycles */
@property(strong) void (^completionHandler)(NSDictionary* responseDictionary);
@property(strong) void (^errorHandler)(NSError* data);

@property(strong, nonatomic) NSMutableData* receivedData;
@property(strong, nonatomic) NSURLConnection *connection;
@property(strong, nonatomic) NSOperationQueue* queue;

@end

@implementation HttpRequest

- (id) initRequestWithURL:(NSString*)url dictionary:(NSDictionary*)dictionary completionHandler:(void(^)(NSDictionary*))completionHandler errorHandler:(void(^)(NSError*))errorHandler
{
    if (self = [super init])
    {

        _completionHandler = completionHandler;
        _errorHandler = errorHandler;
        
        _queue = [[NSOperationQueue alloc] init];
        
        NSAssert(dictionary[@"action"], @"dictionary must contain the key 'action'!");
        
        NSMutableString* post = [NSMutableString stringWithFormat:@"action=%@", dictionary[@"action"]];
        for (id key in dictionary)
        {
            if (![key isEqualToString:@"action"])
                [post appendFormat:@"&%@=%@", key, [dictionary objectForKey:key]];
        }
        //NSLog(@"%@",post);
        // Create post data.
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
        // Create the request.
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kTIMEOUTINTERVAL];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
        [request setHTTPBody:postData];


        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        _receivedData = [NSMutableData dataWithCapacity: 0];
        
        // Create the connection with the request and start loading the data.
        _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
        
        [_connection setDelegateQueue:_queue];
        [_connection start];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        if (!_connection)
        {
            // Release the receivedData object.
            _receivedData = nil;
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            // Inform the user that the connection failed.
        }
    }
    return self;
}

- (id) initSynchronousRequestWithURL:(NSString*)url dictionary:(NSDictionary*)dictionary completionHandler:(void(^)(NSDictionary*))completionHandler
{
    if (self = [super init])
    {
        NSMutableString* post = [NSMutableString stringWithFormat:@"action=%@", dictionary[@"action"]];
        for (id key in dictionary)
        {
            [post appendFormat:@"&%@=%@", key, [dictionary objectForKey:key]];
        }
        NSLog(@"%@",post);
        // create post data
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
        // Create the request.
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kTIMEOUTINTERVAL];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
        [request setHTTPBody:postData];
        
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        NSError* error;
        NSData* response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        NSError *e = nil;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData: response options: NSJSONReadingMutableContainers error: &e];
        if (!responseDictionary)
        {
            NSLog(@"Error parsing JSON: %@", e);
        }
        else
        {
            completionHandler(responseDictionary);
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
    }
    return self;
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse object.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    
    // receivedData is an instance variable declared elsewhere.
    [_receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [_receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    // Release the connection and the data object
    // by setting the properties (declared elsewhere)
    // to nil.  Note that a real-world app usually
    // requires the delegate to manage more than one
    // connection at a time, so these lines would
    // typically be replaced by code to iterate through
    // whatever data structures you are using.
    _connection = nil;
    _receivedData = nil;
    
    _errorHandler(error);
    
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);

    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a property elsewhere
    //NSLog(@"Succeeded! Received %d bytes of data",[_receivedData length]);
    NSError *e = nil;
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData: _receivedData options:  NSJSONReadingMutableContainers error: &e];
    //NSLog(@"response: %@", [[NSString alloc] initWithData:_receivedData encoding:NSUTF8StringEncoding]);
    //NSLog(@"response dictionary: %@", responseDictionary);
    
    if (!responseDictionary)
    {
        NSLog(@"Error parsing JSON: %@", e);
    }
    else
    {
        _completionHandler(responseDictionary);
    }
    // Release the connection and the data object
    // by setting the properties (declared elsewhere)
    // to nil.  Note that a real-world app usually
    // requires the delegate to manage more than one
    // connection at a time, so these lines would
    // typically be replaced by code to iterate through
    // whatever data structures you are using.
    _connection = nil;
    _receivedData = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}



- (void) cancel
{
    NSLog(@"cancelled!!!!");
    [_connection cancel];
}

@end
