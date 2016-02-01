//
//  AcronymSearchViewController.m
//  AcronymSearch
//
//  Created by Felipe de Azevedo on 1/31/16.
//  Copyright © 2016 Felipe Azevedo. All rights reserved.
//

#import "AcronymSearchViewController.h"
#import "Acronym.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"

@interface AcronymSearchViewController() <UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *longFormResults;

@end

@implementation AcronymSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark - UISearchBarDelegate methods

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.text = @"";
    self.longFormResults = nil;
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

- (void)performSearch {
    static NSString * const BaseURLString = @"http://www.nactem.ac.uk/software/acromine/dictionary.py";
    NSString *searchString = self.searchBar.text;
    
    NSString *urlString = [NSString stringWithFormat:@"%@?sf=%@", BaseURLString, searchString];
    NSURL *url = [NSURL URLWithString:urlString];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES;
    hud.labelText = @"Loading...";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = nil;
    [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            NSArray *lfs = [[responseObject firstObject] objectForKey:@"lfs"];
            NSMutableArray *results = [NSMutableArray array];
            
            for (NSDictionary *longForm in lfs) {
                Acronym *acronym = [[Acronym alloc] initWithDictionary:longForm];
                [results addObject:acronym];
            }
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.longFormResults = results;
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
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
    }];
}


#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.longFormResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *AcronymSearchCellReuseIdentifier = @"AcronymSearchCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AcronymSearchCellReuseIdentifier forIndexPath:indexPath];
    
    Acronym *acronym = [self.longFormResults objectAtIndex:indexPath.row];
    cell.textLabel.text = acronym.longForm;
    
    return cell;
}

@end
