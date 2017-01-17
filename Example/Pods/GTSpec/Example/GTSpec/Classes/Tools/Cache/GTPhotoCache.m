//
//  DMPhotoCache.m
//  i8WorkClient
//
//  Created by 郭通 on 16/7/8.
//  Copyright © 2016年 郭通. All rights reserved.
//

#import "GTPhotoCache.h"

#import "GTPath.h"
#import <CommonCrypto/CommonDigest.h>
#import "UIImage+scale.h"
//#import "UIImage+Additions.h"

#define PhotosMessageDir ([[GTPath documentPath] stringByAppendingPathComponent:@"/PhotosMessageDir/"])

@interface GTPhotoCache()

@property (readonly, nonatomic) dispatch_queue_t ioQueue;
@property (nonatomic,retain) NSFileManager *fileManager;
@property (retain, nonatomic) NSCache *memCache;

- (NSString*)p_getKey;
- (void)p_storePhoto:(NSData *)photo forKey:(NSString *)key toDisk:(BOOL)toDisk;
- (NSString*)p_filePathForCacheKey:(NSString*)key;
- (NSData*)p_cacheFromDiskForKey:(NSString*)key;
- (NSData*)p_cacheFromMemoryForKey:(NSString*)key;

@end

@implementation GTPhotoCache

+(void)calculatePhotoSizeWithCompletionBlock:(void (^)(NSUInteger fileCount, NSUInteger totalSize))completionBlock
{
    NSURL *diskCacheURL = [NSURL fileURLWithPath:PhotosMessageDir isDirectory:YES];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSUInteger fileCount = 0;
        NSUInteger totalSize = 0;
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        NSDirectoryEnumerator *fileEnumerator = [fileManager enumeratorAtURL:diskCacheURL
                                                  includingPropertiesForKeys:@[NSFileSize]
                                                                     options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                errorHandler:NULL];
        
        for (NSURL *fileURL in fileEnumerator) {
            NSNumber *fileSize;
            [fileURL getResourceValue:&fileSize forKey:NSURLFileSizeKey error:NULL];
            totalSize += [fileSize unsignedIntegerValue];
            fileCount += 1;
        }
        
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(fileCount, totalSize);
            });
        }
    });
}
-(NSData *)photoFromDiskCacheForKey:(NSString *)key
{
    NSData *photoData = [self p_cacheFromMemoryForKey:key];
    if (photoData) {
        return photoData;
    }
    // Second check the disk cache...
    @autoreleasepool {
        NSData *diskphotoData = [self p_cacheFromDiskForKey:key];
        if (diskphotoData) {
            [self.memCache setObject:diskphotoData forKey:key ];
        }
        return diskphotoData;
    }
    
}
+ (GTPhotoCache *)sharedPhotoCache
{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
        
    });
    return instance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _ioQueue = dispatch_queue_create("com.boche.photo", DISPATCH_QUEUE_SERIAL);
        _memCache = [NSCache new];
        dispatch_sync(_ioQueue, ^{
            _fileManager = [NSFileManager new];
        });
        
    }
    return self;
}

- (NSString*)storeImage:(UIImage*)image
{
    float compressilibity = [UIImage coefficientOfCompressibilityForImage:image];
    return [self storeImage:image withCompressilibity:compressilibity];
}
- (void)storeImage:(UIImage*)image forKey:(NSString *)key
{
    float compressilibity = [UIImage coefficientOfCompressibilityForImage:image];
    NSData *photoData = UIImageJPEGRepresentation(image, compressilibity);
    [self p_storePhoto:photoData forKey:key toDisk:YES];
}
- (NSString*)storeImage:(UIImage *)image withCompressilibity:(float)compressilibity
{
    NSString *key = [self p_getKey];
    
    NSData *photoData = UIImageJPEGRepresentation(image, compressilibity);
    [self p_storePhoto:photoData forKey:key toDisk:YES];
    return key;
}

- (void)removePhotoForKey:(NSString *)key fromDisk:(BOOL)disk
{
    [self.memCache removeObjectForKey:key];
    
    if (disk)
    {
        dispatch_async(self.ioQueue, ^{
            NSString* filePath = [self p_filePathForCacheKey:key];
            [_fileManager removeItemAtPath:filePath error:nil];
        });
    }
}

- (NSUInteger)getDiskCacheSize
{
    __block NSUInteger size = 0;
    dispatch_sync(self.ioQueue, ^{
        NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtPath:PhotosMessageDir];
        for (NSString *fileName in fileEnumerator) {
            NSString *filePath = [PhotosMessageDir stringByAppendingPathComponent:fileName];
            NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
            size += [attrs fileSize];
        }
    });
    return size;
}

- (NSUInteger)getDiskCacheCount{
    __block int count = 0;
    dispatch_sync(self.ioQueue, ^{
        NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtPath:PhotosMessageDir];
        for (__unused NSString *fileName in fileEnumerator) {
            count += 1;
        }
    });
    return count;
}

- (UIImage*)imageForKey:(NSString*)key
{
    NSData *photoData = [self p_cacheFromMemoryForKey:key];
    if (photoData) {
        UIImage* image = [[UIImage alloc] initWithData:photoData];
        return image;
    }
    // Second check the disk cache...
    @autoreleasepool {
        NSData *diskphotoData = [self p_cacheFromDiskForKey:key];
        if (diskphotoData) {
            [self.memCache setObject:diskphotoData forKey:key ];
        }
        UIImage* image = [[UIImage alloc] initWithData:diskphotoData];
        return image;
    }
}

- (NSString*)filePathForKey:(NSString*)key
{
    NSString *filePath = [self p_filePathForCacheKey:key];
    return filePath;
}

- (NSOperation *)queryDiskCacheForKey:(NSString *)key done:(void (^)(NSData *photo))doneBlock {
    NSOperation *operation = [NSOperation new];
    
    if (!doneBlock) return nil;
    
    if (!key) {
        doneBlock(nil);
        return nil;
    }
    
    // First check the in-memory cache...
    NSData *photo = [self p_cacheFromMemoryForKey:key];
    if (photo) {
        doneBlock(photo);
        return nil;
    }
    
    dispatch_async(self.ioQueue, ^{
        if (operation.isCancelled) {
            return;
        }
        
        @autoreleasepool {
            NSData *diskPhotos = [self p_cacheFromDiskForKey:key];
            if (diskPhotos) {
                
                [self.memCache setObject:diskPhotos forKey:key];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                doneBlock(diskPhotos);
            });
        }
    });
    
    return operation;
}

#pragma mark -
#pragma mark PrivateAPI
- (NSString*)p_getKey
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYYMMddhhmmssSSS"];
    NSString *date =  [formatter stringFromDate:[NSDate date]];
    NSString *timeLocal = [[NSString alloc] initWithFormat:@"%@", date];
    return [NSString stringWithFormat:@"%@_send",timeLocal];
    
}

- (void)p_storePhoto:(NSData *)photo forKey:(NSString *)key toDisk:(BOOL)toDisk
{
    if (!photo || !key || key.length == 0) {
        return;
    }
    [self.memCache setObject:photo forKey:key];
    
    if (toDisk) {
        dispatch_async(self.ioQueue, ^{
            if (photo) {
                if (![_fileManager fileExistsAtPath:PhotosMessageDir]) {
                    [_fileManager createDirectoryAtPath:PhotosMessageDir withIntermediateDirectories:YES attributes:nil error:NULL];
                }
                NSString* filePath = [self p_filePathForCacheKey:key];
                [_fileManager createFileAtPath:filePath contents:photo attributes:nil];
            }
        });
    }
}

- (NSString*)p_filePathForCacheKey:(NSString*)key
{
    const char *str = [key UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    NSString* filePath = [PhotosMessageDir stringByAppendingPathComponent:filename];
    return filePath;
}

- (NSData*)p_cacheFromDiskForKey:(NSString*)key
{
    NSString *defaultPath = [self p_filePathForCacheKey:key];
    NSData *data = [NSData dataWithContentsOfFile:defaultPath];
    if (data) {
        return data;
    }
    return nil;
}

- (NSData*)p_cacheFromMemoryForKey:(NSString*)key
{
    return [self.memCache objectForKey:key];
}


@end
