//
//  ODAppDelegate.m
//  OpenDoors
//
//  Created by Steven Kim on 8/31/14.
//  Copyright (c) 2014 Vane Software. All rights reserved.
//

#import "ODAppDelegate.h"
#import "NSString+MD5.h"

@implementation ODAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  // Override point for customization after application launch.
  self.window.backgroundColor = [UIColor whiteColor];
  
  UIButton *openButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [openButton addTarget:self action:@selector(openDoor) forControlEvents:UIControlEventTouchUpInside];
  [openButton setTitle:@"Open Door" forState:UIControlStateNormal];
  openButton.frame = CGRectMake(0, 0, 320, 568);
  openButton.titleLabel.font = [UIFont systemFontOfSize:48.0f];
  [self.window addSubview:openButton];
  
  [self.window makeKeyAndVisible];
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void) openDoor {
  
  NSString *client = @"YOUR_CLIENT_STRING";
  NSString *secret = @"YOUR_SECRET_KEY_STRING";
  NSString *serverUrl = @"YOUR_SERVER_IP";
  NSString *authHeaderName = @"x-od";

  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"yyyy-MM-dd-HH"];
  NSString *dateString = [formatter stringFromDate:[NSDate date]];
  
  NSString *hashBase = [NSString stringWithFormat:@"%@&%@&%@", client, secret, dateString];
  NSString *authHeader = [NSString stringWithFormat:@"%@&%@", client, hashBase.MD5String];
  
  NSString *odUrl = [NSString stringWithFormat:@"http://%@/cgi-bin/o.py", serverUrl];
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:odUrl]];
  [request setValue:authHeader forHTTPHeaderField:authHeaderName];
  NSHTTPURLResponse *response = nil;
  NSError *error = nil;
  [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
}

@end
