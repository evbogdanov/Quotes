//
//  API.h
//  QuotesClient
//
//  Created by Ev Bogdanov on 27/03/2017.
//  Copyright © 2017 Ev Bogdanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface API : NSObject

+ (API *)sharedAPI;
- (void)getQuotesWithCallback:(void(^)(NSArray *quotes, NSError *error))callback;

@end
