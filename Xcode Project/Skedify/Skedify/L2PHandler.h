//
//  L2PHandler.h
//  Skedify
//
//  Created by Yigit Gunay on 1/19/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

@protocol L2PHandlerDelegate <NSObject>

- (void) userDataWasFetched;

@end

#import <Foundation/Foundation.h>

@interface L2PHandler : NSObject <NSURLConnectionDataDelegate>

@property(weak) id<L2PHandlerDelegate> delegate;

- (id) initWithViewController:(UIViewController*) viewController;
-(void) obtainUserCode;

@end
