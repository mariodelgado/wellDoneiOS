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

@interface PumpsListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
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
    
    UINib *cellNib = [UINib nibWithNibName:@"PumpTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"PumpTableViewCell"];
    _stubCell = [cellNib instantiateWithOwner:nil options:nil][0];
    
    UIBarButtonItem *mapsButton = [[UIBarButtonItem alloc] initWithTitle:@"Maps" style:UIBarButtonItemStyleDone target:self action:@selector(onMapsButtonClick)];
    [mapsButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = mapsButton;


}
- (void) onMapsButtonClick {
    PumpsMapViewController *vc = [[PumpsMapViewController alloc] init];
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
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PumpTableViewCell *pumpCell = [tableView dequeueReusableCellWithIdentifier:@"PumpTableViewCell" forIndexPath:indexPath];
    return pumpCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = [_stubCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height+1;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130.f;
}
@end
