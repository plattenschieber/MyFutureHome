//
//  MFHJSONResponse.h
//  MyFutureHome
//
//  Created by Jeronim Morina on 04.02.15.
//  Copyright (c) 2015 SI2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MFHJSONResponse : NSObject

@property NSString* phoneId;
@property NSString* accessToken;
@property (nonatomic,strong) NSString *state;
@property (nonatomic,strong) NSString *errors;
@property (nonatomic,strong) NSString *warnings;
@end
