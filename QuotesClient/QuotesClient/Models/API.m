//
//  API.m
//  QuotesClient
//
//  Created by Ev Bogdanov on 27/03/2017.
//  Copyright © 2017 Ev Bogdanov. All rights reserved.
//

#import "API.h"

@implementation API

+ (API *)sharedAPI {
    static API *singleton = nil;

    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        singleton = [[API alloc] init];
    });
    
    return singleton;
}

- (void)getQuotesWithCallback:(void(^)(NSArray *, NSError *))callback {
    NSString *urlString   = @"http://127.0.0.1:3000/quotes";
    NSURL *url            = [NSURL URLWithString:urlString];
    NSURLSession *session = [NSURLSession sharedSession];
    
    [[session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error)
            return callback(nil, error);
        
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (jsonError)
            return callback(nil, jsonError);
        
        callback(json[@"quotes"], nil);
    }] resume];
}

@end
