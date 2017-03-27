//
//  Quote.m
//  QuotesClient
//
//  Created by Ev Bogdanov on 24/03/2017.
//  Copyright © 2017 Ev Bogdanov. All rights reserved.
//

#import "Quote.h"

@implementation Quote

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if ((self = [super init]) && dict[@"text"] && dict[@"source"]) {
        _text = dict[@"text"];
        _source = dict[@"source"];
        return self;
    }
    return nil;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<<%@>> -- %@", self.text, self.source];
}

@end
