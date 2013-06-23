//
//  PCServerAPIController.m
//  PinacotecaCore
//
//  Created by Tobias Kräntzer on 23.06.13.
//  Copyright (c) 2013 Tobias Kräntzer. All rights reserved.
//

#import <AFJSONPRequestOperation/AFJSONPRequestOperation.h>

#import "PCConstants.h"

#import "PCServerAPIController.h"

@implementation PCServerAPIController

- (void)fetchImageWithId:(NSString *)imageId
                   queue:(NSOperationQueue *)queue
       completionHandler:(void (^)(id JSONObject, NSError *error))handler
{
    NSURL *imageURL = [NSURL URLWithString:@"123" relativeToURL:[NSURL URLWithString:@"http://api.example.com/v1/images/"]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
    AFJSONRequestOperation *requestOperation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        AFJSONRequestOperation *jsonOperation = (AFJSONRequestOperation *)operation;
        NSOperationQueue *_queue = queue ?: [NSOperationQueue mainQueue];
        [_queue addOperationWithBlock:^{
            handler(jsonOperation.responseJSON, nil);
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
