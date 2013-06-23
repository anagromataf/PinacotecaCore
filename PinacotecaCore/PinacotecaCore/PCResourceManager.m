//
//  PCResourceManager.m
//  PinacotecaCore
//
//  Created by Tobias Kräntzer on 23.06.13.
//  Copyright (c) 2013 Tobias Kräntzer. All rights reserved.
//

#import "PCResourceManager.h"
#import "PCResourceManager+Private.h"

@interface PCResourceManager ()
@property (nonatomic, readonly) PCServerAPIController *server;
@end


@implementation PCResourceManager

- (id)init
{
    self = [super init];
    if (self) {
        _server = [[PCServerAPIController alloc] init];
    }
    return self;
}

- (PCImage *)imageWithId:(NSString *)imageId
  usingManagedObjectContext:(NSManagedObjectContext *)context
                   queue:(NSOperationQueue *)queue
           updateHandler:(void (^)(BOOL updated, NSError *error))handler
{
    __block PCImage *image = nil;
    return image;
}

@end

@implementation PCResourceManager (Private)
@dynamic server;
@end
