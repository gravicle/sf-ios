//
//  CloudKitDerivedRecord.h
//  SF iOS
//
//  Created by Amit Jain on 8/6/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CloudKit;

NS_ASSUME_NONNULL_BEGIN
@interface CloudKitDerivedRecord : NSObject

@property (class, nonatomic, readonly) NSString *recordName;
@property (nonatomic) NSString *identifier;
@property (nonatomic) NSDate *modificationDate;

- (instancetype)initWithRecord:(CKRecord *)record NS_DESIGNATED_INITIALIZER;

@end
NS_ASSUME_NONNULL_END
