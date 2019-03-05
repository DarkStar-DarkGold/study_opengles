//
//  AppDelegate.h
//  6MVPGL
//
//  Created by wangkaiyu on 2019/3/5.
//  Copyright © 2019 wangkaiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

