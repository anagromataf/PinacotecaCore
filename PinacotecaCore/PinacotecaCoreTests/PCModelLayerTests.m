//
//  PCModelLayerTests.m
//  PinacotecaCore
//
//  Created by Tobias Kräntzer on 23.06.13.
//  Copyright (c) 2013 Tobias Kräntzer. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#import "PCImage+Private.h"

@interface PCModelLayerTests : SenTestCase
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSPersistentStoreCoordinator *storeCoordinator;
@end


@implementation PCModelLayerTests

- (void)setUp
{
    [super setUp];
    
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:@[[NSBundle mainBundle]]];
    self.storeCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    NSError *error = nil;
    NSPersistentStore *store = [self.storeCoordinator addPersistentStoreWithType:NSInMemoryStoreType
                                                                   configuration:nil
                                                                             URL:nil
                                                                         options:nil
                                                                           error:&error];
    NSAssert(store, nil);
    
    self.context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.context.persistentStoreCoordinator = self.storeCoordinator;
}

#pragma mark Tests

- (void)testEntityDescription
{
    NSEntityDescription *entityDescription = [PCImage entityDescriptionInManagedObjectContext:self.context];
    STAssertNotNil(entityDescription, nil);
    STAssertEqualObjects(entityDescription.name, @"PCImage", nil);
    STAssertEqualObjects(entityDescription.managedObjectClassName, @"PCImage", nil);
}


- (void)testCreateImage
{
    NSError *error = nil;
    
    NSDictionary *values = @{@"id":@"123",
                             @"title":@"My first Image",
                             @"url":@"http://data.example.com/239f8z3z48g3.jpeg"};
    
    
    BOOL created = NO;
    PCImage *image = [PCImage createOrUpdateWithValues:values
                                inManagedObjectContext:self.context
                                               created:&created
                                                 error:&error];
    STAssertNotNil(image, [error localizedDescription]);
    STAssertTrue(created, nil);
    
    STAssertEqualObjects(image.imageId, @"123", nil);
    STAssertEqualObjects(image.title, @"My first Image", nil);
    STAssertEqualObjects(image.url, @"http://data.example.com/239f8z3z48g3.jpeg", nil);
    
    PCImage *createdImage = [PCImage imageWithId:@"123"
                          inManagedObjectContext:self.context
                                           error:&error];
    STAssertNotNil(createdImage, [error localizedDescription]);
    STAssertEqualObjects(createdImage, image, nil);
}

@end
