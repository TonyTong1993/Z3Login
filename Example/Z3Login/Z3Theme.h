//
//  Z3Theme.h
//  Z3Login_Example
//
//  Created by 童万华 on 2019/6/14.
//  Copyright © 2019 Tony Tony. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
extern NSInteger const themeColorHexValue;//主题色值
extern NSInteger const separatorColorHexValue;//间隔线的色值
extern NSInteger const textTint;
extern NSInteger const textPrimaryTint ;//文本一级默认颜色
extern NSInteger const textSecondaryTint;//文本二级默认颜色
extern CGFloat const themeFontSize;//主题字体大小
extern CGFloat const themePrimaryFontSize;//一级字体大小
extern CGFloat const themeSecondaryFontSize;//二级字体大小
extern NSInteger const backgroundColorHexValue;
@interface Z3Theme : NSObject

@end

NS_ASSUME_NONNULL_END
