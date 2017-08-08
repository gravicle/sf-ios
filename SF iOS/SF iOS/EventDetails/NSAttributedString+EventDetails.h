//
//  NSAttributedString+EventDetails.h
//  SF iOS
//
//  Created by Amit Jain on 8/8/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"

@interface NSAttributedString (EventDetails)

+ (NSAttributedString *)attributedDetailsStringFromEvent:(Event *)event;

@end
