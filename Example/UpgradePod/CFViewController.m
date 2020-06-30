//
//  CFViewController.m
//  UpgradePod
//
//  Created by yzeaho on 06/29/2020.
//  Copyright (c) 2020 yzeaho. All rights reserved.
//

#import "CFViewController.h"
#import "ConfigService.h"

@interface CFViewController ()<ConfigCallback>

@end

@implementation CFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[ConfigService sharedInstance] addCallback:self];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[ConfigService sharedInstance] removeCallback:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configNotifyChange {
    [[ConfigService sharedInstance] show:self];
}

@end
