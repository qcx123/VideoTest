//
//  UIColor+Extension.h
//  
//
//  Created by wyy on 16/10/11.
//  Copyright © 2016年 yyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)
/**
 *
 *
 *  @param hexString 例如#DF1342的
 *
 *  @return <#return value description#>
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)colorWithHex:(NSUInteger)color alpha:(CGFloat)alpha;
+ (UIColor *)randomColor;
#pragma mark 实现搜索条背景透明化
+ (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height;

@end
