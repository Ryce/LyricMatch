//
//  ViewController.m
//  LyrixMatch
//
//  Created by Hamon Riazy on 03/04/15.
//  Copyright (c) 2015 riazy. All rights reserved.
//

#import "ViewController.h"
#import "LyricSession.h"
#import "UIView+Activity.h"

NSString *const reuseIdentifier = @"com.riazy.lyrix.search.cellidentifier";

@interface ViewController ()

@property (nonatomic, strong) NSArray *itemsArray;

@end

@implementation ViewController

#pragma mark - UITableView Delegate & DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
  cell.textLabel.text = [self.itemsArray[indexPath.row] valueForKeyPath:@"artist.name"];
  cell.detailTextLabel.text = [self.itemsArray[indexPath.row] valueForKeyPath:@"title"];
  return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.itemsArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  // TODO: add detail view with more info on song
}

#pragma mark - Session Call

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
  if (searchText.length) {
    [self.view showActivity];
    [[LyricSession sharedSession] searchLyric:searchBar.text completion:^(NSArray *results, NSError *error) {
      [self.view hideActivity];
      if (error) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"an error occured, please try again" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        return; // BAIL
      }
      self.itemsArray = results;
    }];
  } else {
    self.itemsArray = nil;
  }
}

#pragma mark - custom setters

- (void)setItemsArray:(NSArray *)itemsArray {
  if (_itemsArray == itemsArray) {
    return; // BAIL
  }
  _itemsArray = itemsArray;
  [self.tableView reloadData];
}

@end
