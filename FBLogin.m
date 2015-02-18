//
//  FBLogin.m
//  MyFutureHome
//
//  Created by Jeronim Morina on 06.01.15.
//  Copyright (c) 2015 SI2. All rights reserved.
//

#import "FBLogin.h"
#import <RestKit/RestKit.h>
#import "MFHJSONResponseCall.h"
#import "MFHJSONResponseInit.h"
#import "MFHJSONResponseProfile.h"
#import "MFHJSONResponseSettings.h"
#import "MFHJSONResponseUser.h"

@interface FBLogin () <FBLoginViewDelegate>
@end

@interface NSURLRequest(DummyDelegate)
+(BOOL) allowsAnyHTTPSCertificateForHost:(NSString *)host;
+(void) setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString *)host;
@end

@implementation FBLogin

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    FBLoginView *loginView = [[FBLoginView alloc] init];
    // Align the button in the center horizontally
    loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)), self.view.center.y + (loginView.frame.size.height/4));
    [self.view addSubview:loginView];
    loginView.delegate = self;
    [loginView sizeToFit];

}

#pragma mark - FBLoginViewDelegate

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    // first get the buttons set for login mode
    self.fbText.text = @"Hallo Welt";
    
    self.fbToken = @"123451234512345";
    //NSString *urlString = @"https://myfh.storyspot.de/call";
    //NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: urlString]];
    //[NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:@"myfh.storyspot.de"];
    //NSURLResponse *resp = nil;
    //NSError *err = nil;
    //NSData *response = [NSURLConnection sendSynchronousRequest: request returningResponse:&resp error:&err];
    //NSString *responseString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", responseString);

    // do some REST ;)
    [self configureRestKit];
    [self loadREST];

    }

- (void)configureRestKit
{
    // initialize AFNetworking HTTPClient
    NSURL *baseURL = [NSURL URLWithString:@"http://myfh.storyspot.de"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    // initialize RestKit
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    // setup object mappings
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[MFHJSONResponseInit class]];
    [responseMapping addAttributeMappingsFromArray:@[@"state", @"phoneId", @"accessToken"]];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:@"/init"
                                                keyPath:@""
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor:responseDescriptor];
    
    // setup object mappings
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping];// Shortcut for [RKObjectMapping mappingForClass:[NSMutableDictionary class] ]
    [requestMapping addAttributeMappingsFromArray:@[@"phoneId"]];
    
    // register mappings with the provider using a response descriptor
    RKRequestDescriptor *requestDescriptor =
    [RKRequestDescriptor
     requestDescriptorWithMapping:requestMapping
     objectClass:[MFHJSONResponseInit class]
     rootKeyPath:nil
     method:RKRequestMethodAny];
    [objectManager addRequestDescriptor:requestDescriptor];
    
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    [objectManager setRequestSerializationMIMEType:RKMIMETypeFormURLEncoded];
}

- (void)loadREST
{
    MFHJSONResponseInit *test = [MFHJSONResponseInit new];
    test.phoneId = [NSString stringWithFormat:@"%@%i",self.fbToken,arc4random_uniform(74)];
    
    [[RKObjectManager sharedManager] postObject:test path:@"init" parameters:nil//queryParams
                                        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                            NSLog(@"Ballla - Data: %@\tMessage: %@", [test accessToken], [test state]);
                                        }

                                        failure:nil];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
