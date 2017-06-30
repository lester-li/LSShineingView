//
//  LSShineingView.m
//  LSShineingLabel
//
//  Created by 李小帅 on 2017/6/29.
//  Copyright © 2017年 美好午后. All rights reserved.
//

#import "LSShineingView.h"

#define LS_SHINE_TRANSLATEANIMATIONKEY @"LS_SHINE_TRANSLATEANIMATIONKEY"
#define LS_SHINE_ALPHAKEY @"LS_SHINE_ALPHAKEY"


@interface LSShineingView ()

@property (nonatomic,strong) UILabel *contentL;
@property (nonatomic,strong) UILabel *maskL;
@property (nonatomic,strong) CAGradientLayer *gradientLayer;

@property (nonatomic,assign) CATransform3D startTransform,endTransform;
@property (nonatomic,assign) CGSize textSize;

@property (nonatomic,assign) BOOL isPlaying;

@property (nonatomic,strong) CABasicAnimation *translateAnimation;
@property (nonatomic,strong) CABasicAnimation *alphaAnimation;


@end

@implementation LSShineingView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initial];
    }
    return self;
}

- (void)initial{
    _text = @"";
    _textColor = [UIColor blackColor];
    _font = [UIFont systemFontOfSize:17];
    _numberOfLines = 0;
    
    _shineType = LSShineingTypeNone;
    _shineingColor = [UIColor yellowColor];
    _shineingWidth = 10;
    _shineingRadius = _shineingWidth/2.0;
    _duration = 5;
    _textSize = CGSizeMake(0, 0);
    _isPlaying = NO;
    _startTransform = CATransform3DIdentity;
    _endTransform = CATransform3DIdentity;
    
    [self addSubview:self.contentL];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect frame = self.frame;
    frame.size = CGSizeMake(self.textSize.width,self.textSize.height);
    self.frame = frame;
    
    self.contentL.frame = self.bounds;
    self.maskL.frame = self.bounds;
    self.gradientLayer.frame = CGRectMake(0, 0, self.textSize.width,self.textSize.height);
}

-(UILabel *)contentL{
    if (!_contentL) {
        _contentL = [[UILabel alloc] initWithFrame:self.bounds];
    }
    _contentL.text = self.text;
    _contentL.textColor = self.textColor;
    _contentL.font = self.font;
    _contentL.numberOfLines = self.numberOfLines;
    
    return _contentL;
}

-(UILabel *)maskL{
    if (!_maskL) {
        _maskL = [[UILabel alloc] initWithFrame:self.bounds];
        _maskL.hidden = YES;
    }
    [self addSubview:_maskL];
    return _maskL;
}

-(CAGradientLayer *)gradientLayer{
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
    }
    return _gradientLayer;
}

-(CABasicAnimation *)translateAnimation{
    if (!_translateAnimation) {
        _translateAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    }
    _translateAnimation.duration = self.duration;
    _translateAnimation.autoreverses = self.animationRepeat ? YES : NO;
    _translateAnimation.repeatCount = MAXFLOAT;
    return _translateAnimation;
}

-(CABasicAnimation *)alphaAnimation{
    if (!_alphaAnimation) {
        _alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        _alphaAnimation.autoreverses = YES;
        _alphaAnimation.repeatCount = MAXFLOAT;
        _alphaAnimation.fromValue = @(1.0);
        _alphaAnimation.toValue = @(0.0);
    }
    _alphaAnimation.duration = self.duration;
    return _alphaAnimation;
}

-(void)setText:(NSString *)text{
    _text = text;
    [self update];
    self.textSize = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT) oçptions:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size;
}

-(void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    [self update];
}

-(void)setFont:(UIFont *)font{
    _font = font;
    [self update];
    self.textSize = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT) oçptions:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size;
}

-(void)setNumberOfLines:(NSUInteger)numberOfLines{
    _numberOfLines = numberOfLines;
    [self update];
}

-(void)setShineType:(LSShineingType)shineType{
    _shineType = shineType;
    [self update];
}

-(void)setShineingWidth:(CGFloat)shineingWidth{
    _shineingWidth = shineingWidth;
    [self update];
}

-(void)setShineingRadius:(CGFloat)shineingRadius{
    _shineingRadius = shineingRadius;
    [self update];
}

-(void)setShineingColor:(UIColor *)shineingColor{
    _shineingColor = shineingColor;
    [self update];
}

-(void)setDuration:(NSTimeInterval)duration{
    _duration = duration;
    [self update];
}

- (void)update{
    if (self.isPlaying) {
        [self stopShineing];
        [self startShineing];
    }
}

- (void)startShineing{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.isPlaying || (self.shineType == LSShineingTypeNone))  return ;
        self.isPlaying = YES;
        
        self.maskL.hidden = NO;
        [self addSubview:self.maskL];

        //设置masklayer的属性，并让其移动
        [self coppyAttrForm:self.contentL to:self.maskL];
        
        [self.gradientLayer removeFromSuperlayer];
        [self freshGradientLayer];

        [self.maskL.layer addSublayer:self.gradientLayer];
        self.maskL.layer.mask = self.gradientLayer;
        self.gradientLayer.frame = self.maskL.bounds;
        
        switch (self.shineType) {
            case LSShineingTypeLeftToRight:{
                self.gradientLayer.transform = self.startTransform;
                self.translateAnimation.fromValue = [NSValue valueWithCATransform3D:self.startTransform];
                self.translateAnimation.toValue = [NSValue valueWithCATransform3D:self.endTransform];
                [self.gradientLayer removeAllAnimations];
                [self.gradientLayer addAnimation:self.translateAnimation forKey:LS_SHINE_TRANSLATEANIMATIONKEY];
                break;
            }
            case LSShineingTypeRightToLeft:{
                self.gradientLayer.transform = self.endTransform;
                self.translateAnimation.fromValue = [NSValue valueWithCATransform3D:self.endTransform];
                self.translateAnimation.toValue = [NSValue valueWithCATransform3D:self.startTransform];
                [self.gradientLayer removeAllAnimations];
                [self.gradientLayer addAnimation:self.translateAnimation forKey:LS_SHINE_TRANSLATEANIMATIONKEY];
                break;
            }
            case LSShineingTypeAlpha:{
                [self.gradientLayer removeAllAnimations];
                [self.gradientLayer addAnimation:self.alphaAnimation forKey:LS_SHINE_ALPHAKEY];
                break;
            }
            default:
                break;
        }
    });
}


- (void)stopShineing{
    //移除masklayer属性，停止移动
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (!self.isPlaying) return;
        self.isPlaying = NO;
        
        [self.gradientLayer removeAllAnimations];
        [self.gradientLayer removeFromSuperlayer];
        self.maskL.hidden = YES;
    });
}


- (void)freshGradientLayer{
    
    switch (self.shineType) {
        case LSShineingTypeAlpha:{
            self.gradientLayer.backgroundColor = self.shineingColor.CGColor;
            self.gradientLayer.colors = nil;
            self.gradientLayer.locations = nil;
            break;
        }
        default:{
            CGFloat textSizeWidth = self.textSize.width;
            _shineingWidth = (self.shineingWidth*2 < textSizeWidth) ? self.shineingWidth : textSizeWidth/2.0;
            _shineingRadius = self.shineingWidth/2.0;
            
            CGFloat shineRatio = (self.shineingWidth) / textSizeWidth * 0.5;
            CGFloat radiusShineRatio = (self.shineingRadius)/ textSizeWidth;
            
            self.gradientLayer.locations = @[@(0.0),@(0.5 - shineRatio - radiusShineRatio),@(0.5 - shineRatio),@(0.5 + shineRatio),@(0.5 + shineRatio + radiusShineRatio),@(1),];
            self.gradientLayer.colors = @[(id)[UIColor clearColor].CGColor,(id)[UIColor clearColor].CGColor,(id)[UIColor whiteColor].CGColor,(id)[UIColor whiteColor].CGColor,(id)[UIColor clearColor].CGColor,(id)[UIColor clearColor].CGColor,];
            
            self.gradientLayer.backgroundColor = [UIColor clearColor].CGColor;
            
            self.gradientLayer.startPoint = CGPointMake(0, 0.5);
            self.gradientLayer.endPoint = CGPointMake(1, 0.5);
            
            CGFloat startX = self.textSize.width * (0.5 - shineRatio - radiusShineRatio);
            CGFloat endX = self.textSize.width * (0.5 + shineRatio + radiusShineRatio);
            self.startTransform = CATransform3DMakeTranslation(-endX, 0, 1);
            self.endTransform = CATransform3DMakeTranslation(self.textSize.width - startX, 0, 1);
        }
            break;
    }
}

- (void)coppyAttrForm:(UILabel*)contentL to:(UILabel*)maskL{
    maskL.text = contentL.text;
    maskL.font = contentL.font;
    maskL.numberOfLines = contentL.numberOfLines;
    maskL.frame = contentL.frame;

    maskL.textColor = self.shineingColor;
}



@end
