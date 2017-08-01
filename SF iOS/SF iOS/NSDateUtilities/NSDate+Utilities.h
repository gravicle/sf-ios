//
//  NSDate+Utilities.h
//  SF iOS
//
//  Created by Amit Jain on 7/31/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Utilities)

@property (nonatomic, readonly, assign) BOOL isYesterday;
@property (nonatomic, readonly, assign) BOOL isToday;
@property (nonatomic, readonly, assign) BOOL isTomorrow;
@property (nullable, nonatomic, readonly) NSString *relativeDayRepresentation;
@property (nonatomic, readonly, assign) BOOL isThisYear;

@end
