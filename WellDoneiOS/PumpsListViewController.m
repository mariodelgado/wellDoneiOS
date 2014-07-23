//
//  PumpsListViewController.m
//  WellDoneListMap
//
//  Created by Aparna Jain on 7/6/14.
//  Copyright (c) 2014 FOX. All rights reserved.
//

#import "PumpsListViewController.h"
#import "PumpTableViewCell.h"
#import "PumpsMapViewController.h"
#import "PumpMapViewController.h"

@interface PumpsListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)NSArray *pumps;
@end

@implementation PumpsListViewController{
    PumpTableViewCell *_stubCell;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self loadPumps];
    UINib *cellNib = [UINib nibWithNibName:@"PumpTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"PumpTableViewCell"];
    _stubCell = [cellNib instantiateWithOwner:nil options:nil][0];
    
    UIBarButtonItem *mapsButton = [[UIBarButtonItem alloc] initWithTitle:@"Maps" style:UIBarButtonItemStyleDone target:self action:@selector(onMapsButtonClick)];
    [mapsButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = mapsButton;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0 / 255.0 green:171.0 / 255.0 blue:243.0 / 255.0 alpha:0.6];
    
    UIImage* logoImage = [UIImage imageNamed:@"navBarHeader"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:logoImage];


}
- (void) loadPumps {
    PFQuery *queryForReports = [Pump query];
    [queryForReports findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.pumps = objects;
            [self.tableView reloadData];
        } else {
            
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}
- (void) onMapsButtonClick {
    PumpMapViewController *vc = [[PumpMapViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    nvc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:nvc animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.pumps count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PumpTableViewCell *pumpCell = [tableView dequeueReusableCellWithIdentifier:@"PumpTableViewCell" forIndexPath:indexPath];
    Pump *pump = self.pumps[indexPath.row];
    pumpCell.pump = pump;
//    pumpCell.textLabel.text = pump.name;
    return pumpCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PumpMapViewController *vc = [[PumpMapViewController alloc] init];
//    vc.pump = self.pumps[indexPath.row];
    vc.pumps = self.pumps;
    vc.index = indexPath.row;
    [self.navigationController pushViewController:vc animated:YES];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = [_stubCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height+1;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130.f;
}
@end
