//
//  NSArray+JSONString.m
//  Higirl
//
//  Created by bailu on 10/30/14.
//  Copyright (c) 2014 ___MEILISHUO___. All rights reserved.
//

#import "NSArray+JSONString.h"

@implementation NSArray (JSONString)

- (NSString*)JSONString
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
    
    if (!jsonData) {
        DMLog(@"NSArray+JSONString error: %@", error.localizedDescription);
        return @"[]";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

@end
