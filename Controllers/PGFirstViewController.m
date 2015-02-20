//
//  PGFirstViewController.m
// SideDrawerExample
//
//  Created by Pulkit Goyal on 18/09/14.
//  Copyright (c) 2014 Pulkit Goyal. All rights reserved.
//

#import "PGFirstViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"

#import "MFHSession.h"
#import "ALSPage.h"
#import "ALSPageContent.h"
#import "ALSDocumentElement.h"
#import "ALSDocumentElementContent.h"
#import "ALSDocumentElementSubContent.h"
#import "PGSideDrawerController.h"
#import "MFHAdvertCell.h"
#import "MFHSession.h"


@interface PGFirstViewController ()

@end

@implementation PGFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLeftMenuButton];
    
//    [self createProduct ];
    
}

-(void) createProduct
{
    //Get first pageContent and draw uiControls
    ALSPage *page =   [[[MFHSession getALSResponse] pages ]objectAtIndex:0];
    if ([MFHSession getAdverts])
        [[MFHSession getAdverts] removeAllObjects];
    else
        [MFHSession setAdverts];
    
    // watch out for all
    for (ALSPageContent *content in [page contents])
    {
        MFHAdvert *advert = [[MFHAdvert alloc ]init];
        advert.posX = content.position.x;
        advert.posY = content.position.y;
        advert.width = content.position.width;
        advert.height = content.position.height;
        
        for (ALSDocumentElement* element in content.documentElements)
        {
            if([[element elementType] isEqualToString:@"headline"])
            {
                if ([[element elementClass] isEqualToString:@"headline"])
                    advert.name = [element.text stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
                if ([[element elementClass] isEqualToString:@"subheadline"])
                    advert.desc = element.text;
            }
            if([[element elementClass] isEqualToString:@"image"])
            {
                for (ALSDocumentElementContent* contentElement in element.contents)
                {
                    if([[contentElement url] isEqualToString:@"link"])
                    {
                        advert.imageUrl = [contentElement.url stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
                    }
                }
            }
        }
        // add advert to our array
        [[MFHSession getAdverts] addObject:advert];
    }
    NSLog(@"No.Adverts: %i", [MFHSession getAdverts].count);
}

- (void)setupLeftMenuButton {
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton];
}

- (void)leftDrawerButtonPress:(id)leftDrawerButtonPress {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *) view
{
    return [MFHSession getAdverts].count;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)view
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MFHAdvertCell *cell = [view
                                  dequeueReusableCellWithReuseIdentifier:@"ProductCell"
                                  forIndexPath:indexPath];
    if ([MFHSession getAdverts].count > 0)
    {
        MFHAdvert *advert = [[MFHSession getAdverts] objectAtIndex:indexPath.section];
        [cell.advertLabel setText:advert.name];
        NSURL *test = [NSURL URLWithString:advert.imageUrl];
        [cell.advertPicture setImageWithURL:test];
        
    }
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
