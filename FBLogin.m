//
//  FBLogin.m
//  MyFutureHome
//
//  Created by Jeronim Morina on 06.01.15.
//  Copyright (c) 2015 SI2. All rights reserved.
//

#import "FBLogin.h"
#import "MFHDataHandler.h"

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
    // HERE WE CAN DO SOME STUFF WITH A LOGGED IN FB USER
    MFHDataHandler *dataHandler = [MFHDataHandler init];
    [dataHandler registerUser:@"SUPERGEILESTOKEN"];
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
