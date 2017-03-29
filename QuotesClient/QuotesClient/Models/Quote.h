//
//  Quote.h
//  QuotesClient
//
//  Created by Ev Bogdanov on 24/03/2017.
//  Copyright © 2017 Ev Bogdanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Quote : NSObject

@property (strong, nonatomic, readonly) NSNumber *identifier;
@property (strong, nonatomic, readonly) NSString *text;
@property (strong, nonatomic, readonly) NSString *source;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
