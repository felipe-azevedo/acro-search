//
//  Acronym.m
//  AcronymSearch
//
//  Created by Felipe de Azevedo on 1/30/16.
//  Copyright © 2016 Felipe Azevedo. All rights reserved.
//

#import "Acronym.h"

@implementation Acronym

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.longForm = dictionary[@"lf"];
        self.frequency = dictionary[@"freq"];
        self.since = dictionary[@"since"];
    }
    
    return self;
}

@end
