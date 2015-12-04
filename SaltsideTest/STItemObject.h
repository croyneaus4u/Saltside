//
//  STItemObject.h
//  SaltsideTest
//
//  Created by Luv Singh on 03/12/15.
//  Copyright (c) 2015 Luv Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STMappingProtocol.h"

#define kImageURL @"image"
#define kTitle @"title"
#define kDescription @"description"

@interface STItemObject : NSObject <STMappingProtocol>

@property (nonatomic, strong) NSString *imageURLString;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *itemDescription;

@end
