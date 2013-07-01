//
//  PCResourceManager.m
//  PinacotecaCore
//
//  Created by Tobias Kräntzer on 23.06.13.
//  Copyright (c) 2013 Tobias Kräntzer. All rights reserved.
//

#import "PCImage+Private.h"

#import "PCResourceManager.h"
#import "PCResourceManager+Private.h"

@interface PCResourceManager ()
@property (nonatomic, readonly) PCServerAPIController *server;
@property (nonatomic, readonly) NSOperationQueue *queue;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, readonly) NSManagedObjectContext *rootManagedObjectContext;
@end


@implementation PCResourceManager

- (id)init
{
    self = [super init];
    if (self) {
        _server = [[PCServerAPIController alloc] init];
        _queue = [[NSOperationQueue alloc] init];
        
        NSBundle *frameworkBundle = [NSBundle bundleForClass:[self class]];
        NSURL *modelURL = [frameworkBundle URLForResource:@"Model" withExtension:@"momd"];
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        NSError *error;
        NSPersistentStore *store = [_persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType
                                                                             configuration:nil
                                                                                       URL:nil
                                                                                   options:nil
                                                                                    error:&error];
        NSAssert(store, [error localizedDescription]);
        
        // Create Root Context
        _rootManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _rootManagedObjectContext.persistentStoreCoordinator = _persistentStoreCoordinator;
        
        // Create Context for the main Thread
        _mainManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _mainManagedObjectContext.parentContext = _rootManagedObjectContext;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(rootManagedObjectContextDidSave:)
                                                     name:NSManagedObjectContextDidSaveNotification
                                                   object:_rootManagedObjectContext];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (PCImage *)imageWithId:(NSString *)imageId
  usingManagedObjectContext:(NSManagedObjectContext *)context
                   queue:(NSOperationQueue *)queue
           updateHandler:(void (^)(NSError *error))handler
{
    __block PCImage *result = nil;
    [self.rootManagedObjectContext performBlockAndWait:^{
        
        void(^_handler)(NSError *) = ^(NSError *error) {
            if (handler) {
                [queue addOperationWithBlock:^{
                    handler(error);
                }];
            }
        };
        
        BOOL created = YES;
        NSError *error = nil;
        PCImage *image = [PCImage createOrUpdateWithValues:@{@"id":imageId}
                                    inManagedObjectContext:self.rootManagedObjectContext
                                                   created:&created
                                                     error:&error];
        
        if (image == nil) {
            _handler(error);
            return;
        }
        
        if (created && ![self.rootManagedObjectContext save:&error]) {
            _handler(error);
            return;
        }
        
        result = (PCImage *)[context objectWithID:image.objectID];
        
        [self updateImage:image queue:queue updateHandler:handler];
        
    }];
    return result;
}

- (void)updateImage:(PCImage *)_image
              queue:(NSOperationQueue *)queue
      updateHandler:(void (^)(NSError *error))handler
{
    [self.rootManagedObjectContext performBlock:^{
        
        void(^_handler)(NSError *) = ^(NSError *error) {
            if (handler) {
                [queue addOperationWithBlock:^{
                    handler(error);
                }];
            }
        };
        
        PCImage *image = (PCImage *)[self.rootManagedObjectContext objectWithID:_image.objectID];
        
        [self.server fetchImageWithId:image.imageId
                                queue:self.queue
                    completionHandler:^(id values, NSError *error) {
                        
                        if (error) {
                            _handler(error);
                            return;
                        }
                        
                        [self.rootManagedObjectContext performBlock:^{
                            BOOL created = NO;
                            NSError *error = nil;
                            PCImage *image = [PCImage createOrUpdateWithValues:values
                                                        inManagedObjectContext:self.rootManagedObjectContext
                                                                       created:&created
                                                                         error:&error];
                            
                            if (image) {
                                [self.rootManagedObjectContext save:&error];
                            }
                            
                            _handler(error);
                        }];
                    }];
    }];
}

#pragma mark Notification Handling

- (void)rootManagedObjectContextDidSave:(NSNotification *)aNotification
{
    [self.mainManagedObjectContext performBlock:^{
        [self.mainManagedObjectContext mergeChangesFromContextDidSaveNotification:aNotification];
    }];
}

@end

@implementation PCResourceManager (Private)
@dynamic server;
@end
