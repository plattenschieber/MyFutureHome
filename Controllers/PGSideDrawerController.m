//
//  PGSideDrawerController.m
// SideDrawerExample
//
//  Created by Pulkit Goyal on 18/09/14.
//  Copyright (c) 2014 Pulkit Goyal. All rights reserved.
//

#import "PGSideDrawerController.h"
#import "UIViewController+MMDrawerController.h"

@interface PGSideDrawerController ()

@property(nonatomic) int currentIndex;
@property NSArray *viewControllerIdentifiers;
@end

@implementation PGSideDrawerController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.firstViewController = [[MFHCatalogueViewController alloc] init];
    self.currentIndex = 0;
    self.viewControllerIdentifiers = @[@"CATALOGUE_VIEW_CONTROLLER", @"LAST_WATCHED_VIEW_CONTROLLER", @"FAVOURITES_VIEW_CONTROLLER", @"PROFILE_VIEW_CONTROLLER", @"CREATE_PROFILE_VIEW_CONTROLLER", @"MANAGE_PROFILES_VIEW_CONTROLLER", @"HELP_VIEW_CONTROLLER"];
}


#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currentIndex == indexPath.row) {
        [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
        return;
    }
    
    if (indexPath.row == self.viewControllerIdentifiers.count)
    {
        NSLog(@"Close App.");
        exit(0);
    }

    UIViewController *centerViewController = [self.storyboard instantiateViewControllerWithIdentifier:[self.viewControllerIdentifiers objectAtIndex:indexPath.row]];

    if (centerViewController) {
        self.currentIndex = indexPath.row;
        [self.mm_drawerController setCenterViewController:centerViewController withCloseAnimation:YES completion:nil];
    } else {
        [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
    }
}

@end
