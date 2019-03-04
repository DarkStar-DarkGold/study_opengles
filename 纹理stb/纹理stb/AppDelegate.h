//
//  AppDelegate.h
//  纹理stb
//
//  Created by wangkaiyu on 2019/3/4.
//  Copyright © 2019 wangkaiyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

