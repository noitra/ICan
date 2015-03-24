//
//  HomeViewController.m
//  ICanStop
//
//  Created by Gabriel Oliva de Oliveira on 3/24/15.
//  Copyright (c) 2015 Bepid. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation HomeViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    
    if (self) {
        
        
        self.tabBarItem.title = @"Home";
        //UIImage *i = [UIImage imageNamed:@"Time.png"];
        //self.tabBarItem.image = i;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //seta os delegates do pickerView
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    self.tempo.hidden = YES;
    
    self.items = [[NSArray alloc] initWithObjects:@"Nicotina",@"Álcool",@"Drogas", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// funções do delegate de pickerView (1)
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// funções do delegate de pickerView (2)
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.items count];
}

//funções do delegate de pickerView (3)
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30.0;
}

//funções do delegate de pickerView (4)
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.items objectAtIndex:row];
}

//funções do delegate de pickerView (5)
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    //printa a escolha
    NSLog(@"Vício escolhido : %@", [self.items objectAtIndex:row]);
}

- (IBAction)doAction:(id)sender
{
    if (!self.isCounting) {
        self.button.backgroundColor = [UIColor redColor];
        [self.button setTitle:@"Recaída" forState:UIControlStateNormal];
        self.isCounting = true;
        self.pickerView.hidden = YES;
        self.dataInicial = [NSDate date];
        self.tempo.hidden = NO;
        
        //mostrar a data na tela, placeholder
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"hh:mm a"];
        NSString *dateToday = [formatter stringFromDate:_dataInicial];
        self.tempo.text = dateToday;

    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Recaída"
                                                        message:@"Você tem certeza que recaiu?!"
                                                       delegate:self
                                              cancelButtonTitle:@"SIM"
                                              otherButtonTitles:@"NÃO",nil];
        [alert show];
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)//SIM
    {
        self.button.backgroundColor = [UIColor blueColor];
        [self.button setTitle:@"Começar" forState:UIControlStateNormal];
        self.isCounting = false;
        self.pickerView.hidden = NO;
        self.tempo.hidden = YES;
    }
    else if(buttonIndex == 1)//NAO
    {
        NSLog(@"Não recaiu");
    }
}

@end
