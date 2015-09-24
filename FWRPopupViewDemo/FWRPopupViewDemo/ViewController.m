//
//  ViewController.m
//  FWRPopupViewDemo
//
//  Created by 冯伟如 on 15/9/24.
//  Copyright © 2015年 冯伟如. All rights reserved.
//

#import "ViewController.h"
#import "FWRPopupViewController.h"

@interface ViewController ()<FWRPopupViewControllerDelegate>
//这里一定要把视图设为成员变量
@property (nonatomic, strong) FWRPopupViewController *popupViewController;

@property (nonatomic, strong) NSArray *array;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-60, [UIScreen mainScreen].bounds.size.height/2-12, 120, 24);
    [button setTitle:@"点击弹出视图" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(popupViewClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)popupViewClick:(UIButton *)button {
    //需要放的按钮数组
    self.array = @[@"按钮一",@"按钮二",@"按钮三"];
    self.popupViewController = [[FWRPopupViewController alloc] initWithNameArrays:self.array];
    self.popupViewController.delegate = self;
    //弹出视图放在的视图
    [self.popupViewController showInView:self.view];
}

#pragma mark - FWRPopupViewController代理(实现点击后的功能)
- (void)buttonMenuViewController:(FWRPopupViewController *)buttonMenu buttonTappedAtIndex:(NSUInteger)index {
    NSString * clickName = self.array[index];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"你点击了" message:clickName preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
