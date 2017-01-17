//
//  DMPhotoCache.h
//  i8WorkClient
//
//  Created by 郭通 on 16/7/8.
//  Copyright © 2016年 郭通. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^cacheblock)(BOOL isFinished);

@interface GTPhotoCache : NSObject

+ (void)calculatePhotoSizeWithCompletionBlock:(void (^)(NSUInteger fileCount, NSUInteger totalSize))completionBlock;
+ (GTPhotoCache *)sharedPhotoCache;

- (NSString*)storeImage:(UIImage*)image;
- (void)storeImage:(UIImage*)image forKey:(NSString *)key;
- (NSString*)storeImage:(UIImage *)image withCompressilibity:(float)compressilibity;
- (void)removePhotoForKey:(NSString *)key fromDisk:(BOOL)disk;
- (NSUInteger)getDiskCacheSize;
- (NSUInteger)getDiskCacheCount;
- (UIImage*)imageForKey:(NSString*)key;
- (NSString*)filePathForKey:(NSString*)key;

- (NSOperation *)queryDiskCacheForKey:(NSString *)key done:(void (^)(NSData *voice))doneBlock;

@end
