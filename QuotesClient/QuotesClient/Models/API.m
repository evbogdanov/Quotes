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
    NSURL *URL = [API URLFor:@"/quotes"];
    NSURLSession *session = [NSURLSession sharedSession];
    
    [[session dataTaskWithURL:URL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error)
            return callback(nil, error);
        
        NSError *JSONError;
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&JSONError];

        if (JSONError)
            return callback(nil, JSONError);
        
        callback(JSON[@"quotes"], nil);
    }] resume];
}

// TODO: don't repeat yourself, write wrapper for all network requests.
- (void)deleteQuoteWithIdentifier:(NSNumber *)identifier callback:(void(^)(NSError *))callback {
    NSString *endpoint = [NSString stringWithFormat:@"/quotes/%@", identifier];
    NSURL *URL = [API URLFor:endpoint];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"DELETE";
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error)
            return callback(error);
        
        NSError *JSONError;
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&JSONError];
        
        if (JSONError)
            return callback(JSONError);
        
        NSNumber *deleted = JSON[@"deleted"];
        if (!deleted || deleted.unsignedIntegerValue != 1)
            return callback([NSError errorWithDomain:@"io.bogdanov.QuotesClient" code:13 userInfo:nil]);
        
        callback(nil);
    }] resume];
}

// Private
+ (NSURL *)URLFor:(NSString *)endpoint {
    NSString *URLString = [NSString stringWithFormat:@"http://127.0.0.1:3000%@", endpoint];
    return [NSURL URLWithString:URLString];
}

@end
