//
//  HomeViewController.m
//  ICanStop
//
//  Created by Gabriel Oliva de Oliveira on 3/24/15.
//  Copyright (c) 2015 Bepid. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "ViceRecord.h"

@interface HomeViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;
@property (nonatomic) ViceRecord *currentVice;

@end

@implementation HomeViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    
    if (self) {
        
        
        self.tabBarItem.title = @"Home";
        UIImage *i = [UIImage imageNamed:@"home.png"];
        self.tabBarItem.image = i;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [NSTimer scheduledTimerWithTimeInterval: 1.0 target:self selector:@selector(updateClockTime) userInfo:nil repeats: YES];
    
    //seta os delegates do pickerView
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    self.tempo.hidden = YES;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSData *currentViceData = [userDefaults valueForKey:CurrentVice];
    self.currentVice = [ViceRecord getViceRecordFromData:currentViceData];
    
    if (self.currentVice == nil) {
        self.currentVice = [[ViceRecord alloc] init];
        [self setDefaultView];
    } else {
        [self setRelapseView];
    }
    
    self.items = [userDefaults valueForKey:VicesList];
    self.currentVice.viceName = self.items[0];
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
    
    NSString *viceName = [[NSString alloc] init];
    viceName = [self.items objectAtIndex:row];
    
    self.currentVice.viceName = viceName;
    
    //printa a escolha
    NSLog(@"Vício escolhido : %@", viceName);
}

- (IBAction)doAction:(id)sender
{
    if (!self.isCounting) {
        
        [self setRelapseView];
        
        //mostrar a data na tela, placeholder
        //NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //[formatter setDateFormat:@"hh:mm a"];
        //NSString *dateToday = [formatter stringFromDate:_dataInicial];
        //self.tempo.text = dateToday;
        
        self.dataFinal = self.datePicker.date;
        NSLog(@"Data do picker %@", self.dataFinal);
        //NSInteger secondsFromGMT = [[NSTimeZone localTimeZone] secondsFromGMT];
        //self.dataFinal = [date_picker dateByAddingTimeInterval:secondsFromGMT];
        //NSLog(@"Data do picker ajustada %@", self.dataFinal);
        
        ///Novo no IOS 8 pede permissão para notificações locais
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        //Dispara notificações minuto a minuto e diarias
        for (int k = 1; k < 7; k++) {
            [self setNotificationMinute:k];
            [self setNotificationDay:k];
        }
        
        //Dispara notificações semanais
        for (int k = 1; k < 9; k++) {
            [self setNotificationWeek:k];
        }
        
        //Dispara notificações mensais
        for (int k = 1; k < 13; k++) {
            [self setNotificationMonth:k];
        }
        
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        self.currentVice.startDate = [NSDate date];
        [userDefaults setObject:self.currentVice.getData forKey:CurrentVice];

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
        
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        ViceRecord *currentVice = [ViceRecord getViceRecordFromData:[userDefaults objectForKey:CurrentVice]];
        [userDefaults removeObjectForKey:CurrentVice];
        
        currentVice.endDate = [NSDate date];
        
        NSMutableArray *records = [[userDefaults valueForKey:VicesRecords] mutableCopy];
        if (records == nil) {
            records = [[NSMutableArray alloc] init];
        }
        
        for (NSData *viceData in records) {
            ViceRecord *vice = [ViceRecord getViceRecordFromData:viceData];
            
            if ([currentVice.viceName isEqualToString:vice.viceName]) {
                
                NSTimeInterval recordsViceTimeInterval = [vice.endDate timeIntervalSinceDate:vice.startDate];
                NSTimeInterval currentViceTimeInterval = [[NSDate date] timeIntervalSinceDate:currentVice.startDate];
                
                if (recordsViceTimeInterval > currentViceTimeInterval) {
                    return;
                } else {
                    [records removeObject:viceData];
                }
            }
        }
        
        [records addObject:[currentVice getData]];
        [userDefaults setObject:records forKey:VicesRecords];

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
    self.datePicker.hidden = NO;
    self.tempo.hidden = YES;
}

// Configura a view para a tela de recaída, contando o tempo
-(void)setRelapseView
{
    self.button.backgroundColor = [UIColor redColor];
    [self.button setTitle:@"Recaída" forState:UIControlStateNormal];
    self.isCounting = YES;
    self.pickerView.hidden = YES;
    self.datePicker.hidden = YES;
    self.dataInicial = [NSDate date];
    [self updateClockTime];
}

// Metodo para atualizar o relogio por segundo
-(void) updateClockTime
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSData *dataFromCurrentVice = [userDefaults objectForKey:CurrentVice];
    
    if (dataFromCurrentVice == nil) {
        return;
    }
    
    ViceRecord *vice = [ViceRecord getViceRecordFromData: dataFromCurrentVice];
    vice.endDate = [NSDate date];
    
    self.tempo.text = vice.formattedStringTimeInterval;
    
    self.tempo.hidden = NO;
}

- (void)setNotificationMinute: (int) minute
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDate *alertTime = [self.dataInicial dateByAddingTimeInterval:60*minute];
    
    UILocalNotification* notification = [[UILocalNotification alloc] init];
    notification.fireDate = alertTime;
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
    if (minute == 1) {
        NSString *aux = [NSString stringWithFormat:@" Parabéns!! %d minuto sem %@", minute, [ViceRecord getViceRecordFromData:[userDefaults valueForKey:CurrentVice]].viceName];
        notification.alertBody = aux;
    } else {
       NSString *aux = [NSString stringWithFormat:@" Parabéns!! %d minutos sem %@", minute, [ViceRecord getViceRecordFromData:[userDefaults valueForKey:CurrentVice]].viceName];
        notification.alertBody = aux;
    }
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)setNotificationDay: (int) day
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDate *alertTime = [self.dataFinal dateByAddingTimeInterval:86400*day];
    
    UILocalNotification* notification = [[UILocalNotification alloc] init];
    notification.fireDate = alertTime;
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
    if (day == 1) {
        NSString *aux = [NSString stringWithFormat:@" Parabéns!! %d dia sem %@", day, [ViceRecord getViceRecordFromData:[userDefaults valueForKey:CurrentVice]].viceName];
        notification.alertBody = aux;
    } else {
        NSString *aux = [NSString stringWithFormat:@" Parabéns!! %d dias sem %@", day, [ViceRecord getViceRecordFromData:[userDefaults valueForKey:CurrentVice]].viceName];
        notification.alertBody = aux;
    }
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    // Teste das datas de notificações diarias
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-dd-yyy hh:mm"];
    NSString *notifDate = [formatter stringFromDate:alertTime];
    //NSLog(@"%s: fire time = %@", __PRETTY_FUNCTION__, notifDate);
}

- (void)setNotificationWeek: (int) week
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDate *alertTime = [self.dataFinal dateByAddingTimeInterval:604800*week];
    
    UILocalNotification* notification = [[UILocalNotification alloc] init];
    notification.fireDate = alertTime;
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
    if (week == 1) {
        NSString *aux = [NSString stringWithFormat:@" Parabéns!! %d semana sem %@", week, [ViceRecord getViceRecordFromData:[userDefaults valueForKey:CurrentVice]].viceName];
        notification.alertBody = aux;
    } else {
        NSString *aux = [NSString stringWithFormat:@" Parabéns!! %d semanas sem %@", week, [ViceRecord getViceRecordFromData:[userDefaults valueForKey:CurrentVice]].viceName];
        notification.alertBody = aux;
    }
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)setNotificationMonth: (int) month
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    //NSDate *alertTime = [self.dataInicial dateByAddingTimeInterval:604800*week];
    
    // Extract date components into components
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond
                                                         fromDate:self.dataFinal];
    
    NSInteger day_aux = [components day];
    NSInteger month_aux = [components month];
    NSInteger year_aux = [components year];
    
    NSInteger new_month = (month_aux + month) % 12;
    
    if (day_aux > 28 && new_month == 2) {
        new_month++;
        day_aux = day_aux - 28;
    }
    
    if (day_aux > 30 && (new_month == 1 || new_month == 3 || new_month == 5 || new_month == 7 || new_month == 8 || new_month == 10 || new_month == 12)) {
        new_month++;
        day_aux = 1;
    }
    
    if ((month_aux + month) > 12) {
        year_aux++;
    }
    
    [components setDay:day_aux];
    [components setMonth:new_month];
    [components setYear:year_aux];
    
    NSDate *fireDate = [gregorianCalendar dateFromComponents:components];
    
    UILocalNotification* notification = [[UILocalNotification alloc] init];
    notification.fireDate = fireDate;
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.timeZone = [NSTimeZone defaultTimeZone];
    if (month == 1) {
        NSString *aux = [NSString stringWithFormat:@" Parabéns!! %d mês sem %@", month, [ViceRecord getViceRecordFromData:[userDefaults valueForKey:CurrentVice]].viceName];
        notification.alertBody = aux;
    } else if (month == 12) {
        NSString *aux = [NSString stringWithFormat:@" Parabéns!! 1 ano sem %@", [ViceRecord getViceRecordFromData:[userDefaults valueForKey:CurrentVice]].viceName];
        notification.alertBody = aux;
    } else {
        NSString *aux = [NSString stringWithFormat:@" Parabéns!! %d meses sem %@", month, [ViceRecord getViceRecordFromData:[userDefaults valueForKey:CurrentVice]].viceName];
        notification.alertBody = aux;
    }
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    // Teste das datas de notificações mensais
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-dd-yyy hh:mm"];
    NSString *notifDate = [formatter stringFromDate:fireDate];
    //NSLog(@"%s: fire time = %@", __PRETTY_FUNCTION__, notifDate);
}

@end
