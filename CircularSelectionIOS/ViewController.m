//
//  ViewController.m
//  CircularSelectionIOS
//
//  Created by A S Maan on 6/14/15.
//  Copyright (c) 2015 ASMaan. All rights reserved.
//

#import "ViewController.h"
#import "AMCircularControl.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AMCircularControl *circularControl = [[AMCircularControl alloc] initWithFrame:CGRectMake(0, 0, AM_SLIDER_SIZE, AM_SLIDER_SIZE)];
    circularControl.center = CGPointMake(self.view.center.x,self.view.center.y);
    [circularControl setUserInteractionEnabled:YES];
    [circularControl addTarget:self action:@selector(quarterChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:circularControl];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)quarterChanged:(AMCircularControl*)slider{
    NSLog(@"Angle is--->%d",slider.angle);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
