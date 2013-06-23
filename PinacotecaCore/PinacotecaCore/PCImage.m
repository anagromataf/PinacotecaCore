//
//  PCImage.m
//  PinacotecaCore
//
//  Created by Tobias Kräntzer on 23.06.13.
//  Copyright (c) 2013 Tobias Kräntzer. All rights reserved.
//

#import "PCConstants.h"

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
    NSError *_error = nil;
    
    PCImage *image = [self imageWithId:values[@"id"]
                inManagedObjectContext:context
                                 error:&_error];
    if (_error) {
        if (error) {
            *error = _error;
        }
        return nil;
    }
    
    if (!image) {
        NSEntityDescription *entityDescription = [self entityDescriptionInManagedObjectContext:context];
        image = [[self alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:context];
        image.imageId = values[@"id"];
        
        if (created) {
            *created = YES;
        }
    } else {
        if (created) {
            *created = NO;
        }
    }
    
    image.title = values[@"title"];
    image.url = values[@"url"];
    
    if (error) {
        *error = _error;
    }
    
    return image;
}

+ (instancetype)imageWithId:(NSString *)imageId
     inManagedObjectContext:(NSManagedObjectContext *)context
                      error:(NSError **)error
{
    NSEntityDescription *entityDescription = [self entityDescriptionInManagedObjectContext:context];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityDescription.name];
    
    request.predicate = [NSPredicate predicateWithFormat:@"imageId == %@"
                                           argumentArray:@[imageId]];
    
    NSArray *result = [context executeFetchRequest:request
                                             error:error];
    
    switch ([result count]) {
        case 0: return  nil;
        case 1: return result[0];
        default:
        {
            if (error) {
                *error = [NSError errorWithDomain:PCErrorDomain
                                             code:PCInternalInconsistencyErrorCode
                                         userInfo:nil];
            }
            return nil;
        };
    }
}

@dynamic imageId;
@dynamic title;
@dynamic url;

@end
