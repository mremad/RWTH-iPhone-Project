//
//  WebViewController.h
//  L2PAPI
//
//  Created by Aaron Krämer on 11/29/13.
//  Copyright (c) 2013 Aaron Krämer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WebViewDelegate <NSObject>

- (void) webViewWasDismissed;

@end

@interface WebViewController : UIViewController <UIWebViewDelegate>

@property(weak) id<WebViewDelegate> delegate;

-(void)setVerificationURL:(NSURL*)url;

@end
