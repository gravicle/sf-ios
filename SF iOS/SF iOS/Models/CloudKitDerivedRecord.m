//
//  CloudKitDerivedRecord.m
//  SF iOS
//
//  Created by Amit Jain on 8/6/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "CloudKitDerivedRecord.h"

@implementation CloudKitDerivedRecord

+ (NSString *)recordName {
    return NSStringFromClass([self class]);
}

- (instancetype)initWithRecord:(CKRecord *)record {
    if (self = [super init]) {
        self.identifier = record.recordID.recordName;
        self.modificationDate = record.modificationDate;
    }
    return self;
}

- (instancetype)init {
    NSAssert(false, @"Use initWithRecord:");
    return [self initWithRecord:[CKRecord new]];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[self class]]) {
        return false;
    }
    return [self.identifier isEqualToString: [(CloudKitDerivedRecord *)object identifier]];
}

@end
