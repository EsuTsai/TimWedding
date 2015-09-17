//
//  NSString+Height.m
//  TimWedding
//
//  Created by Esu Tsai on 2015/9/18.
//  Copyright (c) 2015年 Esu Tsai. All rights reserved.
//

#import "NSString+Height.h"

@implementation NSString (Height)

+ (NSString *)circulateLabelHeight:(NSString *)labelText labelWidth:(CGFloat)width labelFont:(UIFont *)font
{
    CGSize size = CGSizeMake(width, MAXFLOAT);
    NSString *str =labelText;
    UIFont *textFont = font;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:textFont,NSFontAttributeName, nil];
    CGSize actualSize = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    NSString *actualHeight = [NSString stringWithFormat:@"%f",actualSize.height];
    return actualHeight;
}

@end
