//
//  STApiCallHandler.h
//  SaltsideTest
//
//  Created by Luv Singh on 02/12/15.
//  Copyright (c) 2015 Luv Singh. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DataFetchCompletionHandler) (BOOL success, id object);

@interface STApiCallHandler : NSObject

+ (instancetype)sharedInstance;

- (void)getDataFromURLString:(NSString*)urlString withCompletionHandler:(DataFetchCompletionHandler)completion;
- (void)getDataFromURLString:(NSString*)urlString withItemClass:(Class)itemClass withCompletionHandler:(DataFetchCompletionHandler)completion;

@end
