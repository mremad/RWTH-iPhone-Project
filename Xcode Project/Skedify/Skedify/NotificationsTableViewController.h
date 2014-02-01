//
//  NotificationsTableViewController.h
//  Skedify
//
//  Created by Mariam Abouelfadl on 1/31/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import "BaseTableViewController.h"

@interface NotificationsTableViewController : BaseTableViewController<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
- (IBAction)cancelButtonTapped:(id)sender;

@end
