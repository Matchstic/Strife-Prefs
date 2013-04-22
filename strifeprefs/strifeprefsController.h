//
//  strifeprefsController.h
//  strifeprefs
//
//  Created by Matt Clarke (Matchstic, matchstick) on 20/04/2013.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Preferences/Preferences.h>

@interface strifeprefsController : PSListController
-(id)specifiers;
-(void)viewDidAppear:(BOOL)arg1;
-(void)setLockscreenOn:(id)value specifier:(id)specifier;
-(IBAction) respring:(id)sender;
-(BOOL)getLockscreenOn;
-(NSString *)tileColour;

@end

@interface tilePageController : PSListController
-(id)specifiers;
@end

@interface mainThemePageController : PSListController
-(id)specifiers;
@end

@interface backupPageController : PSListController
-(id)specifiers;
-(void)restorePrefs;
-(void)backUpPrefs;
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