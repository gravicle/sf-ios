//
//  Location.m
//  SF iOS
//
//  Created by Amit Jain on 7/28/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "Location.h"

@implementation Location

- (instancetype)initWithRecord:(CKRecord *)record {
    if (self = [super initWithRecord:record]) {
        self.name = record[@"name"];
        self.streetAddress = record[@"streetAddress"];
        self.location = record[@"location"];
        self.imageFileURL = [(CKAsset *)record[@"image"] fileURL];
    }
    
    return self;
}

@end
