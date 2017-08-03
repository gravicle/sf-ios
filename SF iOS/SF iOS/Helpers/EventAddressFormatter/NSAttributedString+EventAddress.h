//
//  NSAttributedString+EventAddress.h
//  SF iOS
//
//  Created by Amit Jain on 8/2/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (EventAddress)

+ (NSAttributedString *)eventAddressAttributedStringFromAddress:(NSString *)address;

@end
