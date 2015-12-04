//
//  MasterViewController.m
//  SaltsideTest
//
//  Created by Luv Singh on 02/12/15.
//  Copyright (c) 2015 Luv Singh. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

#import "STApiCallHandler.h"
#import "STTableViewCell.h"
#import "STItemObject.h"

#define kURL_STRING @"https://gist.githubusercontent.com/maclir/f715d78b49c3b4b3b77f/raw/8854ab2fe4cbe2a5919cea97d71b714ae5a4838d/items.json"

#define LOAD_DATA_USING_OBJECT_MAPPING 0  // change this value to 0 to load data using AS-IS Data using dictionaries

@interface MasterViewController ()

@property NSMutableArray *objects;

@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self loadDataFromServer];
}

- (void)loadDataFromServer {
#if LOAD_DATA_USING_OBJECT_MAPPING
    [self loadDataUsingObjectMapping];
#else
    [self loadDataUsingObjectMapping];
#endif
}

- (void)loadDataUsingPlainDictionary {
    __weak typeof(self) weakSelf = self;
    
    // this method returns Dictionary objects ..
    [[STApiCallHandler sharedInstance] getDataFromURLString:kURL_STRING withCompletionHandler:^(BOOL success, id object) {
        if (success) {
            weakSelf.objects = object;
            [self.tableView reloadData];
        } else {
            NSError *error = (NSError*)object;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
    }];
}

- (void)loadDataUsingObjectMapping {
    __weak typeof(self) weakSelf = self;
    
    // this method returns MApped STItemObject objects ..
    [[STApiCallHandler sharedInstance] getDataFromURLString:kURL_STRING withItemClass:[STItemObject class] withCompletionHandler:^(BOOL success, id object) {
        if (success) {
            weakSelf.objects = object;
            [self.tableView reloadData];
        } else {
            NSError *error = (NSError*)object;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        id object = self.objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    STTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    id object = self.objects[indexPath.row];
    if ([object isKindOfClass:[NSDictionary class]]) {
        cell.titleLabel.text = object[kTitle];
        cell.descriptionLabel.text = object[kDescription];
    } else if ([object isKindOfClass:[STItemObject class]]) {
        cell.titleLabel.text = [object title];
        cell.descriptionLabel.text = [object itemDescription];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 100;
    return height;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

@end
