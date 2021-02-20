//
//  ResultsTableViewController.m
//  SimpleRulerApp
//
//  Created by Maksim Kalik on 2/20/21.
//

#import "ResultsTableViewController.h"

@implementation ResultsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"table view controller: %@", self.results);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
// #warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
// #warning Incomplete implementation, return the number of rows
    return 0;
}

@end
