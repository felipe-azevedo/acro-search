//
//  AcronymSearchService.m
//  AcronymSearch
//
//  Created by Felipe de Azevedo on 1/31/16.
//  Copyright © 2016 Felipe Azevedo. All rights reserved.
//

#import "AcronymSearchService.h"
#import "AFNetworking.h"
#import "Acronym.h"

static NSString *const SearchUrl = @"http://www.nactem.ac.uk/software/acromine/dictionary.py?sf=%@";

@interface AcronymSearchService()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation AcronymSearchService

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.sessionManager = [AFHTTPSessionManager manager];
        self.sessionManager.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"text/plain", nil];
    }
    
    return self;
}

- (void)searchAcronym:(NSString *)acronym
              success:(void (^)(NSArray *results))success
              failure:(void (^)(NSError *error))failure {
    NSString *urlString = [NSString stringWithFormat:SearchUrl, acronym];
    NSURL *url = [NSURL URLWithString:urlString];
    
    [self.sessionManager GET:url.absoluteString
                  parameters:nil
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         if ([responseObject isKindOfClass:[NSArray class]]) {
                             NSArray *lfs = [[responseObject firstObject] objectForKey:@"lfs"];
                             NSMutableArray *results = [NSMutableArray array];
                             
                             for (NSDictionary *acronymDict in lfs) {
                                 Acronym *acronym = [[Acronym alloc] initWithDictionary:acronymDict];
                                 [results addObject:acronym];
                             }
                             
                             if (success) {
                                 success(results);
                             }
                         }
                         
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         if (failure) {
                             failure(error);
                         }
                     }
     ];
}

@end
