//
//  WMHomeTableViewController.m
//  WingMan
//
//  Created by Stephen Chan on 7/27/14.
//  Copyright (c) 2014 TukoApps. All rights reserved.
//

#import "WMHomeTableViewController.h"

@interface WMHomeTableViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarButton;
@property (strong, nonatomic) NSArray *barInfo;
@property (strong, nonatomic) WMNetworkManager *networkManager;

@end

@implementation WMHomeTableViewController

-(void)NetworkManagerDidReturnInfo:(NSArray *)barInfo error:(NSError *)error
{
    if (error != nil) {
        if ([error.domain isEqualToString:NSURLErrorDomain]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Wingman is having trouble connecting to the internet right now. Please try to connect again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }
    _barInfo = barInfo;
    [self.tableView reloadData];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

-(UIImage *)getImageForCell:(WMBarCellView *)cell url:(NSString *)url
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [cell setLogoImage:[UIImage imageWithData:data]];
    }];
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initSideBar];
    _barInfo = [[NSArray alloc] init];
    NSLog(@"%@", [[FBSession activeSession] accessTokenData]);
    [self initNetworkManager];
    [self.tableView registerNib:[UINib nibWithNibName:@"WMBarCell" bundle:nil] forCellReuseIdentifier:@"barCell"];
}

-(void)initSideBar
{
    self.sideBarButton.target = self.revealViewController;
    self.sideBarButton.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

-(void)initNetworkManager
{
    self.networkManager = [[WMNetworkManager alloc] init];
    self.networkManager.delegate = self;
    [self.networkManager requestAllBars:@"10152715211682573"];
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
    return [self.barInfo count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMBarCellView *cell = [tableView dequeueReusableCellWithIdentifier:@"barCell" forIndexPath:indexPath];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(WMBarCellView *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.barInfo count] > 0) {
        WMBarInfo *barInfo = [self.barInfo objectAtIndex:indexPath.row];
        [self getImageForCell:cell url:barInfo.logoUrl];
        [cell setDataWithInfo:barInfo];
    }
}

@end
