//
//  PGSideDrawerController.h
// SideDrawerExample
//
//  Created by Pulkit Goyal on 18/09/14.
//  Copyright (c) 2014 Pulkit Goyal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFHCatalogueViewController.h"

@interface PGSideDrawerController : UITableViewController
@property (weak, nonatomic) IBOutlet UIButton *triggerButton;

@property MFHCatalogueViewController *firstViewController;

@end
