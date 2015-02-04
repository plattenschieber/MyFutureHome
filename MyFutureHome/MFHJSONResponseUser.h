//
//  MFHJSONResponseUser.h
//  MyFutureHome
//
//  Created by Jeronim Morina on 04.02.15.
//  Copyright (c) 2015 SI2. All rights reserved.
//

#import "MFHJSONResponse.h"

@interface MFHJSONResponseUser : MFHJSONResponse
@property (nonatomic,strong) NSString *phoneId;
@property (nonatomic,strong) NSDictionary *userData;
@end
