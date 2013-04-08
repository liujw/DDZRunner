//
//  DDZUrlAppDelegate.h
//  DDZUrl
//
//  Created by liujw on 13-3-28.
//  Copyright 2011年 flhs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDZUrlViewController;

@interface DDZUrlAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet DDZUrlViewController *viewController;

@end
