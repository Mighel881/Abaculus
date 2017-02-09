#import "ACUSettings.h"
#import "ACUMenuView.h"
#import "ACUCustomAppView.h"
#import "headers.h"

@implementation ACUMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
      CAShapeLayer *circleLayer = [CAShapeLayer layer];
      [circleLayer setPath:[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 100, 667)].CGPath];
      [circleLayer setStrokeColor:[UIColor whiteColor].CGColor];
      [circleLayer setFillColor:[UIColor whiteColor].CGColor];

      [self.layer addSublayer:circleLayer];

      self.alpha = 0;
      self.clipsToBounds = NO;
      self.layer.masksToBounds = NO;
      self.layer.shadowOffset = CGSizeMake(-7, 0);
      self.layer.shadowRadius = 5;
      self.layer.shadowOpacity = 0.5;

      [self layoutApps];
    }

    return self;
}

- (void)layoutApps {
  /*
    NSArray *identifiers = [ACUSettings sharedSettings].favoriteApps;
    CGSize size = [objc_getClass(SBIconView) defaultIconSize];
    for (NSString *str in identifiers) {
        ACUCustomAppView *appView = [[ACUCustomAppView alloc] initWithBundleIdentifier:str size:size];
        //appView.center determine where to place along curvePath
        [self addSubview:appView];
        [_appViews addObject:appView];
    }
  */

  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
  view.backgroundColor = [UIColor blackColor];
  view.center = [self centerforIcon];
  [self addSubview:view];
}

- (CGPoint)centerforIcon {
    //angles 36 72 108 144 180
    CGFloat t = atan(50 * tan(135 * M_PI/180) / 333.5);

    CGFloat x = -50 + 50 * cos(t * M_PI/180);
    CGFloat y = 333.5 + 333.5 * sin(t * M_PI/180);

    return CGPointMake(x, y);
}

- (void)touchMovedToPoint:(CGPoint)point {
    for (ACUCustomAppView *appView in _appViews) {
        CGRect convertedFrame = [self convertRect:appView.frame fromView:appView.superview];
        if (CGRectContainsPoint(convertedFrame, point)) {
            [appView highlightApp];
        } else {
            [appView unhighlightApp];
        }
    }
}

- (void)touchEndedAtPoint:(CGPoint)point {
    for (ACUCustomAppView *appView in _appViews) {
        if (appView.isHighlighted) {
            NSString *bundleIdentifier = appView.bundleIdentifier;
            [[UIApplication sharedApplication] launchApplicationWithIdentifier:bundleIdentifier suspended:NO];
        }
    }
}

@end
