//
//  STTableViewCell.m
//  SaltsideTest
//
//  Created by Luv Singh on 02/12/15.
//  Copyright (c) 2015 Luv Singh. All rights reserved.
//

#import "STTableViewCell.h"

@interface STTableViewCell ()

@property (nonatomic, strong) IBOutlet UIView *container;

@end

@implementation STTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.container.layer.cornerRadius = 4.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
