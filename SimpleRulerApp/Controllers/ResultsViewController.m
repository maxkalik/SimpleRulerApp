//
//  ResultsViewController.m
//  SimpleRulerApp
//
//  Created by Maksim Kalik on 2/20/21.
//

#import "ResultsViewController.h"

@interface ResultsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *resultsTableView;
@property (strong, nonatomic, nullable) ResultsTableViewDataSource *resultsTableViewDataSource;

@end

@implementation ResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.resultsTableViewDataSource = [[ResultsTableViewDataSource alloc] initWithTableView:self.resultsTableView andData:self.results];
}

@end
