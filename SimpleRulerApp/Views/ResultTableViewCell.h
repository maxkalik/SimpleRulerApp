//
//  ResultTableViewCell.h
//  SimpleRulerApp
//
//  Created by Maksim Kalik on 2/20/21.
//

#import <UIKit/UIKit.h>
#import "Result.h"

NS_ASSUME_NONNULL_BEGIN

@interface ResultTableViewCell : UITableViewCell

- (void)configureCellWithResult:(Result*)result;

@end

NS_ASSUME_NONNULL_END
