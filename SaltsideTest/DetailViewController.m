//
//  DetailViewController.m
//  SaltsideTest
//
//  Created by Luv Singh on 02/12/15.
//  Copyright (c) 2015 Luv Singh. All rights reserved.
//

#import "DetailViewController.h"
#import "STItemObject.h"
#import "STImageView.h"

#define SHOULD_SET_ORIGINAL_IMAGE_SIZE 1

@interface DetailViewController ()

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *contentView;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *scrollContentHeightConstraint;

@property (nonatomic, strong) STImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        NSString *imageURLString = nil;
        if ([self.detailItem isKindOfClass:[STItemObject class]]) {
            imageURLString = [self.detailItem imageURLString];
            self.titleLabel.text = [self.detailItem title];
            self.descriptionLabel.text = [self.detailItem itemDescription];
        } else if ([self.detailItem isKindOfClass:[NSDictionary class]]) {
            self.titleLabel.text = self.detailItem[kTitle];
            self.descriptionLabel.text = self.detailItem[kDescription];
            imageURLString = self.detailItem[kImageURL];
        }
        
        __weak typeof(self) weakSelf = self;
        [self.imageView setImageWithURLString:imageURLString placeholderImage:[UIImage imageNamed:@"loadingImage"] completionBlock:^(BOOL success, UIImage *image) {
            [UIView animateWithDuration:0.4 animations:^{
                [weakSelf.contentView layoutIfNeeded];
            }];
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    [self layoutViews];
}

- (STImageView*)imageView {
    if (!_imageView) {
        _imageView = [[STImageView alloc] initWithFrame:CGRectZero];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        _imageView.backgroundColor = [UIColor redColor];
    }
    
    return _imageView;
}

- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont fontWithName:@"Avenir-MediumOblique" size:25.0];
    }
    
    return _titleLabel;
}

- (UILabel*)descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _descriptionLabel.numberOfLines = 0;
        _descriptionLabel.font = [UIFont fontWithName:@"Avenir-Light" size:18.0];
    }
    
    return _descriptionLabel;
}

- (void)layoutViews {

    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.descriptionLabel];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_imageView]-20-[_titleLabel]-20-[_descriptionLabel]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageView, _titleLabel, _descriptionLabel)]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
#if !SHOULD_SET_ORIGINAL_IMAGE_SIZE
    CGFloat imageHeight = CGRectGetHeight(self.view.bounds)/2.0f;
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:imageHeight]];
#endif
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:0.9 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.descriptionLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:0.9 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.descriptionLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [self.contentView removeConstraint:self.scrollContentHeightConstraint];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
