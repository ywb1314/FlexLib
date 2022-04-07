//
//  YGLayout+FlexBox.m
//  FlexLib
//
//  Created by admin on 2022/4/6.
//

#import "YGLayout+FlexBox.h"
#import <YogaKit/YGLayout+Private.h>
#import <YogaKit/UIView+Yoga.h>

@interface YGLayout ()

@property (nonatomic, weak, readonly) UIView *view;
@property(nonatomic, assign, readonly) BOOL isUIView;

@end

@implementation YGLayout (FlexBox)

- (void)applyFlexLayoutPreservingOrigin:(BOOL)preserveOrigin
               dimensionFlexibility:(YGDimensionFlexibility)dimensionFlexibility{
    CGSize size = self.view.bounds.size;
    if (dimensionFlexibility & YGDimensionFlexibilityFlexibleWidth) {
      size.width = YGUndefined;
    }
    if (dimensionFlexibility & YGDimensionFlexibilityFlexibleHeight) {
      size.height = YGUndefined;
    }
    [self calculateLayoutWithSize:size];
    YGApplyLayoutToViewHierarchy(self.view, preserveOrigin);
}

static CGFloat YGRoundPixelValue(CGFloat value)
{
  static CGFloat scale;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^(){
    scale = [UIScreen mainScreen].scale;
  });

  return roundf(value * scale) / scale;
}

static void YGApplyLayoutToViewHierarchy(UIView *view, BOOL preserveOrigin)
{
  const YGLayout *yoga = view.yoga;

  if (!yoga.isEnabled||!yoga.isIncludedInLayout) {
     return;
  }

  YGNodeRef node = yoga.node;
  const CGPoint topLeft = {
    YGNodeLayoutGetLeft(node),
    YGNodeLayoutGetTop(node),
  };

  const CGPoint bottomRight = {
    topLeft.x + YGNodeLayoutGetWidth(node),
    topLeft.y + YGNodeLayoutGetHeight(node),
  };

  const CGPoint origin = preserveOrigin ? view.frame.origin : CGPointZero;
  view.frame = (CGRect) {
    .origin = {
      .x = YGRoundPixelValue(topLeft.x + origin.x),
      .y = YGRoundPixelValue(topLeft.y + origin.y),
    },
    .size = {
      .width = YGRoundPixelValue(bottomRight.x) - YGRoundPixelValue(topLeft.x),
      .height = YGRoundPixelValue(bottomRight.y) - YGRoundPixelValue(topLeft.y),
    },
  };

  if (!yoga.isLeaf) {
    for (NSUInteger i=0; i<view.subviews.count; i++) {
      YGApplyLayoutToViewHierarchy(view.subviews[i], NO);
    }
  }
}

@end
