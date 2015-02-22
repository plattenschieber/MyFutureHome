//
//  MFHAdvert.h
//  MyFutureHome
//
//  Created by Jeronim Morina on 18.02.15.
//  Copyright (c) 2015 SI2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFHJSONResponse.h"

@interface MFHAdvert : MFHJSONResponse

@property NSString *advertId;
@property NSString *externId;
@property NSString *name;
@property NSString *desc;
@property NSString *postalCode;
@property NSString *price;
@property NSString *balcony;
@property NSString *size;
@property NSString *type;
@property NSString *rooms;
@property NSURL *imageUrl;
@property NSURL *linkUrl;
@property NSString *lat;
@property NSString *lng;
@property NSString *created;

@property int height;
@property int width;
@property int posX;
@property int posY;

@end
