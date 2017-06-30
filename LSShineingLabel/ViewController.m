//
//  ViewController.m
//  LSShineingLabel
//
//  Created by 李小帅 on 2017/6/29.
//  Copyright © 2017年 美好午后. All rights reserved.
//

#import "ViewController.h"
#import "LSShineingView.h"

@interface ViewController (){
    UIView *testView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    LSShineingView *shineingView = [[LSShineingView alloc] initWithFrame:CGRectMake(00, 100, 50, 100)];
    [self.view addSubview:shineingView];
    shineingView.text = @"hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh";
    shineingView.font = [UIFont systemFontOfSize:17];
    shineingView.shineingColor = [UIColor greenColor];
    shineingView.shineType = LSShineingTypeLeftToRight;
    shineingView.numberOfLines = 0;
    shineingView.shineingWidth = 30;
    [shineingView startShineing];
    
    
    LSShineingView *twoView = [[LSShineingView alloc] initWithFrame:CGRectMake(00, 100 + 100 *1, [UIScreen mainScreen].bounds.size.width, 100)];
    [self.view addSubview:twoView];
    twoView.text = @"hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh";
    twoView.shineingColor = [UIColor greenColor];
    twoView.shineType = LSShineingTypeRightToLeft;
    twoView.numberOfLines = 1;
    [twoView startShineing];
    
    LSShineingView *threeView = [[LSShineingView alloc] initWithFrame:CGRectMake(00, 100 + 100 *2, [UIScreen mainScreen].bounds.size.width, 100)];
    [self.view addSubview:threeView];
    threeView.text = @"hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh";
    threeView.shineingColor = [UIColor greenColor];
    threeView.shineType = LSShineingTypeAlpha;
    threeView.numberOfLines = 1;
    [threeView startShineing];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
