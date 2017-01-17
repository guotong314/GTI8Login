//
//  NSDictionary+JSONString.m
//  Higirl
//
//  Created by bailu on 10/30/14.
//  Copyright (c) 2014 ___MEILISHUO___. All rights reserved.
//

#import "NSDictionary+JSONString.h"

@implementation NSDictionary (JSONString)

- (NSString*)JSONString
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
    
    if (!jsonData) {
        DMLog(@"NSDictionary+JSONString error: %@", error.localizedDescription);
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

@end
