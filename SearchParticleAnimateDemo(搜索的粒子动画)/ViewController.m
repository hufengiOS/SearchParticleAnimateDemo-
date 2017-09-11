//
//  ViewController.m
//  SearchParticleAnimateDemo(搜索的粒子动画)
//
//  Created by 胡丰 on 2017/9/1.
//  Copyright © 2017年 hufeng. All rights reserved.
//

#import "ViewController.h"
#import "HFParticleSearchAnimateView.h"



#define kScreen_Width [UIScreen mainScreen].bounds.size.width


@interface ViewController ()

@property (nonatomic, strong) HFParticleSearchAnimateView *particleView;
@property (nonatomic, strong) UIButton *startBtn;
@property (nonatomic, strong) UIButton *resumeBtn;
@property (nonatomic, strong) UIButton *endBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.particleView];
    [self.view addSubview:self.startBtn];
    [self.view addSubview:self.resumeBtn];
    [self.view addSubview:self.endBtn];
}

- (HFParticleSearchAnimateView *)particleView {
    if (!_particleView) {
        _particleView = [[HFParticleSearchAnimateView alloc] initWithFrame:CGRectMake(0, 100, kScreen_Width, kScreen_Width)];
        _particleView.backgroundColor = [UIColor blueColor];
    }
    return _particleView;
}

- (UIButton *)startBtn {
    if (!_startBtn) {
        _startBtn = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(50, 50, 50, 40);
            btn.backgroundColor = [UIColor redColor];
            [btn setTitle:@"开始" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
    }
    return _startBtn;
}

- (UIButton *)resumeBtn {
    if (!_resumeBtn) {
        _resumeBtn = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(_startBtn.frame.origin.x + _startBtn.frame.size.width + 10, 50, 50, 40);
            btn.backgroundColor = [UIColor redColor];
            [btn setTitle:@"暂停" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(resumeAction) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
    }
    return _resumeBtn;
}

- (UIButton *)endBtn {
    if (!_endBtn) {
        _endBtn = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(_resumeBtn.frame.origin.x + _resumeBtn.frame.size.width + 10, 50, 50, 40);
            btn.backgroundColor = [UIColor redColor];
            [btn setTitle:@"停止" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(endAction) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
    }
    return _endBtn;
}


- (void)searchAction {
    [self.particleView startAnimation];
}

- (void)resumeAction {
    [self.particleView resumeAnimation];
}

- (void)endAction {
    [self.particleView endAnimation];
}
@end
