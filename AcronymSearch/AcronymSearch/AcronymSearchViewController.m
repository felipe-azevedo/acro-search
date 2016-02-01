//
//  AcronymSearchViewController.m
//  AcronymSearch
//
//  Created by Felipe de Azevedo on 1/31/16.
//  Copyright © 2016 Felipe Azevedo. All rights reserved.
//

#import "AcronymSearchViewController.h"
#import "Acronym.h"
#import "AcronymSearchService.h"
#import "MBProgressHUD.h"

@interface AcronymSearchViewController() <UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) AcronymSearchService *searchService;
@property (nonatomic, strong) NSArray *searchResults;

@end

@implementation AcronymSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchService = [AcronymSearchService new];
}


#pragma mark - UISearchBarDelegate methods

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.text = @"";
    self.searchResults = nil;
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self dismissKeyboard];
    [self performSearch];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self dismissKeyboard];
}

- (void)dismissKeyboard {
    [self.searchBar resignFirstResponder];
}


#pragma mark - Search methods

- (void)performSearch {
    NSString *searchString = self.searchBar.text;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES;
    hud.labelText = @"Loading...";
    
    [self.searchService searchAcronym:searchString success:^(NSArray *results) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.searchResults = results;
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self showSearchErrorAlert];
    }];
}

- (void)showSearchErrorAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error searching acronym"
                                                                             message:@"There was an error searching for the acronym. Please try again later."
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              [self dismissViewControllerAnimated:YES completion:nil];
                                                          }];
    [alertController addAction:dismissAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *AcronymSearchCellReuseIdentifier = @"AcronymSearchCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AcronymSearchCellReuseIdentifier forIndexPath:indexPath];
    
    Acronym *acronym = [self.searchResults objectAtIndex:indexPath.row];
    cell.textLabel.text = acronym.longForm;
    
    return cell;
}

@end
