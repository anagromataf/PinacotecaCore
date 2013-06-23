//
//  PCServerAPIController.h
//  PinacotecaCore
//
//  Created by Tobias Kräntzer on 23.06.13.
//  Copyright (c) 2013 Tobias Kräntzer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCServerAPIController : NSObject

- (void)fetchImageWithId:(NSString *)imageId
                   queue:(NSOperationQueue *)queue
       completionHandler:(void (^)(id JSONObject, NSError *error))handler;

@end
