//
//  UIColor+VTMagic.h
//  VTMagic
//
//  Created by tianzhuo on 15/7/23.
//  Copyright (c) 2015年 tianzhuo. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  VTColor结构体对象，用来存放颜色的RGBA值
 */
typedef struct {
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alph;
} VTColor;

/** 各项值为0的VTColor对象 */
CG_EXTERN const VTColor VTColorZero;

/** 等比放大VTColor对象的各项值 */
CG_EXTERN VTColor VTColorScale(VTColor color, CGFloat scale);

/** 将两个VTColor对象的各项值相加，计算其和 */
CG_EXTERN VTColor VTColorAdd(VTColor aColor1, VTColor aColor2);

/** 将两个VTColor的各项值相减，计算其差值 */
CG_EXTERN VTColor VTColorReduce(VTColor aColor, VTColor reductionColor);

/** 判断两个VTColor对象是否相等 */
CG_EXTERN BOOL VTColorIsEqual(VTColor aColor1, VTColor aColor2);

/** 判断VTColor对象的各项值是否为0 */
CG_EXTERN BOOL VTColorIsZero(VTColor aColor);

/** 初始化一个VTColor结构体对象 */
CG_EXTERN VTColor VTColorMake(CGFloat red, CGFloat green, CGFloat blue, CGFloat alph);

@interface UIColor (VTMagic)

/**
 *  将UIColor转成对应的RGBA色值
 *
 *  @return VTColor结构体
 */
- (VTColor)vtm_changeToVTColor;

/**
 *  将VTColor转成对应的UIColor
 *
 *  @param color VTColor
 *
 *  @return UIColor对象
 */
+ (UIColor *)vtm_colorWithVTColor:(VTColor)color;

/**
 *  按指定比例对给定的两种颜色进行合成，并返回对应的UIColor对象
 *
 *  @param baseColor 基础颜色
 *  @param anoColor  参考颜色
 *  @param scale     合成比例，scale为0时返回baseColor对应的颜色，scale为1时返回anoColor对应的颜色
 *
 *  @return 合成颜色UIColor对象
 */
+ (UIColor *)vtm_compositeColor:(VTColor)baseColor anoColor:(VTColor)anoColor scale:(CGFloat)scale;

@end
