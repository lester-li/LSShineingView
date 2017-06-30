//
//  LSShineingView.h
//  LSShineingLabel
//
//  Created by 李小帅 on 2017/6/29.
//  Copyright © 2017年 美好午后. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,LSShineingType) {
    LSShineingTypeLeftToRight = 0,
    LSShineingTypeRightToLeft,
    LSShineingTypeAlpha,
    LSShineingTypeNone
};

@interface LSShineingView : UIView


//label属性
@property (nonatomic,copy) NSString *text;
@property (nonatomic,strong) UIFont *font;
@property (nonatomic,strong) UIColor *textColor;
@property (nonatomic,assign) NSUInteger numberOfLines;

//view属性
@property (nonatomic,assign) LSShineingType shineType;
@property (nonatomic,strong) UIColor *shineingColor;
@property (nonatomic,assign) CGFloat shineingWidth;
@property (nonatomic,assign) CGFloat shineingRadius;
@property (nonatomic,assign) NSTimeInterval duration;
@property (nonatomic,assign) BOOL animationRepeat;

- (void)startShineing;

- (void)stopShineing;

@end
