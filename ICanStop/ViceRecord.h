//
//  ViceRecord.h
//  ICanStop
//
//  Created by Thiago Borges Gonçalves Penna on 3/25/15.
//  Copyright (c) 2015 Bepid. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViceRecord : NSObject <NSCoding>

@property (nonatomic) NSString *viceName;
@property (nonatomic) NSDate *startDate;
@property (nonatomic) NSDate *endDate;

- (NSString *) formattedStringTimeInterval;
- (NSData *)getData;
+ (instancetype)getViceRecordFromData:(NSData *)data;

@end
