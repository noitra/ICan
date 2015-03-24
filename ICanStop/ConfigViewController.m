//
//  ConfigViewController.m
//  ICanStop
//
//  Created by Gabriel Oliva de Oliveira on 3/24/15.
//  Copyright (c) 2015 Bepid. All rights reserved.
//

#import "ConfigViewController.h"

@interface ConfigViewController ()

@end

@implementation ConfigViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    
    if (self) {
        
        
        
        //Give it a label
        self.tabBarItem.title = @"Config";
        
        //Give it an image
        //UIImage *i = [UIImage imageNamed:@"Time.png"];
        //self.tabBarItem.image = i;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
