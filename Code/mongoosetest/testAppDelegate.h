//
//  testAppDelegate.h
//  mongoosetest
//
//  Created by vivek Rajanna on 10/04/13.
//  Copyright (c) 2013 ymedialabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mongoosewrapper.h"

@class testViewController;

@interface testAppDelegate : UIResponder <UIApplicationDelegate>
{

}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) testViewController *viewController;

@end
