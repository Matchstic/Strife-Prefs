//
//  strifeprefsController.h
//  strifeprefs
//
//  Created by Matt Clarke on 20/04/2013.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Preferences/Preferences.h>

@interface strifeprefsController : PSListController
{
}

-(id)specifiers;
-(void)setLockscreenOn:(id)value specifier:(id)specifier;
-(IBAction) respring:(id)sender;
-(id)getLockscreenOn:(PSSpecifier*)specifier;

@end

@interface tilePageController : PSListController
-(id)specifiers;
@end

@interface mainThemePageController : PSListController
-(id)specifiers;
@end