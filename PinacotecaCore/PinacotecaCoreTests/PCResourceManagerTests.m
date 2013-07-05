//
//  PCResourceManagerTests.m
//  PinacotecaCore
//
//  Created by Tobias Kräntzer on 23.06.13.
//  Copyright (c) 2013 Tobias Kräntzer. All rights reserved.
//

#import <SenTestingKitAsync/SenTestingKitAsync.h>
#import <OCMock/OCMock.h>

#import "PCResourceManager.h"
#import "PCResourceManager+Private.h"

typedef void (^ATKVOStubbingBlock)(NSObject *object, NSString *keyPath, NSDictionary *change);

@interface PCResourceManagerTests : SenTestCase
@property (nonatomic, strong) PCResourceManager *resourceManager;
@property (nonatomic, strong) OCMockObject *serverMock;
@end

@implementation PCResourceManagerTests

- (void)stubKVOOnObject:(NSObject *)toObserve keyPath:(NSString *)keyPath block:(ATKVOStubbingBlock)block
{
    id observer = [OCMockObject niceMockForClass:[NSObject class]];
    [toObserve addObserver:observer
                forKeyPath:keyPath
                   options:NSKeyValueObservingOptionNew
                   context:NULL];
    
    [[[observer stub] andDo:^(NSInvocation *theInvocation) {
        [toObserve removeObserver:observer forKeyPath:keyPath];
        
        __unsafe_unretained NSObject *object;
        __unsafe_unretained NSString *keyPath;
        __unsafe_unretained NSDictionary *change;
        [theInvocation getArgument:&object atIndex:2];
        [theInvocation getArgument:&keyPath atIndex:3];
        [theInvocation getArgument:&change atIndex:4];
        
        if (block) block(object, keyPath, change);
    }] observeValueForKeyPath:keyPath ofObject:toObserve change:OCMOCK_ANY context:NULL];
}


- (void)setUp
{
    [super setUp];
    self.resourceManager = [[PCResourceManager alloc] init];
}

#pragma mark Tests

- (void)testGetImageAsync
{
    // Stub the Server API Method to fetch the image
    
    OCMockObject *serverMock = [OCMockObject partialMockForObject:self.resourceManager.server];
    
    id expector = [[serverMock expect] andCall:@selector(fetchImageWithId:queue:completionHandler:) onObject:self];
    [expector fetchImageWithId:OCMOCK_ANY queue:OCMOCK_ANY completionHandler:OCMOCK_ANY];
    
    // Get the image
    
    __block PCImage *image = [self.resourceManager imageWithId:@"123"
                                     usingManagedObjectContext:self.resourceManager.mainManagedObjectContext
                                                         queue:[NSOperationQueue mainQueue]
                                                 updateHandler:^(NSError *error) {
                                                     STAssertNil(error, [error localizedDescription]);
                                                     
                                                     STAssertEqualObjects(image.title, @"My first Image", nil);
                                                     STAssertEqualObjects(image.url, @"http://data.example.com/239f8z3z48g3.jpeg", nil);
                                                     
                                                     STAssertNoThrow([serverMock verify], nil);
                                                     
                                                     STSuccess();
                                                 }];
    STAssertNotNil(image, nil);
    STAssertEqualObjects(image.managedObjectContext, self.resourceManager.mainManagedObjectContext, nil);
    STAssertEqualObjects(image.imageId, @"123", nil);
    STAssertNil(image.title, nil);
    STAssertNil(image.url, nil);
    
    STFailAfter(2.0, @"Timeout");
}

- (void)testCreateImageAsync
{
    NSManagedObjectContext *context = self.resourceManager.mainManagedObjectContext;
    
    // Stub the Server API Method to fetch the image
    
    OCMockObject *serverMock = [OCMockObject partialMockForObject:self.resourceManager.server];
    
    id expector = [[serverMock expect] andCall:@selector(createImageWithPorperties:queue:completionHandler:) onObject:self];
    [expector createImageWithPorperties:OCMOCK_ANY queue:OCMOCK_ANY completionHandler:OCMOCK_ANY];
    
    
    // Create image
    
    PCImage *image = [[PCImage alloc] initWithEntity:[PCImage entityDescriptionInManagedObjectContext:context]
                      insertIntoManagedObjectContext:context];
    STAssertNotNil(image, nil);
    
    image.title = @"My other Image";
    
    [self stubKVOOnObject:image keyPath:@"imageId" block:^(NSObject *object, NSString *keyPath, NSDictionary *change) {
        STAssertEqualObjects(image.imageId, @"321", nil);
        STAssertNoThrow([serverMock verify], nil);
        STSuccess();
    }];
    
    NSError *error = nil;
    BOOL success = [context save:&error];
    STAssertTrue(success, [error localizedDescription]);
    
    STFailAfter(2.0, @"Timeout");
}

#pragma mark -

- (void)fetchImageWithId:(NSString *)imageId
                   queue:(NSOperationQueue *)queue
       completionHandler:(void (^)(id JSONObject, NSError *error))handler
{
    NSDictionary *values = @{@"id":@"123",
                             @"title":@"My first Image",
                             @"url":@"http://data.example.com/239f8z3z48g3.jpeg"};
    
    [queue addOperationWithBlock:^{
        handler(values, nil);
    }];
}

- (void)createImageWithPorperties:(NSDictionary *)properties
                            queue:(NSOperationQueue *)queue
                completionHandler:(void (^)(NSString *imageId, NSError *error))handler
{
    [queue addOperationWithBlock:^{
        handler(@"321", nil);
    }];
}

@end
