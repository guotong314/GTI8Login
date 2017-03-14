//
//  UIImageView+size.m
//  i8WorkClient
//
//  Created by 郭通 on 17/1/25.
//  Copyright © 2017年 郭通. All rights reserved.
//

#import "UIImageView+size.h"

@implementation UIImageView(size)

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void) cropSize:(CGSize)imageSize withViewSize:(CGSize)viewSize
{
    float W = viewSize.width;
    float H = viewSize.height;
    float w = imageSize.width;
    float h = imageSize.height;
    
    CGSize tagerSize;
    if (w > W || h > H) {
        if (w > W && h> H) {
            if (w/W < h/H) {
                tagerSize = CGSizeMake(w * H /h, H);
            }else{
                tagerSize = CGSizeMake(W,h * W/w);
            }
        }else if(w > W){
            tagerSize = CGSizeMake(W, h * W/w);
        }else{
            tagerSize = CGSizeMake(w * H/h, H);
        }
        
    }
    else{
        if (w/W < h/H) {
            tagerSize = CGSizeMake(w * H / h, H);
        }
        else{
            tagerSize = CGSizeMake(W, h * W/w);
        }
        
    }
    self.size = tagerSize;
}

@end
