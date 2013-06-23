//
//  PCImage+Private.h
//  PinacotecaCore
//
//  Created by Tobias Kräntzer on 23.06.13.
//  Copyright (c) 2013 Tobias Kräntzer. All rights reserved.
//

#import "PCImage.h"

@interface PCImage (Private)

@property (nonatomic, readwrite, strong) NSString *imageId;
@property (nonatomic, readwrite, strong) NSString *title;
@property (nonatomic, readwrite, strong) NSString *url;

@end
