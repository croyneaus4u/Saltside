//
//  STItemObject.m
//  SaltsideTest
//
//  Created by Luv Singh on 03/12/15.
//  Copyright (c) 2015 Luv Singh. All rights reserved.
//

#import "STItemObject.h"

@implementation STItemObject

- (NSDictionary*)mappingDictionary {
    NSDictionary *mappingDict = @{@"image" : @"imageURLString",
                                  @"title" : @"title",
                                  @"description" : @"itemDescription"
                                  };
    return mappingDict;
}

@end
