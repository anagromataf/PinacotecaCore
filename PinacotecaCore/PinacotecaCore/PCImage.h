//
//  PCImage.h
//  PinacotecaCore
//
//  Created by Tobias Kräntzer on 23.06.13.
//  Copyright (c) 2013 Tobias Kräntzer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PCImage : NSManagedObject

+ (instancetype)createInManagedObjectContext:(NSManagedObjectContext *)context;

@property (nonatomic, readonly) NSString *imageId;
@property (nonatomic, readonly) NSString *url;
@property (nonatomic, readwrite) NSString *title;

@end
