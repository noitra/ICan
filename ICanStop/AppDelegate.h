//
//  AppDelegate.h
//  ICanStop
//
//  Created by Gabriel Oliva de Oliveira on 3/24/15.
//  Copyright (c) 2015 Bepid. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViceRecord;

extern NSString * const CurrentVice;
extern NSString * const VicesRecords;
extern NSString * const PreferredNotificationTime;
extern NSString * const VicesList;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

