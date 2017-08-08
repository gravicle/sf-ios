//
//  NSAttributedString+Kerning.m
//  SF iOS
//
//  Created by Amit Jain on 8/2/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "NSAttributedString+Kerning.h"
@import UIKit;

@implementation NSAttributedString (Kerning)

+ (NSAttributedString *)kernedStringFromString:(NSString *)string {
    NSDictionary<NSAttributedStringKey, id> *kerning = @{NSKernAttributeName : @(0.82)};
    return [[NSAttributedString alloc] initWithString:string attributes:kerning];
}

@end
