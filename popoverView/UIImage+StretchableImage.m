//
//  UIImage+StretchableImage.m
//  改版月历
//
//  Created by hy1 on 16/1/28.
//  Copyright © 2016年 oxxther. All rights reserved.
//

#import "UIImage+StretchableImage.h"

@implementation UIImage (StretchableImage)

+ (instancetype)imageWithStretchableName:(NSString *)imageName{
    UIImage *image = [UIImage imageNamed:imageName];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}

@end
