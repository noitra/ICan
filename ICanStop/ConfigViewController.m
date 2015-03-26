//
//  ConfigViewController.m
//  ICanStop
//
//  Created by Gabriel Oliva de Oliveira on 3/24/15.
//  Copyright (c) 2015 Bepid. All rights reserved.
//

#import "ConfigViewController.h"

@interface ConfigViewController ()

@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;

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
        UIImage *i = [UIImage imageNamed:@"settings.png"];
        self.tabBarItem.image = i;
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

- (IBAction)mudarNotification:(id)sender
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mudar Horário"
                                                    message:@"Você tem certeza que deseja mudar o horário das notificações?!"
                                                   delegate:self
                                          cancelButtonTitle:@"SIM"
                                          otherButtonTitles:@"NÃO",nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)//SIM
    {

        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
        self.dataNova = self.datePicker.date;
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSDate *dataInicial = [userDefaults valueForKey:@"startDate"];
        
        NSTimeInterval interval = [self.dataNova timeIntervalSinceDate:dataInicial];
        
        int ti = (int)interval;
        int meses = ti / 2592000;
        
        if ( ti > 2592000) {
            
            //dispara notificações restantes de meses
            for (int k = meses; k < 13; k++) {
                [self setNotificationMonth:k];
            }
            
        } else {
            
            //dispara notificações restantes de meses
            for (int k = 1; k < 13; k++) {
                [self setNotificationMonth:k];
            }
            
            int semanas = ti / 648000;
            
            if (ti > 648000) {
                
                //dispara notificações restantes de semanas
                for (int k = semanas; k < 9; k++) {
                    [self setNotificationWeek:k];
                }
                
            } else {
                
                //dispara notificações restantes de semanas
                for (int k = 1; k < 9; k++) {
                    [self setNotificationWeek:k];
                }
                
                int dias = ti / 86400;
                
                if ( ti > 86400) {
                    
                    //Dispara notificações minuto a minuto e diarias
                    for (int k = dias; k < 7; k++) {
                        [self setNotificationDay:k];
                    }
                    
                } else {
                    
                    //Dispara notificações minuto a minuto e diarias
                    for (int k = 1; k < 7; k++) {
                        [self setNotificationDay:k];
                    }
                }
            }
        }
    }
    else if(buttonIndex == 1)//NAO
    {
        NSLog(@"Não mudou");
    }
}

- (void)setNotificationDay: (int) day
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDate *alertTime = [self.dataNova dateByAddingTimeInterval:86400*day];
    
    UILocalNotification* notification = [[UILocalNotification alloc] init];
    notification.fireDate = alertTime;
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
    if (day == 1) {
        NSString *aux = [NSString stringWithFormat:@" Parabéns!! %d dia sem %@", day, [userDefaults valueForKey:@"vice"]];
        notification.alertBody = aux;
    } else {
        NSString *aux = [NSString stringWithFormat:@" Parabéns!! %d dias sem %@", day, [userDefaults valueForKey:@"vice"]];
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
    
    NSDate *alertTime = [self.dataNova dateByAddingTimeInterval:604800*week];
    
    UILocalNotification* notification = [[UILocalNotification alloc] init];
    notification.fireDate = alertTime;
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
    if (week == 1) {
        NSString *aux = [NSString stringWithFormat:@" Parabéns!! %d semana sem %@", week, [userDefaults valueForKey:@"vice"]];
        notification.alertBody = aux;
    } else {
        NSString *aux = [NSString stringWithFormat:@" Parabéns!! %d semanas sem %@", week, [userDefaults valueForKey:@"vice"]];
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
                                                        fromDate:self.dataNova];
    
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
        NSString *aux = [NSString stringWithFormat:@" Parabéns!! %d mês sem %@", month, [userDefaults valueForKey:@"vice"]];
        notification.alertBody = aux;
    } else if (month == 12) {
        NSString *aux = [NSString stringWithFormat:@" Parabéns!! 1 ano sem %@", [userDefaults valueForKey:@"vice"]];
        notification.alertBody = aux;
    } else {
        NSString *aux = [NSString stringWithFormat:@" Parabéns!! %d meses sem %@", month, [userDefaults valueForKey:@"vice"]];
        notification.alertBody = aux;
    }
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    // Teste das datas de notificações mensais
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-dd-yyy hh:mm"];
    NSString *notifDate = [formatter stringFromDate:fireDate];
    NSLog(@"%s: fire time = %@", __PRETTY_FUNCTION__, notifDate);
}


@end
