//
//  QuoteVC.m
//  QuotesClient
//
//  Created by Ev Bogdanov on 27/03/2017.
//  Copyright © 2017 Ev Bogdanov. All rights reserved.
//

#import "QuoteVC.h"

@interface QuoteVC ()

@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;

@end

@implementation QuoteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textLabel.text = self.quote.text;
    self.sourceLabel.text = self.quote.source;
}

- (IBAction)deleteQuote:(UIBarButtonItem *)sender {
    // Delete quote from database...
    NSLog(@"Delete quote: %@", self.quote);
    
    // Quote deleted. So it doesn't make sense to be on screen anymore.
    [self.navigationController popViewControllerAnimated:YES];
}

@end
