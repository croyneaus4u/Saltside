//
//  STApiCallHandler.m
//  SaltsideTest
//
//  Created by Luv Singh on 02/12/15.
//  Copyright (c) 2015 Luv Singh. All rights reserved.
//

#import "STApiCallHandler.h"
#import "STMappingProtocol.h"

@interface STApiCallHandler ()

@property (nonatomic, strong) NSOperationQueue *operationQ;

@end

@implementation STApiCallHandler

+ (instancetype)sharedInstance {
    static STApiCallHandler *_apiCallHandler;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _apiCallHandler = [[STApiCallHandler alloc] init];
    });
    
    return _apiCallHandler;
}

- (void)getDataFromURLString:(NSString*)urlString withCompletionHandler:(DataFetchCompletionHandler)completion {
    [self getDataFromURLString:urlString withItemClass:NULL withCompletionHandler:completion];
}

- (void)getDataFromURLString:(NSString*)urlString withItemClass:(Class)itemClass withCompletionHandler:(DataFetchCompletionHandler)completion {
    NSURLRequest *request = [self requestWithURLString:urlString];
    self.operationQ = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:self.operationQ completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(NO, connectionError);
            });
        } else {
            [self parseData:data withMappingClass:itemClass completion:completion];
        }
    }];
}

- (void)parseData:(NSData*)data withMappingClass:(Class)mappingClass completion:(DataFetchCompletionHandler)completion {
    NSError *parsingError = nil;
    NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parsingError];
    if (parsingError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(NO, parsingError);
        });
    } else if (mappingClass) {
        NSMutableArray *dataArray = [self dataArrayFromResponseArray:jsonArray withMappingClass:mappingClass];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(YES, dataArray);
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(YES, jsonArray);
        });
    }
}

// this method below can be expanded further if needed.
- (NSMutableArray*)dataArrayFromResponseArray:(NSMutableArray*)responseArray withMappingClass:(Class)mappingClass {
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for (id item in responseArray) {
        NSObject <STMappingProtocol> *object = [[mappingClass alloc] init];
        NSDictionary *mappingDictionary = [object mappingDictionary];
        for (NSString *key in [item allKeys]) {
            [object setValue:item[key] forKey:mappingDictionary[key]];
        }
        [dataArray addObject:object];
    }
    
    return dataArray;
}

- (NSURLRequest*)requestWithURLString:(NSString*)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:40];
    
    return request;
}

@end
