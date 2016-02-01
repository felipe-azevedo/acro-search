//
//  AcronymSearchService.h
//  AcronymSearch
//
//  Created by Felipe de Azevedo on 1/31/16.
//  Copyright © 2016 Felipe Azevedo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AcronymSearchService : NSObject

- (void)searchAcronym:(NSString *)acronym
              success:(void (^)(NSArray *results))success
              failure:(void (^)(NSError *error))failure;

@end
