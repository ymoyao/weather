//
//  EFCircularSlider.h
//  Awake
//
//  Created by Eliot Fowler on 12/3/13.
//  Copyright (c) 2013 Eliot Fowler. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EFCircularSlider;
@protocol EFCircularSliderDelegate <NSObject>

@optional


/**
 *  滚动滑条代理(开始)
 *
 *  @author 游辉
 *  @param slider       滑条
 *  @param currentValue 当前值
 *  @param minimumValue 最小值
 *  @param maximumValue 最大值
 */
- (void)circularSliderBeginWith:(EFCircularSlider *)slider andCurrentValue:(float)currentValue andMinimumValue:(float)minimumValue andMaximumValue:(float)maximumValue;

/**
 *  滚动滑条代理(实时)
 *
 *  @author 游辉
 *  @param slider       滑条
 *  @param currentValue 当前值
 *  @param minimumValue 最小值
 *  @param maximumValue 最大值
 */
- (void)circularSliderContinueWith:(EFCircularSlider *)slider andCurrentValue:(float)currentValue andMinimumValue:(float)minimumValue andMaximumValue:(float)maximumValue;

/**
 *  滚动滑条代理(结束)
 *
 *  @author 游辉
 *  @param slider       滑条
 *  @param currentValue 当前值
 *  @param minimumValue 最小值
 *  @param maximumValue 最大值
 */
- (void)circularSliderEndWith:(EFCircularSlider *)slider andCurrentValue:(float)currentValue andMinimumValue:(float)minimumValue andMaximumValue:(float)maximumValue;


@end
@interface EFCircularSlider : UIControl
typedef NS_ENUM(NSInteger, EFHandleType) {
    EFSemiTransparentWhiteCircle,
    EFSemiTransparentBlackCircle,
    EFDoubleCircleWithOpenCenter,
    EFDoubleCircleWithClosedCenter,
    EFBigCircle
};

@property (nonatomic, weak) id<EFCircularSliderDelegate> delegate;
@property (nonatomic) float minimumValue;
@property (nonatomic) float maximumValue;
@property (nonatomic) float currentValue;

@property (nonatomic) int lineWidth;
@property (nonatomic) int lineRadiusDisplacement;
@property (nonatomic, strong) UIColor* filledColor;
@property (nonatomic, strong) UIColor* unfilledColor;

@property (nonatomic, strong) UIColor* handleColor;
@property (nonatomic) EFHandleType handleType;

@property (nonatomic, strong) UIFont* labelFont;
@property (nonatomic, strong) UIColor* labelColor;
@property (nonatomic, assign) NSInteger labelDisplacement;
@property (nonatomic) BOOL snapToLabels;



-(void)setInnerMarkingLabels:(NSArray*)labels;

@end
