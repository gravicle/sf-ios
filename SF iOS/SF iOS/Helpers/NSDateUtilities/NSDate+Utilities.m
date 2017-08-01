//
//  NSDate+Utilities.m
//  SF iOS
//
//  Created by Amit Jain on 7/31/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "NSDate+Utilities.h"

@implementation NSDate (Utilities)

- (BOOL)isYesterday {
    return [[NSCalendar currentCalendar] isDateInYesterday:self];
}

- (BOOL)isToday {
    return [[NSCalendar currentCalendar] isDateInToday:self];
}

- (BOOL)isTomorrow {
    return [[NSCalendar currentCalendar] isDateInTomorrow:self];
}

-(NSString *)relativeDayRepresentation {
    if (self.isYesterday) {
        return @"Yesterday";
    } else if (self.isToday) {
        return @"Today";
    } else if (self.isTomorrow) {
        return @"Tomorrow";
    } else {
        return nil;
    }
}

- (BOOL)isThisYear {
    NSInteger dateYear = [[NSCalendar currentCalendar] component:NSCalendarUnitYear fromDate:self];
    NSInteger currentYear = [[NSCalendar currentCalendar] component:NSCalendarUnitYear fromDate:[NSDate new]];
    return  dateYear == currentYear;
}

@end
