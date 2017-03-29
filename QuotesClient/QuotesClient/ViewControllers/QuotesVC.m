//
//  QuotesVC.m
//  QuotesClient
//
//  Created by Ev Bogdanov on 27/03/2017.
//  Copyright © 2017 Ev Bogdanov. All rights reserved.
//

#import "QuotesVC.h"
#import "API.h"
#import "Quote.h"

@interface QuotesVC ()
@property (strong, nonatomic) NSMutableArray *quotes;
@end

@implementation QuotesVC


#pragma mark - VC lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // TODO: don't make network request here? Come up with something more efficient.
    // Also I have to think about latency. It may be a good idea to first show the user
    // an activity indicator of some sort
    [[API sharedAPI] getQuotesWithCallback:^(NSArray *quotes, NSError *error) {
        if (error) {
            NSLog(@"Oh no! %@", error);
            return;
        }
        
        [self.quotes removeAllObjects];
        for (NSDictionary *dict in quotes) {
            Quote *quote = [[Quote alloc] initWithDictionary:dict];
            if (quote) {
                [self.quotes addObject:quote];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}


#pragma mark - Lazy quotes getter

- (NSMutableArray *)quotes {
    if (!_quotes) {
        _quotes = [[NSMutableArray alloc] init];
    }
    return _quotes;
}


#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.quotes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Quote *quote = self.quotes[indexPath.row];
    cell.textLabel.text = quote.text;
    cell.detailTextLabel.text = quote.source;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowQuote"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Quote *quote = self.quotes[indexPath.row];
        QuoteVC *vc = (QuoteVC *)segue.destinationViewController;
        vc.quote = quote;
    }
}

@end
