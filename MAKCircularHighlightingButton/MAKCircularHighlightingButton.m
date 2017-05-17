//
//  MAKCircularHighlightingButton.m
//  MAKCircularHighlightingButton
//
//  Created by Martin Kloepfel on 06.12.14.
//  Copyright (c) 2014 Martin Klöpfel. All rights reserved.
//

#if !__has_feature(objc_arc)
#error "This file requires ARC!"
#endif


#import "MAKCircularHighlightingButton.h"
#import "MAKMath.h"


@interface MAKCircularHighlightingButton ()

@property (nonatomic, strong) UIView *clipView;
@property (nonatomic, strong) UIView *circleView;

@property (nonatomic, strong) UITouch *lastTouch;


@property (nonatomic) BOOL isAnimating;

@end


@implementation MAKCircularHighlightingButton

#pragma mark - Initializers

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.adjustsImageWhenHighlighted = NO;
        
        self.clipView = [[UIView alloc] initWithFrame:self.bounds];
        self.clipView.userInteractionEnabled = NO;
        self.clipView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.clipView.clipsToBounds = YES;
        self.clipView.layer.shouldRasterize = YES;
        [self insertSubview:self.clipView atIndex:0];
        
        self.circleView = [[UIView alloc] initWithFrame:self.bounds];
        self.circleView.clipsToBounds = YES;
        self.circleView.layer.shouldRasterize = YES;
        self.circleView.hidden = YES;
        [self.clipView addSubview:self.circleView];
    }
    return self;
}


#pragma mark - Touch handling

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ([super beginTrackingWithTouch:touch withEvent:event])
    {
        self.lastTouch = touch;
        return YES;
    }
    return NO;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ([super continueTrackingWithTouch:touch withEvent:event])
    {
        self.lastTouch = touch;
        return YES;
    }
    return NO;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super endTrackingWithTouch:touch withEvent:event];

    self.lastTouch = nil;
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    [super cancelTrackingWithEvent:event];
    
    self.lastTouch = nil;
}


#pragma mark - Getter & setter mehtods

- (void)setHighlighted:(BOOL)highlighted
{
    BOOL stateChanged = self.isHighlighted != highlighted;
    
    [super setHighlighted:highlighted];
    
    if (!stateChanged || self.isAnimating || !self.highlightColor)
        return;
    
    self.circleView.hidden = !highlighted;
    
    if(highlighted)
    {
        CGPoint touchPoint = CGPointMake(floorf(self.frame.size.width/2.0f), floorf(self.frame.size.width/2.0f));;
        if (self.lastTouch)
            touchPoint = [self.lastTouch locationInView:self];
        
        CGFloat deltaA = dist(touchPoint, CGPointZero);
        CGFloat deltaB = dist(touchPoint, CGPointMake(self.frame.size.width, 0.0f));
        CGFloat deltaC = dist(touchPoint, CGPointMake(0.0f, self.frame.size.height));
        CGFloat deltaD = dist(touchPoint, CGPointMake(self.frame.size.width, self.frame.size.height));
        
        CGFloat r = MAX(MAX(deltaA, deltaB), MAX(deltaC, deltaD));
        
        self.circleView.frame = CGRectMake(0.0f, 0.0f, r*2, r*2);
        self.circleView.layer.cornerRadius = r;
        self.circleView.center = touchPoint;
        self.circleView.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
        
        self.isAnimating = YES;
        
        [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationCurveEaseOut animations:^{
            self.circleView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        } completion:^(BOOL finished) {
            if (!self.isHighlighted)
                self.circleView.hidden = YES;
            self.isAnimating = NO;
        }];
    }
}

- (void)setHighlightColor:(UIColor *)highlightColor
{
    self.circleView.backgroundColor = highlightColor;
}

- (UIColor *)highlightColor
{
    return self.circleView.backgroundColor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
    self.clipView.layer.cornerRadius = cornerRadius;
    
    if (cornerRadius > 0)
    {
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    }
}

- (CGFloat)cornerRadius
{
    return self.layer.cornerRadius;
}

- (void)addSubview:(UIView *)view
{
    [super addSubview:view];
    
    [self sendSubviewToBack:self.clipView];
}

- (void)insertSubview:(UIView *)view atIndex:(NSInteger)index
{
    [super insertSubview:view atIndex:0];
    
    [self sendSubviewToBack:self.clipView];

}

- (void)insertSubview:(UIView *)view aboveSubview:(UIView *)siblingSubview
{
    [super insertSubview:view aboveSubview:siblingSubview];
    
    [self sendSubviewToBack:self.clipView];

}

- (void)insertSubview:(UIView *)view belowSubview:(UIView *)siblingSubview
{
    [super insertSubview:view belowSubview:siblingSubview];
    
    [self sendSubviewToBack:self.clipView];

}

@end
