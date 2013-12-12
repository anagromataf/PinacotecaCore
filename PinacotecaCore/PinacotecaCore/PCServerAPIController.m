//
//  PCServerAPIController.m
//  PinacotecaCore
//
//  Created by Tobias Kräntzer on 23.06.13.
//  Copyright (c) 2013 Tobias Kräntzer. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

#import "PCConstants.h"

#import "PCServerAPIController.h"

@implementation PCServerAPIController

- (void)fetchImageWithId:(NSString *)imageId
                   queue:(NSOperationQueue *)queue
       completionHandler:(void (^)(id JSONObject, NSError *error))handler
{
    NSURL *imageURL = [NSURL URLWithString:@"123" relativeToURL:[NSURL URLWithString:@"http://api.example.com/v1/images/"]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [[AFJSONResponseSerializer alloc] init];
    
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSOperationQueue *_queue = queue ?: [NSOperationQueue mainQueue];
        [_queue addOperationWithBlock:^{
            handler(responseObject, operation.error);
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSOperationQueue *_queue = queue ?: [NSOperationQueue mainQueue];
        [_queue addOperationWithBlock:^{
            handler(nil, error);
        }];
    }];
    [requestOperation start];
}

@end
