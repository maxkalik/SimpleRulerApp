//
//  ResultsTableViewDataSource.m
//  SimpleRulerApp
//
//  Created by Maksim Kalik on 2/20/21.
//

#import "ResultsTableViewDataSource.h"

@interface ResultsTableViewDataSource ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation ResultsTableViewDataSource

- (id)initWithTableView:(UITableView*)tableView andData:(NSMutableArray<Result*>*)data {
    self = [super init];
    if (self) {
        self.tableView = tableView;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.data = data;
    }
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 120, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return self;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultTableViewCell"];
    if (cell == nil) {
        cell = [[ResultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ResultTableViewCell"];
    }
    [cell configureCellWithResult:[self.data objectAtIndex:indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64.0;
}

@end
