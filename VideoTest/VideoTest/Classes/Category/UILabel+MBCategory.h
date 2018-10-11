//
//  UILabel+MBCategory.h
//  MobileTeaching
//
//  Created by Apple on 2017/7/10.
//  Copyright © 2017年 mainbo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (MBCategory)
/**
 *  改变行间距
 */
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变字间距
 */
+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变行间距和字间距
 */
+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;


- (CGSize )sizeAdaptiveWithText:(NSString *)text andTextFont:(UIFont *)font andTextMaxSzie:(CGSize )size WithSpace:(float)space;

/**
 *  获取label自适应size
 */
+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font size:(CGSize)size;

+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont*)font;
- (void)alignTop;
// align bottom
- (void)alignBottom;
@end
