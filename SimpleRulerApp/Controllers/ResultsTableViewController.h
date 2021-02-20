//
//  ResultsTableViewController.h
//  SimpleRulerApp
//
//  Created by Maksim Kalik on 2/20/21.
//

#import <UIKit/UIKit.h>
#import "Result.h"

NS_ASSUME_NONNULL_BEGIN

@interface ResultsTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray<Result*>* results;

@end

NS_ASSUME_NONNULL_END
