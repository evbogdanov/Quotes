//
//  NewQuoteVC.m
//  QuotesClient
//
//  Created by Ev Bogdanov on 30/03/2017.
//  Copyright © 2017 Ev Bogdanov. All rights reserved.
//

#import "NewQuoteVC.h"
#import "API.h"

@interface NewQuoteVC ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextField *sourceField;

@end

@implementation NewQuoteVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)createQuote:(UIBarButtonItem *)sender {
    [[API sharedAPI] createQuoteWithText:self.textField.text
                                  source:self.sourceField.text
                                callback:^(NSError *error) {
        if (error) {
            NSLog(@"Holy moly! %@", error);
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
}

@end
