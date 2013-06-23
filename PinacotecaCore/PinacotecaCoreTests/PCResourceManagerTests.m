//
//  PCResourceManagerTests.m
//  PinacotecaCore
//
//  Created by Tobias Kräntzer on 23.06.13.
//  Copyright (c) 2013 Tobias Kräntzer. All rights reserved.
//

#import <SenTestingKitAsync/SenTestingKitAsync.h>

#import "PCResourceManager.h"

@interface PCResourceManagerTests : SenTestCase
@property (nonatomic, strong) PCResourceManager *resourceManager;
@end

@implementation PCResourceManagerTests

- (void)setUp
{
    [super setUp];
    self.resourceManager = [[PCResourceManager alloc] init];
}

#pragma mark Tests

- (void)testGetImageAsync
{
    PCImage *image = [self.resourceManager imageWithId:@"123"
                             usingManagedObjectContext:self.resourceManager.mainManagedObjectContext
                                                 queue:[NSOperationQueue mainQueue]
                                         updateHandler:^(BOOL updated, NSError *error) {
                                             STAssertNil(error, [error localizedDescription]);
                                             STAssertTrue(updated, nil);
                                             STSuccess();
                                         }];
    STAssertNotNil(image, nil);
    STAssertEqualObjects(image.imageId, @"123", nil);
    
    STFailAfter(2.0, @"Timeout");
}

@end
