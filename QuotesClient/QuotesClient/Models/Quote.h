//
//  Quote.h
//  QuotesClient
//
//  Created by Ev Bogdanov on 24/03/2017.
//  Copyright © 2017 Ev Bogdanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Quote : NSObject

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *source;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
