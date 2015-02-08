//
//  WMSideBarTableViewController.m
//  WingMan
//
//  Created by Stephen Chan on 7/27/14.
//  Copyright (c) 2014 TukoApps. All rights reserved.
//

#import "WMAppDelegate.h"
#import "WMSideBarTableViewController.h"

@interface WMSideBarTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *userName;

@end

@implementation WMSideBarTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (IBAction)logOutButtonPressed:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Logged in as %@ %@", [[WMUser user] firstName], [[WMUser user] lastName]] delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Log out" otherButtonTitles:nil];
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    int CANCEL_BUTTON = 1;
    if (buttonIndex == CANCEL_BUTTON) {
        return;
    }
    WMAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    [delegate didLogOut];
}

- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserInfo) name:@"WMUserFetchedUser" object:nil];
    if ([[WMUser user] uniqueId] && [[WMUser user] firstName] && [[WMUser user] lastName]) {
        [self updateUserInfo];
    }
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.delegate WMSideBarWillAppear];
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.delegate WMSideBarWillDisappear];
    [super viewWillDisappear:animated];
}

-(void)updateUserInfo
{
    self.userName.text = [NSString stringWithFormat:@"%@ %@", [WMUser user].firstName, [WMUser user].lastName];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        [self logOutButtonPressed:nil];
    }
}

@end
