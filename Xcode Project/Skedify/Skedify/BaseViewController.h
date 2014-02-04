//
//  BaseViewController.h
//  Skedify
//
//  Created by M on 1/24/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ServerConnection.h"

@interface BaseViewController : UIViewController <CLLocationManagerDelegate, ServerConnectionCurrentNotifiableShakableViewDelegate>

-(void)notificationRecieved;
@end
