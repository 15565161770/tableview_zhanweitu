//
//  AppDelegate.m
//  2222
//
//  Created by 仝兴伟 on 2018/2/27.
//  Copyright © 2018年 仝兴伟. All rights reserved.
//

#import "AppDelegate.h"
#import "MyViewController.h"
@interface AppDelegate ()
@property (nonatomic, strong) MyViewController *myVC;
@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    self.myVC = [[MyViewController alloc]initWithNibName:@"MyViewController" bundle:nil];
    NSWindow *myWindow = [NSWindow windowWithContentViewController:self.myVC];
    self.mainWindowController = [[NSWindowController alloc]initWithWindow:myWindow];
    self.mainWindowController.window.titlebarAppearsTransparent  = YES;
    self.mainWindowController.window.movableByWindowBackground = YES;
    self.mainWindowController.window.titleVisibility = NSWindowTitleHidden;
    self.myVC.view.window.windowController = self.mainWindowController;
    self.myVC.view.window.styleMask = self.myVC.view.window.styleMask & ~NSWindowStyleMaskResizable;
    [self.mainWindowController.window makeKeyAndOrderFront:self];
    [self.mainWindowController.window center];
    [self.mainWindowController showWindow:nil];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
