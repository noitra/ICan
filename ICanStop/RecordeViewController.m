//
//  RecordeViewController.m
//  ICanStop
//
//  Created by Gabriel Oliva de Oliveira on 3/24/15.
//  Copyright (c) 2015 Bepid. All rights reserved.
//

#import "RecordeViewController.h"
#import "ViceRecord.h"
#import "AppDelegate.h"

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

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *viceDataArray = [[userDefaults valueForKey:VicesRecords] mutableCopy];
    
    self.records = [[NSMutableArray alloc] init];

    BOOL foundCurrentViceInRecords = NO;
    ViceRecord *currentVice = [ViceRecord getViceRecordFromData:[userDefaults valueForKey:CurrentVice]];
    
    for (NSData *viceData in viceDataArray) {
        ViceRecord *vice = [ViceRecord getViceRecordFromData:viceData];
        [self.records addObject:vice];
        
        if (currentVice != nil && [currentVice.viceName isEqualToString:vice.viceName]) {
            foundCurrentViceInRecords = YES;
            
            NSTimeInterval recordsViceTimeInterval = [vice.endDate timeIntervalSinceDate:vice.startDate];
            NSTimeInterval currentViceTimeInterval = [[NSDate date] timeIntervalSinceDate:currentVice.startDate];
            
            if (recordsViceTimeInterval < currentViceTimeInterval) {
                [self.records removeObject:vice];
                [self.records addObject:currentVice];
            } else {
            }
        }
        
    }
    
    if (!foundCurrentViceInRecords && currentVice != nil) {
        [self.records addObject:currentVice];
    }
    
    if ([self.records count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Você não possui nenhum recorde!"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    [self.tableView setDataSource:self];
    [self.tableView reloadData];
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
    
    ViceRecord *vice = self.records[indexPath.row];
    cell.textLabel.text = vice.viceName;
    
    cell.detailTextLabel.text  = vice.formattedStringTimeInterval;
    
    return cell;
}

@end
