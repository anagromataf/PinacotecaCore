//
//  PCResourceManager.h
//  PinacotecaCore
//
//  Created by Tobias Kräntzer on 23.06.13.
//  Copyright (c) 2013 Tobias Kräntzer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PCImage.h"

@interface PCResourceManager : NSObject

@property (nonatomic, readonly) NSManagedObjectContext *mainManagedObjectContext;

- (PCImage *)imageWithId:(NSString *)imageId
  usingManagedObjectContext:(NSManagedObjectContext *)context
                   queue:(NSOperationQueue *)queue
           updateHandler:(void (^)(NSError *error))handler;

- (void)updateImage:(PCImage *)image
              queue:(NSOperationQueue *)queue
      updateHandler:(void (^)(NSError *error))handler;

@end
