//
//  PCImage.m
//  PinacotecaCore
//
//  Created by Tobias Kräntzer on 23.06.13.
//  Copyright (c) 2013 Tobias Kräntzer. All rights reserved.
//

#import "PCImage.h"
#import "PCImage+Private.h"

@implementation PCImage

@dynamic imageId;
@dynamic title;
@dynamic url;

@end

#pragma mark -

@implementation PCImage (Private)

+ (NSEntityDescription *)entityDescriptionInManagedObjectContext:(NSManagedObjectContext *)context
{
   __block  NSEntityDescription *result = nil;
    
    NSString *className = NSStringFromClass(self);
    
    NSManagedObjectModel *model = context.persistentStoreCoordinator.managedObjectModel;
    [[model entities] enumerateObjectsUsingBlock:^(NSEntityDescription *entityDescription,
                                                   NSUInteger idx,
                                                   BOOL *stop) {
        if ([entityDescription.managedObjectClassName isEqualToString:className]) {
            result = entityDescription;
            *stop = YES;
        }
    }];
    return result;
}

+ (instancetype)createOrUpdateWithValues:(NSDictionary *)values
                  inManagedObjectContext:(NSManagedObjectContext *)context
                                 created:(BOOL *)created
                                   error:(NSError **)error
{
    return nil;
}

+ (instancetype)imageWithId:(NSString *)imageId
     inManagedObjectContext:(NSManagedObjectContext *)context
                      error:(NSError **)error
{
    return nil;
}

@dynamic imageId;
@dynamic title;
@dynamic url;

@end
