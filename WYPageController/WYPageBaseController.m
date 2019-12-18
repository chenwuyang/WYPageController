//
//  WYPageBaseController.m
//  WYPageController
//
//  Created by 陈午阳 on 2019/12/18.
//  Copyright © 2019 陈午阳. All rights reserved.
//

#import "WYPageBaseController.h"

#define kRGBColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define kRandomColor kRGBColor(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256))



@interface WYPageBaseController ()

@end

@implementation WYPageBaseController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = kRandomColor;

}


@end
