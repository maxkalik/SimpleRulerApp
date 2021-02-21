//
//  ResultTableViewCell.m
//  SimpleRulerApp
//
//  Created by Maksim Kalik on 2/20/21.
//

#import "ResultTableViewCell.h"

@interface ResultTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *inchesLabel;
@property (weak, nonatomic) IBOutlet UILabel *centimetersLabel;


@end

@implementation ResultTableViewCell

- (void)configureCellWithResult:(Result*)result {
    self.centimetersLabel.text = [NSString stringWithFormat:@"%.2f cm", result.centimeters];
    self.inchesLabel.text = [NSString stringWithFormat:@"%.2f in", result.inches];
}

@end
