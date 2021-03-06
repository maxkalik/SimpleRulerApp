//
//  ResultsTableViewDataSource.h
//  SimpleRulerApp
//
//  Created by Maksim Kalik on 2/20/21.
//

#import <UIKit/UIKit.h>
#import "ResultTableViewCell.h"
#import "Result.h"

NS_ASSUME_NONNULL_BEGIN

@interface ResultsTableViewDataSource : UITableView

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray<Result*> *data;

- (id)initWithTableView:(UITableView*)tableView andData:(NSArray<Result*>*)data;

@end

NS_ASSUME_NONNULL_END
