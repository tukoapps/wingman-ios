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

@end

@implementation WMHomeTableViewController

-(UIImage *)getImageForCell:(WMBarCellView *)cell url:(NSURL *)url row:(int)row
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
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initSideBar];
    [self initSpinner];
    self.barInfo = [[NSArray alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:@"WMBarCell" bundle:nil] forCellReuseIdentifier:@"bar_cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"WMTopBarCell" bundle:nil] forCellReuseIdentifier:@"top_bar_cell"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchBars) name:@"WMUserUpdatedLocation" object:nil];
    if ([[WMUser user] uniqueId] && [[WMUser user] lat] && [[WMUser user] lon]) {
        [self fetchBars];
    }
}

-(void)initSpinner
{
    // show activity spinner
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.center = CGPointMake(self.view.frame.size.width / 2.0, (self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height) / 2.0);
    [self.spinner startAnimating];
    [self.tableView addSubview:self.spinner];
}

- (void)fetchBars {
    WMUser *user = [WMUser user];
    NSDictionary *requestParams = @{@"user_id" :user.uniqueId, @"lat" : user.lat, @"lon" : user.lon};
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/api/v1/bars" parameters:requestParams success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
            self.barInfo = mappingResult.array;
            [self.spinner removeFromSuperview];
            [self.tableView reloadData];
        }
        failure:^(RKObjectRequestOperation *operation, NSError *error){
            NSLog(@"%@", error);
        }];

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
        barDetailController.barImage = [barCell getImage];
    }
}

-(void)initSideBar
{
    self.sideBarButton.target = self.revealViewController;
    self.sideBarButton.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
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
    if (indexPath.row == 0) {
        WMTopBarCellView *cell = (WMTopBarCellView *)[tableView dequeueReusableCellWithIdentifier:@"top_bar_cell"];
        return cell;
    }
    WMBarCellView *cell = (WMBarCellView *)[tableView dequeueReusableCellWithIdentifier:@"bar_cell"];
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(WMBarCellView *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.barInfo count] > 0) {
        WMBar *bar = [self.barInfo objectAtIndex:indexPath.row];
        [self getImageForCell:cell url:bar.logoUrl row:indexPath.row];
        [cell setDataWithInfo:bar];
    }
}

@end
