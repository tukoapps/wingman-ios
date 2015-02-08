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
@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@property BOOL noInternetWarningShown;
@property (strong, nonatomic) NSDate *lastInternetWarningShown;
@property (strong, nonatomic) NSDate *lastBarUpdate;

@end

@implementation WMHomeTableViewController

typedef void(^connection)(BOOL);

-(void)getImageForCell:(WMBarCellView *)cell url:(NSURL *)url row:(int)row
{
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            if (row == 0) {
                [((WMTopBarCellView *)cell) setLogoImage:[UIImage imageWithData:data]];
                return;
            }
            [cell setLogoImage:[UIImage imageWithData:data]];
        }
    }];
}

-(void)getImageForTopBarCell:(WMBarCellView *)cell url:(NSURL *)url row:(int)row
{
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            [((WMTopBarCellView *)cell) setBackgroundImage:[UIImage imageWithData:data]];
            return;
        }
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // custom initialization
    [self initSideBar];
    [self initSpinner];
    [self initRefreshControl];
    [self initCustomCells];
    self.barInfo = [[NSArray alloc] init];
    [self addNotificationObservers];
    self.lastBarUpdate = [NSDate dateWithTimeIntervalSince1970:0];
   
    // Initial check: may have just closed the app, but user info is still valid
    if ([[WMUser user] uniqueId] && [[WMUser user] lat] && [[WMUser user] lon]) {
        [self fetchBars];
    }
}

-(void)initRefreshControl
{
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(fetchBars) forControlEvents:UIControlEventValueChanged];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([[WMUser user] uniqueId] && [[WMUser user] lat] && [[WMUser user] lon]) {
        [self fetchBars];
    }
    [self checkInternet:^(BOOL isConnected) {
        if (isConnected) {
            return;
        } else {
            if (!self.noInternetWarningShown) {
                [[[UIAlertView alloc] initWithTitle:@"No Connection" message:@"Please check your Internet connection and try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                self.noInternetWarningShown = YES;
            }
            [self.spinner removeFromSuperview];
            return;
        }
    }];
}

- (void)checkInternet:(connection)block
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSURL *url = [NSURL URLWithString:@"http://www.google.com/"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"HEAD";
    request.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    request.timeoutInterval = 10.0;
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         block([(NSHTTPURLResponse *)response statusCode] == 200);
     }];
}

-(void)addNotificationObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchBars) name:@"WMUserUpdatedLocation" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activateSideBar) name:@"WMUserFetchedUser" object:nil];
}

-(void)initCustomCells
{
    [self.tableView registerNib:[UINib nibWithNibName:@"WMBarCell" bundle:nil] forCellReuseIdentifier:@"bar_cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WMTopBarCell" bundle:nil] forCellReuseIdentifier:@"top_bar_cell"];
}

-(void)initSpinner
{
    // show activity spinner
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.center = CGPointMake(self.view.frame.size.width / 2.0, (self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height) / 2.0);
    [self.spinner startAnimating];
    [self.tableView addSubview:self.spinner];
}

-(void)fetchBarImages
{
    for (int i = 0; i < [self.barInfo count]; i++) {
        WMBar *bar = [self.barInfo objectAtIndex:i];
        NSURLRequest *logoUrlRequest = [NSURLRequest requestWithURL:bar.logoUrl];
        [NSURLConnection sendAsynchronousRequest:logoUrlRequest queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (!connectionError) {
                [bar setBarLogo:[UIImage imageWithData:data]];
            }
        }];
        NSURLRequest *imageUrlRequest = [NSURLRequest requestWithURL:bar.imageUrl];
        [NSURLConnection sendAsynchronousRequest:imageUrlRequest queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (!connectionError) {
                [bar setBarImage:[UIImage imageWithData:data]];
                if (i == [self.barInfo count] - 1) {
                    [self.tableView reloadData];
                }
            }
        }];       
    }
}

- (void)fetchBars {
    if ([[NSDate dateWithTimeInterval:120 sinceDate:self.lastBarUpdate] compare:[NSDate date]] == NSOrderedAscending || [self.refreshControl isRefreshing]) {
        [self checkInternet:^(BOOL isConnected) {
            if (isConnected) {
                WMUser *user = [WMUser user];
                NSString *accessToken = [[[FBSession activeSession] accessTokenData] accessToken];
                if (accessToken) {
                    [user userLoggedIn];
                }
                if (user && user.lat && user.lon && user.uniqueId) {
                    NSDictionary *requestParams = @{@"user_id" :user.uniqueId, @"lat" : user.lat, @"lon" : user.lon};
                    
                    [[RKObjectManager sharedManager] getObjectsAtPath:@"/api/v1/bars" parameters:requestParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
                        [self.spinner removeFromSuperview];
                        [self.refreshControl endRefreshing];
                        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
                        if ([self.barInfo count] == 0 || ![[NSSet setWithArray:self.barInfo] isEqual:[NSSet setWithArray:mappingResult.array]]) {
                            self.barInfo = mappingResult.array;
                            [self fetchBarImages];
                            
                            // reset update timer
                            self.lastBarUpdate = [NSDate date];
                            [[WMRestKitManager sharedManager] updateUserLocation];
                            // before loading, tableview's separators are removed since the cells resize
                        }
                    }
                                                              failure:^(RKObjectRequestOperation *operation, NSError *error){
                                                                  NSLog(@"%@", error);
                                                              }];
                }
            } else {
                if (!self.noInternetWarningShown) {
                    [[[UIAlertView alloc] initWithTitle:@"No Connection" message:@"Please check your Internet connection and try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                    self.noInternetWarningShown = YES;
                }
                if ([self.tableView.subviews containsObject:self.spinner]) {
                    [self.spinner removeFromSuperview];
                }
                [self.refreshControl endRefreshing];
                return;
            }
        }];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"bar_detail" sender:indexPath];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"bar_detail"]) {
        WMBarDetailViewController *barDetailController = (WMBarDetailViewController *)[segue destinationViewController];
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        WMBar *bar = [self.barInfo objectAtIndex:indexPath.row];
        barDetailController.bar = bar;
        WMBarCellView *barCell = (WMBarCellView *)[self.tableView cellForRowAtIndexPath:indexPath];
        barDetailController.barLogo = [barCell getImage];
    }
}

-(void)initSideBar
{
    self.sideBarButton.target = self.revealViewController;
    self.sideBarButton.action = @selector(revealToggle:);
    WMSideBarTableViewController *sideBar = (WMSideBarTableViewController *)self.revealViewController.rearViewController;
    sideBar.delegate = self;
    if (self.sideBarButton.enabled) {
        self.sideBarButton.enabled = NO;
        [self.view removeGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

-(void)activateSideBar
{
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.sideBarButton.enabled = YES;
}

-(void)WMSideBarWillAppear
{
    self.tableView.scrollEnabled = NO;
    self.tableView.allowsSelection = NO;
}

-(void)WMSideBarWillDisappear
{
    self.tableView.scrollEnabled = YES;
    self.tableView.allowsSelection = YES;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: externalize table cell row height
    if (indexPath.row == 0) {
        return 120.0;
    }
    return 90.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMBar *bar = [self.barInfo objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        WMTopBarCellView *cell = (WMTopBarCellView *)[tableView dequeueReusableCellWithIdentifier:@"top_bar_cell"];
        [cell setDataWithInfo:bar];
        [cell setBackgroundImage:bar.barImage];
        return cell;
    }
    WMBarCellView *cell = (WMBarCellView *)[tableView dequeueReusableCellWithIdentifier:@"bar_cell"];
    [cell setDataWithInfo:bar];
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(WMBarCellView *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.barInfo count] > 0) {
        if (indexPath.row == 0) {
            //[self getImageForTopBarCell:cell url:bar.imageUrl row:indexPath.row];
        }
        //[self getImageForCell:cell url:bar.logoUrl row:indexPath.row];
    }
}

@end
