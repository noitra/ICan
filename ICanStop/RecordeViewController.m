//
//  RecordeViewController.m
//  ICanStop
//
//  Created by Gabriel Oliva de Oliveira on 3/24/15.
//  Copyright (c) 2015 Bepid. All rights reserved.
//

#import "RecordeViewController.h"
#import "ViceRecord.h"

@interface RecordeViewController ()

@property (nonatomic) NSMutableArray *records;

@end

@implementation RecordeViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    
    if (self) {
        //Give it a label
        self.tabBarItem.title = @"Recordes";
        
        //Give it an image
        UIImage *i = [UIImage imageNamed:@"record.png"];
        self.tabBarItem.image = i;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.records = [userDefaults valueForKey:@"vices"];
    
    self.records = [[NSMutableArray alloc] init];
    
    ViceRecord *v1 = [[ViceRecord alloc] init];
    [v1 setViceName:@"Nicotina"];
    [v1 setStartDate:[NSDate date]];
    [v1 setEndDate:[NSDate dateWithTimeIntervalSinceNow:10000]];
    
    ViceRecord *v2 = [[ViceRecord alloc] init];
    [v2 setViceName:@"Álcool"];
    [v2 setStartDate:[NSDate date]];
    [v2 setEndDate:[NSDate dateWithTimeIntervalSinceNow:1000000]];
    
    ViceRecord *v3 = [[ViceRecord alloc] init];
    [v3 setViceName:@"Drogas"];
    [v3 setStartDate:[NSDate date]];
    [v3 setEndDate:[NSDate dateWithTimeIntervalSinceNow:10000000]];
    
    [self.records addObject:v1];
    [self.records addObject:v2];
    [self.records addObject:v3];
    
    [self.tableView setDataSource:self];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.records count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =
    [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2
                           reuseIdentifier:@"UITableViewCell"];
    
    ViceRecord *vice = (ViceRecord *)self.records[indexPath.row];
    cell.textLabel.text = vice.viceName;
    
    cell.detailTextLabel.text  = vice.formattedStringTimeInterval;
    
    return cell;
}

@end
