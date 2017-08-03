//
//  UIApplication+Metadata.m
//  SF iOS
//
//  Created by Amit Jain on 8/2/17.
//  Copyright © 2017 Amit Jain. All rights reserved.
//

#import "UIApplication+Metadata.h"

@implementation UIApplication (Metadata)

- (NSString *)bundleIdentifier {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
}

@end
