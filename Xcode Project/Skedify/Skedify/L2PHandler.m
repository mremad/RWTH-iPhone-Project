//
//  L2PHandler.m
//  Skedify
//
//  Created by Yigit Gunay on 1/19/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import "L2PHandler.h"
#import "WebViewController.h"
#import "CalendarFetcher.h"
#import "OAuthClientID.h"

@interface L2PHandler () <WebViewDelegate>


@property(retain) NSURLConnection   *userCodeURLConnection;
@property(retain) NSURLConnection   *tokenURLConnection;
@property(retain) NSURLConnection   *refreshTokenURLConnection;


//device and user code
@property(retain) NSString  *deviceCode;
@property(retain) NSString  *userCode;
@property(retain) NSURL     *verificationURL;
@property(retain) NSNumber  *userCodeExpiresIn;
@property(retain) NSNumber  *requestIntervalInMinutes;

//accesss and refresh token
@property(retain) NSString  *accessToken;
@property(retain) NSNumber  *accessExpiresIn;
@property(retain) NSString  *refreshToken;
@property(retain) NSDate    *lastTokenRequestDate;
@property(retain) NSDate    *accessExpiresAtDate;

@property(retain) UIViewController *viewController;
@property(retain) CalendarFetcher* fetcher;

@end

@implementation L2PHandler

- (id) initWithViewController:(UIViewController*) viewController
{
    if (self = [super init])
    {
        _viewController = viewController;
        _fetcher = [[CalendarFetcher alloc] init];

    }
    
    return self;
}

#pragma mark -
#pragma mark HTTP request utils
-(NSMutableURLRequest *)requestWithURL:(NSString *)urlString
                                  body:(NSString *)bodyString;
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark -
#pragma mark event handlers
-(void) obtainUserCode
{
    NSString *url =
    @"https://oauth.campus.rwth-aachen.de/oauth2waitress/oauth2.svc/code";
    
    NSString *body =
    [NSString stringWithFormat:@"client_id=%s&scope=l2p.rwth userinfo.rwth",
     clientID];
    
    NSMutableURLRequest *userCodeRequest = [self requestWithURL:url body:body];
    self.userCodeURLConnection = [[NSURLConnection alloc]
                                  initWithRequest:userCodeRequest
                                  delegate:self
                                  startImmediately:YES];
}

-(void) obtainAccessToken
{
    NSString *url =
    @"https://oauth.campus.rwth-aachen.de/oauth2waitress/oauth2.svc/token";
    NSString *body =
    [NSString stringWithFormat:@"client_id=%s&code=%@&grant_type=device",
     clientID, self.deviceCode];
    
    NSMutableURLRequest *tokenRequest = [self requestWithURL:url body:body];
    
    self.tokenURLConnection = [[NSURLConnection alloc]
                               initWithRequest:tokenRequest
                               delegate:self
                               startImmediately:YES];
}

-(void) refreshAccessToken
{
    NSString *url =
    @"https://oauth.campus.rwth-aachen.de/oauth2waitress/oauth2.svc/token";
    NSString *body =
    [NSString stringWithFormat:
     @"client_id=%s&refresh_token=%@&grant_type=refresh_token",
     clientID, self.refreshToken];
    
    NSMutableURLRequest *tokenRequest = [self requestWithURL:url body:body];
    self.refreshTokenURLConnection = [[NSURLConnection alloc]
                                      initWithRequest:tokenRequest
                                      delegate:self
                                      startImmediately:YES];
    
}


#pragma mark -
#pragma mark NSURLConnectionDataDelegate
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSError *error = nil;
    NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    if (error)
    {
        NSLog(@"Error: %@", error);
        NSLog(@"Data is: %@", dataDictionary);
    }
    //obtaining user code
    else if (connection == self.userCodeURLConnection)
    {
        [self handleUserCodeResponseDictionary:dataDictionary];
    }
    //obtaining access token
    else if (connection == self.tokenURLConnection || connection == self.refreshTokenURLConnection)
    {
        [self handleAccessTokenResponseDictionary:dataDictionary];
        
        //present api view controller
        if (connection == self.tokenURLConnection)
        {
            self.refreshToken = [dataDictionary objectForKey:@"refresh_token"];
            
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimeTillRefreshLabel:) userInfo:nil repeats:YES];
        }
        
        //[self.apiVC setAccessToken:self.accessToken];
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Received response: %@", response);
}

#pragma mark -
#pragma mark UI helpers
-(void)updateTimeTillRefreshLabel:(NSTimer*)timer
{
    //access token time
    NSInteger currentTimeInterval = [NSDate date].timeIntervalSince1970;
    NSInteger timeIntervalOfNextRequest = self.accessExpiresAtDate.timeIntervalSince1970;
    NSInteger secondsTillNextRequest = timeIntervalOfNextRequest - currentTimeInterval;
    
    //[self.timeTillRefreshLabel setText:[NSString stringWithFormat:@"%is", secondsTillNextRequest]];
}


#pragma mark -
#pragma mark HTTP response handlers
-(void)handleUserCodeResponseDictionary:(NSDictionary*)dict
{
    //save to local variables
    self.deviceCode = [dict objectForKey:@"device_code"];
    self.userCode = [dict objectForKey:@"user_code"];
    self.verificationURL = [NSURL URLWithString:[dict objectForKey:@"verification_url"]];
    self.userCodeExpiresIn = [dict objectForKey:@"expires_in"];
    self.requestIntervalInMinutes = [dict objectForKey:@"interval"];
    
    //[self.userCodeLabel setText:self.userCode];
    
    [self saveUserDefaults];
    
    NSLog(@"user code response: %@", dict);
    
    if (_viewController)
    {
        //present web view
        NSString *pathComponent = [NSString stringWithFormat:@"?q=verify&d=%@", self.userCode];
        NSURL *verficationURLWithCode = [self.verificationURL URLByAppendingPathComponent:pathComponent];
        WebViewController *webVC = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:Nil];
        [_viewController presentViewController:webVC animated:YES completion:nil];
        webVC.delegate = self;
        [webVC setVerificationURL:verficationURLWithCode];
    }
}

-(void)handleAccessTokenResponseDictionary:(NSDictionary*)dict
{
    //test for errors
    NSString *status = [dict objectForKey:@"status"];
    NSRange rangeOfErrorInStatusString = [status rangeOfString:@"error"];
    if (rangeOfErrorInStatusString.location != NSNotFound) {
        NSLog(@"%@", status);
        return;
    }
    
    self.accessToken = [dict objectForKey:@"access_token"];
    self.accessExpiresIn = [dict objectForKey:@"expires_in"];
    
    self.lastTokenRequestDate = [NSDate date];
    self.accessExpiresAtDate = [NSDate dateWithTimeIntervalSinceNow:self.accessExpiresIn.integerValue * 60 - 30];
    
    //[self.accessTokenLabel setText:self.accessToken];
    
    [self saveUserDefaults];
    
    
    
    // After access token is received, fetch course room data from L2P using the fetcher.
    NSLog(@"access token: %@", _accessToken);
    _fetcher.accessToken = _accessToken;
    [_fetcher fetchL2PCourseRooms];
    [_fetcher fetchIphoneEvents];
    
    // Call the delegate method after fetch is complete.
    // FIXME: Currently, the following function is evaluated before fetch is complete since getL2PCourseRooms gets its response later.
    if (_delegate)
        [_delegate userDataWasFetched];
    
}


#pragma mark -
#pragma mark user default helpers
-(void)loadUserDefaults
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.deviceCode = [userDefaults objectForKey:@"deviceCode"];
    self.userCode = [userDefaults objectForKey:@"userCode"];
    if (self.userCode) {
        //[self.userCodeLabel setText:self.userCode];
    }
    self.verificationURL = [userDefaults URLForKey:@"verificationURL"];
    self.userCodeExpiresIn = [userDefaults objectForKey:@"expiresInMinutes"];
    self.requestIntervalInMinutes = [userDefaults objectForKey:@"requestIntervalInMinutes"];
    
    self.accessToken = [userDefaults objectForKey:@"accessToken"];
    if (self.accessToken) {
        //[self.accessTokenLabel setText:self.accessToken];
    }
    self.accessExpiresIn = [userDefaults objectForKey:@"accessExpiresIn"];
    self.refreshToken = [userDefaults objectForKey:@"refreshToken"];
    self.lastTokenRequestDate = [userDefaults objectForKey:@"lastTokenRequestDate"];
    self.accessExpiresAtDate = [userDefaults objectForKey:@"accessExpiresAtDate"];
    if (self.lastTokenRequestDate != nil && self.accessExpiresAtDate != nil) {
        [self updateTimeTillRefreshLabel:nil];
        
    }
}

-(void)saveUserDefaults
{
    /*
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.deviceCode forKey:@"deviceCode"];
    [userDefaults setObject:self.userCode forKey:@"userCode"];
    [userDefaults setURL:self.verificationURL forKey:@"verificationURL"];
    [userDefaults setObject:self.userCodeExpiresIn forKey:@"expiresInMinutes"];
    [userDefaults setObject:self.requestIntervalInMinutes forKey:@"requestIntervalInMinutes"];
    
    [userDefaults setObject:self.accessToken forKey:@"accessToken"];
    [userDefaults setObject:self.accessExpiresIn forKey:@"accessExpiresIn"];
    [userDefaults setObject:self.refreshToken forKey:@"refreshToken"];
    [userDefaults setObject:self.lastTokenRequestDate forKey:@"lastTokenRequestDate"];
    [userDefaults setObject:self.accessExpiresAtDate forKey:@"accessExpiresAtDate"];*/
}

#pragma mark - WebViewDelegate methods

- (void) webViewWasDismissed
{
    [self obtainAccessToken];
    
    
    NSLog(@"test");
    
}

@end
