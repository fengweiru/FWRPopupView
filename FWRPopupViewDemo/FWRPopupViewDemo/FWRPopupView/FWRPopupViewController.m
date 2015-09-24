//
//  FWRMenuController.m
//  WeChatCameraDemo
//
//  Created by 冯伟如 on 15/8/27.
//  Copyright (c) 2015年 冯伟如. All rights reserved.
//

#import "FWRPopupViewController.h"

@interface FWRPopupViewController ()

//按钮名字数组
@property (nonatomic, copy) NSArray *namesArrays;
//背景视图
@property (nonatomic, strong) UIView *backgroundView;
//按钮视图
@property (nonatomic, strong) UIView *buttonView;

@property (nonatomic, assign) UIView *shrunkView;

@end

@implementation FWRPopupViewController

-(instancetype)initWithNameArrays:(NSArray *)nameArrays
{
    self = [super init];
    if (self) {
        self.namesArrays = nameArrays;
        
        self.backgroundView = [UIView new];
        self.backgroundView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.6];
        
        self.buttonView = [UIView new];
        self.buttonView.backgroundColor = [UIColor clearColor];
        
        _visible = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.backgroundView setAlpha:0];
    
    //设置本视图
    [self.view setOpaque:NO];
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.view setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
    
    //添加覆盖整视图
    [self.view addSubview:self.backgroundView];
    [self.backgroundView setFrame:self.view.bounds];
    [self.backgroundView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
    
    //添加按钮视图
    [self.view addSubview:self.buttonView];
    //添加按钮
    int height = [self renderButtons];
    self.buttonView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-height, [UIScreen mainScreen].bounds.size.width, height);
    
    //添加手势取消选择
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelOther)];
    [self.view addGestureRecognizer:tapG];
}

#pragma mark - cancelOther
- (void)cancelOther{
    [self hide];
}

- (int) renderButtons
{
    
    int height = 0;
    for (int i = 0; i < self.namesArrays.count+1; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.tag = i;
        button.frame = CGRectMake(0, height, [UIScreen mainScreen].bounds.size.width, 50);
        button.backgroundColor = [UIColor whiteColor];
        if (i < self.namesArrays.count) {
            [button setTitle:self.namesArrays[i] forState:UIControlStateNormal];
        }else{
            [button setTitle:@"取消" forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonView addSubview:button];
        height += 50;
        if (i < self.namesArrays.count-1) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, height, [UIScreen mainScreen].bounds.size.width, 1)];
            lineView.backgroundColor = [UIColor clearColor];
            [self.buttonView addSubview:lineView];
            height += 1;
        }else if (i == self.namesArrays.count-1) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, height, [UIScreen mainScreen].bounds.size.width, 5)];
            lineView.backgroundColor = [UIColor clearColor];
            [self.buttonView addSubview:lineView];
            height += 5;
        }
    }
    return height;
}

#pragma mark - button点击
- (void)buttonClick:(UIButton *)sender
{
    if (sender.tag == self.namesArrays.count) {
        [self hide];
    }else if ([self.delegate respondsToSelector:@selector(buttonMenuViewController:buttonTappedAtIndex:)]){
        [self hide];
        [self.delegate buttonMenuViewController:self buttonTappedAtIndex:sender.tag];
    }
}

#pragma mark - Presentation
- (void) showInView:(UIView*)view
{
    self.backgroundView.alpha = 0.0;
    //添加本身视图
    [view.superview addSubview:self.view];
    
    self.shrunkView = view;
    
    self.view.frame = [self.view superview].bounds;
    
    [self.buttonView setTransform:CGAffineTransformMakeTranslation(0, 167)];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self.backgroundView setAlpha:1.0];
        
        [self.buttonView setTransform:CGAffineTransformIdentity];
        
    } completion:^(BOOL finished) {
        _visible = YES;
    }];
}

- (void)hide
{
    [UIView animateWithDuration:0.3 animations:^{
       
        self.backgroundView.alpha = 0.0;
        
        CGAffineTransform t = CGAffineTransformIdentity;
        t = CGAffineTransformTranslate(t, 0, self.buttonView.frame.size.width);
        [self.buttonView setTransform:t];
        
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        _visible = NO;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
