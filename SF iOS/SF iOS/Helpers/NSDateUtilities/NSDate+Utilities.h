//
//  NSDate+Utilities.h
//  SF iOS
//
//  Created by Amit Jain on 7/31/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface NSDate (Utilities)

@property (nonatomic, readonly, assign) BOOL isYesterday;
@property (nonatomic, readonly, assign) BOOL isToday;
@property (nonatomic, readonly, assign) BOOL isTomorrow;
@property (nonatomic, readonly, assign) BOOL isThisYear;
@property (nonatomic, readonly, assign) BOOL isInFuture;
@property (nullable, nonatomic, readonly) NSString *relativeDayRepresentation;

@property (nonatomic, readonly) NSString *abbreviatedTimeintervalFromNow;

+ (NSString *)abbreviatedTimeIntervalForTimeInterval:(NSTimeInterval)timeInterval;

+ (NSString *)timeslotStringFromStartDate:(NSDate *)startDate duration:(NSTimeInterval)duration;

- (NSString *)stringWithformat:(NSString *)format;

@end
NS_ASSUME_NONNULL_END
