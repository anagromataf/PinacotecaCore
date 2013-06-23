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

- (PCImage *)imageWithId:(NSString *)imageId
  inManagedObjectContext:(NSManagedObjectContext *)context
                   queue:(NSOperationQueue *)queue
           updateHandler:(void (^)(BOOL updated, NSError *error))handler;

@end
