//
//  SceneDelegate.m
//  ZhuangBei
//
//  Created by aa on 2020/4/21.
//  Copyright © 2020 aa. All rights reserved.
//

#import "SceneDelegate.h"
#import "MainNavController.h"
#import "LSTabBarController.h"
#import "zDengluController.h"
#import "ViewController.h"
#import "ALaunchController.h"
#import "launchManger.h"
@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions  API_AVAILABLE(ios(13.0)) API_AVAILABLE(ios(13.0)) API_AVAILABLE(ios(13.0)){
    if (scene) {
        self.window = [[UIWindow alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT)];
        self.window.backgroundColor = [UIColor whiteColor];
        if (@available(iOS 13.0, *)) {
            self.window.windowScene = (UIWindowScene*)scene;
        } else {
            
        }
//        NSHTTPCookie * cookie = [cookiesTool cookieWithName:kLoginUserInfo];
        NSString * token =  [zUserInfo shareInstance].userInfo.token;
        if (token.length>0) {
            LSTabBarController * rootVC  = [[LSTabBarController alloc]init];
            MainNavController * rootNav = [[MainNavController alloc]initWithRootViewController:rootVC];
            rootNav.navigationBar.hidden = YES;
            self.window.rootViewController = rootNav;
            [self.window makeKeyAndVisible];

        }else
        {
            BOOL tag = [[launchManger shareInstance] getLaunchKey];
            if (tag) {
                ALaunchController * luanchVC =  [[ALaunchController alloc]init];
                MainNavController * rootNav = [[MainNavController alloc]initWithRootViewController:luanchVC];
                rootNav.navigationBar.hidden = YES;
                self.window.rootViewController = rootNav;
                [self.window makeKeyAndVisible];
            }else
            {
                //未登录登录状态 登录
                zDengluController * rootVC  = [[zDengluController alloc]init];
                MainNavController * rootNav = [[MainNavController alloc]initWithRootViewController:rootVC];
                rootNav.navigationBar.hidden = YES;
                self.window.rootViewController = rootNav;
                [self.window makeKeyAndVisible];
            }
        }
        
    }
}


- (void)sceneDidDisconnect:(UIScene *)scene  API_AVAILABLE(ios(13.0)){
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene  API_AVAILABLE(ios(13.0)){
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene  API_AVAILABLE(ios(13.0)){
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene  API_AVAILABLE(ios(13.0)){
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene  API_AVAILABLE(ios(13.0)){
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}


@end
