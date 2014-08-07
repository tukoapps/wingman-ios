//
//  WMLoginViewController.m
//  WingMan
//
//  Created by Stephen Chan on 7/27/14.
//  Copyright (c) 2014 TukoApps. All rights reserved.
//

#import "WMLoginViewController.h"
#import "WMHomeTableViewController.h"

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
    [super viewDidLoad];
    [self initLoginView];
    self.loginView.delegate = self;
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

-(void)presentHomeView
{
    WMHomeTableViewController *homeViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeController"];
    [self presentViewController:homeViewController animated:NO completion:nil];
}

-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    [self presentHomeView];
}

-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    [self initLoginView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
