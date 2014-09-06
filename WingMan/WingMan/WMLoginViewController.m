//
//  WMLoginViewController.m
//  WingMan
//
//  Created by Stephen Chan on 7/27/14.
//  Copyright (c) 2014 TukoApps. All rights reserved.
//

#import "WMLoginViewController.h"

@interface WMLoginViewController ()

@property (weak, nonatomic) IBOutlet FBLoginView *loginView;

@end

@implementation WMLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [self initLoginView];
    self.loginView.delegate = self;
    [super viewDidLoad];
}

-(void)initFBLoginButton
{
    // TODO: determine what permissions are necessary
    self.loginView.readPermissions = @[@"public_profile", @"email", @"user_friends"];
}

-(void)initLoginView
{
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"launch-background.png"]]];
}

-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    NSString *accessToken = [[[FBSession activeSession] accessTokenData] accessToken];
    NSLog(@"%@", accessToken);
    return;
}

-(void)presentHomeView
{
    [[WMUser user] userLoggedIn];
    [self performSegueWithIdentifier:@"login" sender:self];
}

-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    [self presentHomeView];
}

-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    [self initLoginView];
}

@end
