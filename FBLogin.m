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
    NSURL *baseURL = [NSURL URLWithString:@"https://mfh.storyspot.de"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    // initialize RestKit
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    // setup object mappings
    RKObjectMapping *initMapping = [RKObjectMapping mappingForClass:[MFHJSONResponseInit class]];
    [initMapping addAttributeMappingsFromArray:@[@"state"]];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:initMapping
                                                 method:RKRequestMethodPOST
                                            pathPattern:@"/init"
                                                keyPath:@""
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor:responseDescriptor];
}

- (void)loadREST
{    
    NSDictionary *queryParams = @{@"phoneId" : self.fbToken};
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/init"
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  NSLog(@"%@",mappingResult.array[0]);
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"What do you mean by 'there is no coffee?': %@", error);
                                              }];
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
