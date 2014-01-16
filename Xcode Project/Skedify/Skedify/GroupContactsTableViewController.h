//
//  GroupContactsTableViewController.h
//  Skedify
//
//  Created by M on 1/14/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerConnection.h"
@interface GroupContactsTableViewController : UITableViewController<ServerConnectionCurrentNotifiableShakableViewDelegate>
{
   // NSInteger groupIndex;
}

@property (nonatomic) NSInteger groupIndex;
@end
