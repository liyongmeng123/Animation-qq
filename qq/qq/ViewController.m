//
//  ViewController.m
//  qq
//
//  Created by 李勇猛 on 16/3/20.
//  Copyright © 2016年 李勇猛. All rights reserved.
//

#import "ViewController.h"
#import "disPlay.h"
@interface ViewController ()
@property (nonatomic,strong) disPlay * disBtn;
@end

@implementation ViewController

- (disPlay *)disBtn{

    if (_disBtn ==nil) {
        _disBtn = [disPlay buttonWithType:UIButtonTypeCustom];
        _disBtn.center = self.disBtn.smallCircleView.center;
        _disBtn.frame = CGRectMake(100, 300, 20, 20);
        [self.view addSubview:self.disBtn];
    }
    
    return _disBtn;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.disBtn];
    
    
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(200, 200, 100, 100);
    btn.backgroundColor = [UIColor greenColor];
    
    [btn addTarget:self action:@selector(press) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}



-(void)press{
    
    self.disBtn.center = self.disBtn.smallCircleView.center;
    self.disBtn.hidden = NO;
    self.disBtn.smallCircleView.hidden = NO;
    
}

    // Do any additional setup after loading the view, typically from a nib.


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
