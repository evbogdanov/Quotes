//
//  API.m
//  QuotesClient
//
//  Created by Ev Bogdanov on 27/03/2017.
//  Copyright © 2017 Ev Bogdanov. All rights reserved.
//

#import "API.h"

@implementation API


#pragma mark - Singleton

+ (API *)sharedAPI {
    static API *singleton = nil;

    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        singleton = [[API alloc] init];
    });
    
    return singleton;
}


#pragma mark - API

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

// TODO: come on, these network requests are too verbose. Just look how sexy they can be: https://github.com/AFNetworking/AFNetworking
- (void)createQuoteWithText:(NSString *)text source:(NSString *)source callback:(void(^)(NSError *error))callback {
    NSURL *URL = [API URLFor:@"/quotes"];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSString *encodedText = [API encodeURIComponent:text];
    NSString *encodedSource = [API encodeURIComponent:source];
    NSString *post = [NSString stringWithFormat:@"text=%@&source=%@", encodedText, encodedSource];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", [postData length]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"POST";
    request.HTTPBody = postData;
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error)
            return callback(error);
        
        NSError *JSONError;
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&JSONError];
        
        if (JSONError)
            return callback(JSONError);
        
        NSNumber *created = JSON[@"created"];
        if (!created || created.unsignedIntegerValue != 1)
            return callback([NSError errorWithDomain:@"io.bogdanov.QuotesClient" code:666 userInfo:nil]);
        
        callback(nil);
    }] resume];
}


#pragma mark - Internals

+ (NSURL *)URLFor:(NSString *)endpoint {
    NSString *URLString = [NSString stringWithFormat:@"http://127.0.0.1:3000%@", endpoint];
    return [NSURL URLWithString:URLString];
}

+ (NSString *)encodeURIComponent:(NSString *)string {
    return [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
}

@end
