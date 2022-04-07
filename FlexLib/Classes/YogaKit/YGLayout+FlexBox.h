//
//  YGLayout+FlexBox.h
//  FlexLib
//
//  Created by admin on 2022/4/6.
//

#import <YogaKit/YGLayout.h>

NS_ASSUME_NONNULL_BEGIN

@interface YGLayout (FlexBox)

- (void)applyFlexLayoutPreservingOrigin:(BOOL)preserveOrigin
               dimensionFlexibility:(YGDimensionFlexibility)dimensionFlexibility;

@end

NS_ASSUME_NONNULL_END
