//
//  UIViewController+InteractivePushGesture.m
//  https://github.com/xiaopin/InteractivePushGesture.git
//
//  Created by nhope on 2018/5/14.
//  Copyright © 2018年 xiaopin. All rights reserved.
//

#import "UIViewController+InteractivePushGesture.h"
#import <objc/message.h>



#pragma mark - 动画执行者

@interface DKInteractivePushAnimatedTransitioning: NSObject <UIViewControllerAnimatedTransitioning>

@end

@implementation DKInteractivePushAnimatedTransitioning

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    if (toView) {
        [transitionContext.containerView addSubview:toView];
    }
    
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
    toView.frame = CGRectOffset(finalFrame, finalFrame.size.width, 0.0);
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
        toView.frame = finalFrame;
    } completion:^(BOOL finished) {
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
    }];
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 1.0;
}

@end

#pragma mark - 导航栏控制器代理

@interface DKNavigationControllerDelegateObject: NSObject <UINavigationControllerDelegate>

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactiveTransition;
@property (nonatomic, assign) CGPoint touchBeganPoint;

@end

@implementation DKNavigationControllerDelegateObject

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    if ([animationController isKindOfClass:[DKInteractivePushAnimatedTransitioning class]]) {
        return self.interactiveTransition;
    }
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPush) {
        return [[DKInteractivePushAnimatedTransitioning alloc] init];
    }
    return nil;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    /// 显示完毕后,重置delegate,启用原生pop手势
    navigationController.delegate = nil;
}

@end

#pragma mark - 手势代理

@interface DKGestureRecognizerDelegateObject: NSObject <UIGestureRecognizerDelegate>

+ (instancetype)shared;

@end

@implementation DKGestureRecognizerDelegateObject : NSObject

+ (instancetype)shared {
    static DKGestureRecognizerDelegateObject *object = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object = [[DKGestureRecognizerDelegateObject alloc] init];
    });
    return object;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
//    //在这里判断是百度地图的view 既可以实现手势拖动 scrollview 的滚动关闭
//    if (touch){
//        self.scrollview.scrollEnabled = NO;
//        return YES;
//    }else{
//
//        self.scrollview.scrollEnabled = YES;
//        return NO;
//    }
//
//}

@end

#pragma mark -

static const char DKInteractivePushGestureDelegateKey;

PanState panState = PanState_End;

@implementation UIViewController (InteractivePushGesture)

#pragma mark Actions

- (void)handlePanGesture:(UIPanGestureRecognizer *)sender {
    DKNavigationControllerDelegateObject *delegate = objc_getAssociatedObject(self, &DKInteractivePushGestureDelegateKey);
    CGPoint currentTouchPoint = [sender locationInView:self.view];
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
        {
            NSParameterAssert(self.interactivePushGestureDelegate != nil);
            NSParameterAssert(self.navigationController != nil);
            if (![self isInteractivePushGestureEnabled]) {
                return;
            }
            delegate = [[DKNavigationControllerDelegateObject alloc] init];
            delegate.interactiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
            delegate.touchBeganPoint = currentTouchPoint;
            self.navigationController.delegate = delegate;
            objc_setAssociatedObject(self, &DKInteractivePushGestureDelegateKey, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            UIViewController *destinationViewController = [self.interactivePushGestureDelegate destinationViewControllerFromViewController:self];
            NSAssert(destinationViewController != nil, @"`-destinationViewControllerFromViewController:` cann't return nil.");
            [self.navigationController pushViewController:destinationViewController animated:YES];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            if (CGPointEqualToPoint(delegate.touchBeganPoint, CGPointZero) || currentTouchPoint.x > delegate.touchBeganPoint.x) {
                return;
            }
            
            if (panState == PanState_End) {
                CGFloat absX = fabs(delegate.touchBeganPoint.x - currentTouchPoint.x);
                CGFloat absY = fabs(delegate.touchBeganPoint.y - currentTouchPoint.y);
                if (absX > absY) {// 左右
                    panState = PanState_LeftRight;
                    if (self.interactivePushGestureDelegate && [self.interactivePushGestureDelegate respondsToSelector:@selector(lockScrollViewWithPanState:)]) {
                        [self.interactivePushGestureDelegate lockScrollViewWithPanState:panState];
                    }
                } else if (absY > absX) {// 上下
                    panState = PanState_UpDown;
                }
            }
            if (panState == PanState_LeftRight) {
                CGFloat percent = (delegate.touchBeganPoint.x - currentTouchPoint.x) / CGRectGetWidth(self.view.frame);
                [delegate.interactiveTransition updateInteractiveTransition:percent];
            }else if (panState == PanState_UpDown) {
                if (self.interactivePushGestureDelegate && [self.interactivePushGestureDelegate respondsToSelector:@selector(refreshScrollViewWithGesture:)]) {
                    [self.interactivePushGestureDelegate refreshScrollViewWithGesture:sender];
                }
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            CGFloat percent = (delegate.touchBeganPoint.x - currentTouchPoint.x) / CGRectGetWidth(self.view.frame);
            if (percent >= 0.3) {
                [delegate.interactiveTransition finishInteractiveTransition];
            } else {
                [delegate.interactiveTransition cancelInteractiveTransition];
            }
            delegate.touchBeganPoint = CGPointZero;
            if (panState != PanState_End) {
                panState = PanState_End;
                if (self.interactivePushGestureDelegate && [self.interactivePushGestureDelegate respondsToSelector:@selector(lockScrollViewWithPanState:)]) {
                    [self.interactivePushGestureDelegate lockScrollViewWithPanState:panState];
                }
            }
            break;
        }
        default:
            delegate.touchBeganPoint = CGPointZero;
            break;
    }
}

#pragma mark setter & getter

- (void)setInteractivePushGestureEnabled:(BOOL)enabled {
    objc_setAssociatedObject(self, @selector(isInteractivePushGestureEnabled), @(enabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (enabled) {
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        panGesture.delegate = [DKGestureRecognizerDelegateObject shared];
        [self.view addGestureRecognizer:panGesture];
    } else {
        // TODO: 移除手势(如果存在)
    }
}

- (BOOL)isInteractivePushGestureEnabled {
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    return number ? [number boolValue] : NO;
}

- (void)setInteractivePushGestureDelegate:(id<UIViewControllerInteractivePushGestureDelegate>)delegate {
    objc_setAssociatedObject(self, @selector(interactivePushGestureDelegate), delegate, OBJC_ASSOCIATION_ASSIGN);
}

- (id<UIViewControllerInteractivePushGestureDelegate>)interactivePushGestureDelegate {
    return objc_getAssociatedObject(self, _cmd);
}

@end

