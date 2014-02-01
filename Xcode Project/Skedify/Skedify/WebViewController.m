//
//  WebViewController.m
//  L2PAPI
//
//  Created by Aaron Krämer on 11/29/13.
//  Copyright (c) 2013 Aaron Krämer. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [(UIWebView*)self.view setDelegate:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setVerificationURL:(NSURL *)url
{
    NSURLRequest *verificationRequest = [NSURLRequest requestWithURL:url];
    
    [(UIWebView*)self.view loadRequest:verificationRequest];
}

#pragma mark WebViewDelegate

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *url = [webView.request.URL absoluteString];
    NSRange rangeOfString = [url rangeOfString:@"q=authorized"];
    
    if (rangeOfString.location != NSNotFound) {
        [self dismissViewControllerAnimated:NO completion:^{
            if (_delegate)
                [_delegate webViewWasDismissed];
        }];
    }
}

@end
