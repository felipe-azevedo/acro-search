//
//  Acronym.h
//  AcronymSearch
//
//  Created by Felipe de Azevedo on 1/30/16.
//  Copyright © 2016 Felipe Azevedo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Acronym : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, strong) NSString *longForm;
@property (nonatomic, strong) NSNumber *frequency;
@property (nonatomic, strong) NSNumber *since;

@end
