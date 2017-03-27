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
    self.textLabel.text = @"quote.text";
    self.sourceLabel.text = @"quote.source";
}

@end
