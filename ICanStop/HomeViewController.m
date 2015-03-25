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

    [NSTimer scheduledTimerWithTimeInterval: 1.0 target:self selector:@selector(updateClockTime) userInfo:nil repeats: YES];
    
    //seta os delegates do pickerView
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    [self updateClockTime];
    self.tempo.hidden = YES;
    
    self.items = [[NSArray alloc] initWithObjects:@"Nicotina",@"Álcool",@"Drogas", nil];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults valueForKey:@"startDate"] == nil) {
        [self setDefaultView];
    } else {
        [self setRelapseView];
    }
    
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
        
        [self setRelapseView];
        
        //mostrar a data na tela, placeholder
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"hh:mm a"];
        NSString *dateToday = [formatter stringFromDate:_dataInicial];
        self.tempo.text = dateToday;
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:self.dataInicial forKey:@"startDate"];

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
        [self setDefaultView];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults removeObjectForKey:@"startDate"];
    }
    else if(buttonIndex == 1)//NAO
    {
        NSLog(@"Não recaiu");
    }
}

// Configura a view para o padrao: antes de iniciar
- (void)setDefaultView
{
    self.button.backgroundColor = [UIColor blueColor];
    [self.button setTitle:@"Começar" forState:UIControlStateNormal];
    self.isCounting = false;
    self.pickerView.hidden = NO;
    self.tempo.hidden = YES;
}

// Configura a view para a tela de recaída, contando o tempo
-(void)setRelapseView
{
    self.button.backgroundColor = [UIColor redColor];
    [self.button setTitle:@"Recaída" forState:UIControlStateNormal];
    self.isCounting = YES;
    self.pickerView.hidden = YES;
    self.dataInicial = [NSDate date];
    self.tempo.hidden = NO;
}

// Metodo para atualizar o relogio por segundo
-(void) updateClockTime
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDate *startDate = [userDefaults objectForKey:@"startDate"];
    NSDate *now = [NSDate date];
    
    NSTimeInterval interval = [now timeIntervalSinceDate:startDate];
    
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600 % 24);
    
    self.tempo.text = [NSString stringWithFormat:@"%ld horas, %ld minutos e %ld segundos", hours, minutes, seconds];
}

@end
