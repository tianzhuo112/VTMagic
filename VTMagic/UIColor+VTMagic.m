//
//  UIColor+VTMagic.m
//  VTMagic
//
//  Created by tianzhuo on 15/7/23.
//  Copyright (c) 2015年 tianzhuo. All rights reserved.
//

#import "UIColor+VTMagic.h"
#import "VTMagicMacros.h"

const VTColor VTColorZero;

VTColor VTColorMake(CGFloat red, CGFloat green, CGFloat blue, CGFloat alph) {
    VTColor color;
    color.red = red; color.green = green;
    color.blue = blue; color.alph = alph;
    return color;
}

VTColor VTColorScale(VTColor color, CGFloat scale) {
    VTColor scaleColor;
    scaleColor.red = color.red * scale;
    scaleColor.green = color.green * scale;
    scaleColor.blue = color.blue * scale;
    scaleColor.alph = color.alph * scale;
    return scaleColor;
}

VTColor VTColorAdd(VTColor aColor1, VTColor aColor2) {
    VTColor finalColor;
    finalColor.red = aColor1.red + aColor2.red;
    finalColor.green = aColor1.green + aColor2.green;
    finalColor.blue = aColor1.blue + aColor2.blue;
    finalColor.alph = aColor1.alph + aColor2.alph;
    return finalColor;
}

VTColor VTColorReduce(VTColor aColor, VTColor reductionColor) {
    VTColor finalColor;
    finalColor.red = aColor.red - reductionColor.red;
    finalColor.green = aColor.green - reductionColor.green;
    finalColor.blue = aColor.blue - reductionColor.blue;
    finalColor.alph = aColor.alph - reductionColor.alph;
    return finalColor;
}

BOOL VTColorIsEqual(VTColor aColor1, VTColor aColor2) {
    if (aColor1.red != aColor2.red) {
        return NO;
    }
    if (aColor1.green != aColor2.green) {
        return NO;
    }
    if (aColor1.blue != aColor2.blue) {
        return NO;
    }
    if (aColor1.alph != aColor2.alph) {
        return NO;
    }
    return YES;
}

BOOL VTColorIsZero(VTColor aColor) {
    return VTColorIsEqual(VTColorZero, aColor);
}

@implementation UIColor (VTMagic)

- (VTColor)vtm_changeToVTColor {
    VTColor color;
    if ([self respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        [self getRed:&color.red green:&color.green blue:&color.blue alpha:&color.alph];
    } else {
        VTLog(@"change UIColor to VTColor error");
    }
    return color;
}

+ (UIColor *)vtm_colorWithVTColor:(VTColor)color {
    return [UIColor colorWithRed:color.red green:color.green blue:color.blue alpha:color.alph];
}

+ (UIColor *)vtm_compositeColor:(VTColor)baseColor anoColor:(VTColor)anoColor scale:(CGFloat)scale {
    VTColor diffColor = VTColorReduce(anoColor, baseColor);
    VTColor offsetColor = VTColorScale(diffColor, scale);
    return [self vtm_colorWithVTColor:VTColorAdd(baseColor, offsetColor)];
}

@end
