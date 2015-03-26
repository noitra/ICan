//
//  ViceRecord.m
//  ICanStop
//
//  Created by Thiago Borges Gonçalves Penna on 3/25/15.
//  Copyright (c) 2015 Bepid. All rights reserved.
//

#import "ViceRecord.h"

@implementation ViceRecord

- (NSString *) formattedStringTimeInterval
{
    // Descobrindo a diferenca entre as datas
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    // Quebrando a diferenca em componentes
    NSDate *endDate = self.endDate;
    if (endDate == nil) {
        endDate = [NSDate date];
    }
    NSDateComponents *comps = [cal components:unitFlags fromDate:self.startDate toDate:endDate options:0];
    
    NSInteger years = comps.year;
    NSInteger months = comps.month;
    NSInteger days = comps.day;
    NSInteger hours = comps.hour;
    NSInteger minutes = comps.minute;
    NSInteger seconds = comps.second;
    
    // Encontrando as unidades mais significativas e contruindo a string de saida
    NSMutableString *string = [NSMutableString stringWithCapacity:63];
    
    if (years != 0) {
        [string appendFormat:@"%ld ano%@", years, years==1?@"":@"s"];
        if (months != 0) {
            [string appendFormat:@"%@%ld m%@", days==0?@" e ":@", ", months, months==1?@"ês":@"eses"];
        }
        if (days != 0) {
            [string appendFormat:@" e %ld dia%@", days, days==1?@"":@"s"];
        }
    } else if (months != 0) {
        [string appendFormat:@"%ld m%@", months, months==1?@"ês":@"eses"];
        if (days != 0) {
            [string appendFormat:@"%@%ld dia%@", hours==0?@" e ":@", ", days, days==1?@"":@"s"];
        }
        if (hours != 0) {
            [string appendFormat:@" e %ld hora%@", hours, hours==1?@"":@"s"];
        }
    } else if (days != 0) {
        [string appendFormat:@"%ld dia%@", days, days==1?@"":@"s"];
        if (hours != 0) {
            [string appendFormat:@"%@%ld hora%@", minutes==0?@" e ":@", ", hours, hours==1?@"":@"s"];
        }
        if (minutes != 0) {
            [string appendFormat:@" e %ld minuto%@", minutes, minutes==1?@"":@"s"];
        }
    } else if (hours != 0) {
        [string appendFormat:@"%ld hora%@", hours, hours==1?@"":@"s"];
        if (minutes != 0) {
            [string appendFormat:@"%@%ld minuto%@", seconds==0?@" e ":@", ", minutes, minutes==1?@"":@"s"];
        }
        if (seconds != 0) {
            [string appendFormat:@", %ld segundo%@", seconds, seconds==1?@"":@"s"];
        }
    } else if (minutes != 0) {
        [string appendFormat:@"%ld minuto%@", minutes, minutes==1?@"":@"s"];
        if (seconds != 0) {
            [string appendFormat:@" e %ld segundo%@", seconds, seconds==1?@"":@"s"];
        }
    } else {
        [string appendFormat:@"%ld segundo%@", seconds, seconds==1?@"":@"s"];
    }
    
    return [NSString stringWithString:string];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ - de %@ ateh %@", self.viceName, self.startDate, self.endDate];
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.viceName forKey:@"viceName"];
    [coder encodeObject:self.startDate forKey:@"startDate"];
    [coder encodeObject:self.endDate forKey:@"endDate"];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.viceName = [coder decodeObjectForKey:@"viceName"];
        self.startDate = [coder decodeObjectForKey:@"startDate"];
        self.endDate = [coder decodeObjectForKey:@"endDate"];
    }
    return self;
}

- (NSData *)getData
{
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

+ (instancetype)getViceRecordFromData:(NSData *)data
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

@end
