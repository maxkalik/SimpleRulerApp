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

@property (weak, nonatomic) IBOutlet UILabel *overallInchesLabel;
@property (weak, nonatomic) IBOutlet UILabel *overallCentimetersLabel;


@end

@implementation ResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.resultsTableViewDataSource = [[ResultsTableViewDataSource alloc] initWithTableView:self.resultsTableView andData:self.results];
    [self setupOverall];
}

- (void)setupOverall {
    Result *overallResult = [Helper.sharedInstance sumOfResults:self.results];
    NSString* inchesStr = [Helper.sharedInstance convertToStringResultMeasurement:overallResult.inches];
    NSString* centimetersStr = [Helper.sharedInstance convertToStringResultMeasurement:overallResult.centimeters];
    self.overallInchesLabel.text = [NSString stringWithFormat:@"%@ in", inchesStr];
    self.overallCentimetersLabel.text = [NSString stringWithFormat:@"%@ cm", centimetersStr];
}

@end
