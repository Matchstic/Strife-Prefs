//
//  strifeprefsController.h
//  strifeprefs
//
//  Created by Matt Clarke (Matchstic, matchstick) on 20/04/2013.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Preferences/Preferences.h>
#import "UIProgressHUD.h"

@interface strifeprefsController : PSListController
-(id)specifiers;
-(void)viewWillAppear:(BOOL)view;
-(void)setLockscreenOn:(id)value specifier:(id)specifier;
-(IBAction) respring:(id)sender;
-(BOOL)getLockscreenOn;
-(NSString *)tileColour;
-(void)setPictureTile:(id)value specifier:(id)specifier;

@end

@interface tilePageController : PSListController
-(id)specifiers;
@end

@interface mainThemePageController : PSListController
-(id)specifiers;
@end

@class MBProgressHUD;
@interface backupPageController : PSListController {
    	UIProgressHUD *hud;
}
-(id)specifiers;
-(void)restorePrefs;
-(void)backUpPrefs;
-(void)restoreTiles;
-(void)backUpTiles;
@end

@interface tilePageUIController : UIViewController
-(void)viewDidLoad;
@end

@interface restoreTilesController : PSListController {
    UIProgressHUD *hud;
}
-(id)specifiers;
-(void)restoreSelected;
-(void)hideHud;
@end

@interface lockAppPageController : PSListController
-(id)specifiers;
-(void)viewDidAppear:(BOOL)arg1;
-(NSString *)lockappOne;
-(NSString *)lockappTwo;
-(NSString *)lockappThree;
-(NSString *)lockappFour;
-(NSString *)lockappFive;
@end
