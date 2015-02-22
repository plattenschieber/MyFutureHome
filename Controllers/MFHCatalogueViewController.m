//
//  PGFirstViewController.m
// SideDrawerExample
//
//  Created by Pulkit Goyal on 18/09/14.
//  Copyright (c) 2014 Pulkit Goyal. All rights reserved.
//

#import "MFHCatalogueViewController.h"
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
#import "MFHAdvertFlowLayout.h"


@interface MFHCatalogueViewController ()

@property (nonatomic, strong) MFHAdvertFlowLayout *mfhlayout;

@end

static NSString *ItemIdentifier = @"ProductCell";

@implementation MFHCatalogueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLeftMenuButton];
    
    if([MFHSession isDataThere])[self createCatalogue];
    
}

- (void) loadView
{
    self.mfhlayout = [[MFHAdvertFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.mfhlayout];
    [self.collectionView registerClass:[MFHAdvertCell class] forCellWithReuseIdentifier:ItemIdentifier];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

-(void) createCatalogue
{
    
    //Get first pageContent and draw uiControls
    ALSPage *page =   [[[MFHSession getALSResponse] pages ]objectAtIndex:0];
    if ([MFHSession getAdverts])
        [[MFHSession getAdverts] removeAllObjects];
    else
        [MFHSession setAdverts];
    
    for (ALSPageContent *product in [page contents])
    {
        [self createProduct: product];
    }
    
    NSLog(@"No.Adverts: %i", [MFHSession getAdverts].count);
}

-(void) createProduct: (ALSPageContent*) content
{
    // watch out for all
    
        MFHAdvert *advert = [[MFHAdvert alloc ]init];
        advert.posX = content.position.x;
        advert.posY = content.position.y;
        advert.width = content.position.width;
        advert.height = content.position.height;
    
    
        for (ALSDocumentElement* element in [content documentElements])
        {
            if([[element elementType] isEqualToString:@"headline"])
            {
                if ([[element elementClass] isEqualToString:@"headline"])
                {
                    NSString *tmpResult = [element.text stringByReplacingOccurrencesOfString:@"+" withString:@" "];
                    advert.name = [tmpResult stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                }
            }
            if([[element elementClass] isEqualToString:@"image"])
            {
                for (ALSDocumentElementContent* contentElement in element.contents)
                {
                    if([[contentElement elementClass] isEqualToString:@"link"])
                    {
                        advert.linkUrl = contentElement.url;
                    }
                    for (ALSDocumentElementSubContent* subContentElement in contentElement.contents)
                    {
                        if ([[subContentElement elementClass] isEqualToString:@"image"])
                        {
                            advert.imageUrl = subContentElement.url;
                            NSString* style = subContentElement.style;
                            NSRegularExpression *findWidthHeight = [NSRegularExpression regularExpressionWithPattern:@"(\\d+)" options:NSRegularExpressionCaseInsensitive error:nil];
                            
                            NSArray *matches= [findWidthHeight matchesInString:style options:0 range:NSMakeRange(0, [style length])];
                            advert.imageWidth = [[style substringWithRange:[matches[0] range]] intValue];
                            advert.imageHeight = [[style substringWithRange:[matches[1] range]] intValue];
                        }
                    }
                }
            }
        }
        // add advert to our array
        [[MFHSession getAdverts] addObject:advert];
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
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return [MFHSession getAdverts].count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)view
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MFHAdvertCell *cell = [view
                                  dequeueReusableCellWithReuseIdentifier:ItemIdentifier
                                  forIndexPath:indexPath];
    if ([MFHSession getAdverts].count > 0)
    {
        // add a label
        MFHAdvert *advert = [[MFHSession getAdverts] objectAtIndex:indexPath.row];
        cell.advertLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, advert.width, 50.0)];
        [cell.advertLabel setText:advert.name];
        cell.advertLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.advertLabel.numberOfLines = 2;
        cell.advertLabel.font = [UIFont systemFontOfSize:12.0];
        
        [cell.contentView addSubview:cell.advertLabel];
        // add a picture
        cell.advertPicture = [[UIImageView alloc] init];
        NSData *data = [NSData dataWithContentsOfURL:advert.imageUrl];
        cell.advertPicture = [[UIImageView alloc] initWithImage:[[UIImage alloc] initWithData:data]];
        // move the picture a bit down
        cell.advertPicture.frame = CGRectMake(0, 50, .75*advert.imageWidth, .75*advert.imageHeight);
        [cell.contentView addSubview:cell.advertPicture];
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
