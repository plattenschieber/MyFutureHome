//
//  MFHAdvertFlowLayout.m
//  MyFutureHome
//
//  Created by Jeronim Morina on 21.02.15.
//  Copyright (c) 2015 SI2. All rights reserved.
//

#import "MFHAdvertFlowLayout.h"
#import "MFHAdvert.h"
#import "MFHSession.h"

@implementation MFHAdvertFlowLayout

-(id)init
{
    if (!(self = [super init])) return nil;
    
    self.itemSize = CGSizeMake(150, 150);
    self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.minimumInteritemSpacing = 0.0f;
    self.minimumLineSpacing = 0.0f;
    
    return self;
}


- (UICollectionViewLayoutAttributes *) layoutAttributesForItemAtIndexPath: (NSIndexPath *) indexPath
{
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    MFHAdvert *advert = [[MFHSession getAdverts] objectAtIndex:indexPath.row];
    layoutAttributes.frame = CGRectMake(advert.posX, advert.posY, advert.width, advert.height);
    return layoutAttributes;
}

- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *layoutAttributes = [super layoutAttributesForElementsInRect:rect];
    for (int i=0; i<[MFHSession getAdverts].count; i++)
    {
        MFHAdvert *advert = [[MFHSession getAdverts] objectAtIndex:i];
        ((UICollectionViewLayoutAttributes *)[layoutAttributes objectAtIndex:i]).frame = CGRectMake(advert.posX, advert.posY, advert.width, advert.height);
    }
    return  layoutAttributes;
}
@end
