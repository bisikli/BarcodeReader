//
//  AppDelegate.h
//  BarcodeReader
//
//  Created by Bilgehan IŞIKLI on 24/04/2017.
//  Copyright © 2017 Blesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

