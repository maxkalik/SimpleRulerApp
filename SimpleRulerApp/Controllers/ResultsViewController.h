//
//  ResultsViewController.h
//  SimpleRulerApp
//
//  Created by Maksim Kalik on 2/20/21.
//

#import <UIKit/UIKit.h>
#import "ResultsTableViewDataSource.h"
#import "Result.h"
#import "Helper.h"

NS_ASSUME_NONNULL_BEGIN

@interface ResultsViewController : UIViewController

@property (nonatomic, strong) NSMutableArray<Result*>* results;

@end

NS_ASSUME_NONNULL_END
