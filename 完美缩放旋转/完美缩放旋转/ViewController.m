//
//  ViewController.m
//  完美缩放旋转
//
//  Created by lsq on 2018/9/30.
//  Copyright © 2018 lsq. All rights reserved.
//

#import "ViewController.h"


#define SCROLL_MINSCALE  1                              // 最小缩放
#define SCROLL_MAXSCALE  2.25                           // 最大缩放


@interface ViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *mainScrollview;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) int rotateAngle;          //旋转角度


@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.rotateAngle = 0 ;
    [self mainScrollview];
    [self imageView];
    
    UIButton *zoomBtn = [UIButton new];
    [self.view addSubview:zoomBtn];
    zoomBtn.frame = CGRectMake(15, self.view.frame.size.height - 150, 50, 25);
    [zoomBtn setTitle:@"放大" forState:UIControlStateNormal];
    [zoomBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [zoomBtn addTarget:self action:@selector(zoom) forControlEvents:UIControlEventTouchUpInside];

    UIButton *narrowBtn = [UIButton new];
    [self.view addSubview:narrowBtn];
    narrowBtn.frame = CGRectMake(15 + 50 + 100, self.view.frame.size.height - 150, 50, 25);
    [narrowBtn setTitle:@"缩小" forState:UIControlStateNormal];
    [narrowBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [narrowBtn addTarget:self action:@selector(narrow) forControlEvents:UIControlEventTouchUpInside];

    UIButton *rotateBtn = [UIButton new];
    [self.view addSubview:rotateBtn];
    rotateBtn.frame = CGRectMake(15 + (50 + 100)*2, self.view.frame.size.height - 150, 50, 25);
    [rotateBtn setTitle:@"旋转" forState:UIControlStateNormal];
    [rotateBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [rotateBtn addTarget:self action:@selector(rotate) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton *upperLowerMirrorsBtn = [UIButton new];
    [self.view addSubview:upperLowerMirrorsBtn];
    upperLowerMirrorsBtn.frame = CGRectMake(15, self.view.frame.size.height - 70, 80, 25);
    [upperLowerMirrorsBtn setTitle:@"上下镜像" forState:UIControlStateNormal];
    [upperLowerMirrorsBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [upperLowerMirrorsBtn addTarget:self action:@selector(mirrorup) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton *leftRightMirrorsBtn = [UIButton new];
    [self.view addSubview:leftRightMirrorsBtn];
    leftRightMirrorsBtn.frame = CGRectMake(self.view.frame.size.width - 15-80, self.view.frame.size.height - 70, 80, 25);
    [leftRightMirrorsBtn setTitle:@"左右镜像" forState:UIControlStateNormal];
    [leftRightMirrorsBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [leftRightMirrorsBtn addTarget:self action:@selector(mirrorleft) forControlEvents:UIControlEventTouchUpInside];


}



#pragma mark - btn method

/**
 *  放大
 */
- (void)zoom{
    CGFloat zommscale = self.mainScrollview.zoomScale;
    zommscale = zommscale + 0.25;
    if (zommscale <= SCROLL_MAXSCALE) {
        [self.mainScrollview setZoomScale:zommscale animated:NO];
    }

}

/**
 *  缩小
 */
- (void)narrow{
    CGFloat zommscale = self.mainScrollview.zoomScale;
    zommscale = zommscale - 0.25;
    if (zommscale >= 1) {
        [self.mainScrollview setZoomScale:zommscale animated:NO];
    }

}

/**
 *  旋转
 */
- (void)rotate{
    //顺时针旋转 90度
    self.rotateAngle = self.rotateAngle + 90;
    
    self.mainScrollview.transform = CGAffineTransformMakeRotation(((self.rotateAngle) * M_PI / 180.0));

}


/**
 *  上下镜像
 */
- (void)mirrorup{
    //获得初始transform
    CGAffineTransform transform = self.mainScrollview.transform;
    
    if (((self.rotateAngle / 90) % 2) == 0) {
        // 进行镜像变换(y轴上下反转)
        transform = CGAffineTransformScale(transform, 1, -1);
        self.mainScrollview.transform = transform;
        
    }else{
        transform = CGAffineTransformScale(transform, -1, 1);
        self.mainScrollview.transform = transform;
        
    }

}

/**
 *  左右镜像
 */
- (void)mirrorleft{
    //获得初始transform
    CGAffineTransform transform = self.mainScrollview.transform;
    
    // 进行镜像变换(x轴左右反转)
    if (((self.rotateAngle / 90) % 2) == 0) {
        // 进行镜像变换(x轴左右反转)
        transform = CGAffineTransformScale(transform, -1, 1);
        self.mainScrollview.transform = transform;
        
    }else{
        transform = CGAffineTransformScale(transform, 1, -1);
        self.mainScrollview.transform = transform;
        
    }
    
    
}


#pragma UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}


- (void)scrollViewDidZoom:(UIScrollView *)scrollView NS_AVAILABLE_IOS(3_2);
{
    
}


/**
 * 懒加载控件
 */
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.image = [UIImage imageNamed:@"IMG_0556"];
        [self.mainScrollview addSubview:_imageView];
        _imageView.frame = self.view.bounds;
    }
    return _imageView;
}

- (UIScrollView *)mainScrollview
{
    if (!_mainScrollview)
    {
        _mainScrollview = [UIScrollView new];
        _mainScrollview.delegate = self;
        [_mainScrollview setMinimumZoomScale:SCROLL_MINSCALE];
        [_mainScrollview setMaximumZoomScale:SCROLL_MAXSCALE];
        [_mainScrollview setZoomScale:SCROLL_MINSCALE animated:YES];
        _mainScrollview.showsHorizontalScrollIndicator = NO;
        _mainScrollview.showsVerticalScrollIndicator = NO;
        _mainScrollview.userInteractionEnabled = YES;
        _mainScrollview.backgroundColor = [UIColor blackColor];
        
        [self.view addSubview:_mainScrollview];
        _mainScrollview.frame = self.view.bounds;
        _mainScrollview.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
        
    }
    return _mainScrollview;
}

@end
