//
//  strifeprefsController.m
//  strifeprefs
//
//  Created by Matt Clarke on 28/03/2013.
//  Copyright (c) 2013 matchstick. All rights reserved.
//

#import "strifeprefsController.h"
#import <Preferences/PSSpecifier.h>

static NSString *settingsFile = @"/var/mobile/Library/DreamBoard/Strife/Info.plist";

@implementation strifeprefsController
-(id)specifiers {
	if(_specifiers == nil) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"strifeprefs" target:self] retain];
    }
    return _specifiers;
}

// Hiding/showing cells when on/off
-(void)setLockscreenOn:(id)value specifier:(id)specifier {
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsFile];
    if(value == kCFBooleanTrue) {
		[dict setValue:@"YES" forKey:@"ShowsLockscreen"];
        [dict writeToFile:settingsFile atomically: YES];
	} else {
        [dict setValue:@"NO" forKey:@"ShowsLockscreen"];
        [dict writeToFile:settingsFile atomically: YES];
	}
    [dict release];
}

-(IBAction)respring:(id)sender {
    setuid(0);
    system("killall SpringBoard");
}

-(id)getLockscreenOn:(PSSpecifier*)specifier {
    id value = nil;
    
    NSDictionary *specifierProperties = [specifier properties];
    NSString *specifierKey = [specifierProperties objectForKey:@"ShowsLockscreen"];
    
    // get 'value' from 'defaults' plist (if 'defaults' key and file exists)
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/DreamBoard/Strife/Info.plist"];
    id objectValue = [dict objectForKey:specifierKey];
    NSLog(@"lockscreen = %@", objectValue);
    
    if (objectValue) {
        value = objectValue;
    } else {
        value = NO;
    }
            
    [dict release];
    return value;
}

@end

@implementation tilePageController
-(id)specifiers {
	if(_specifiers == nil) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"Tiles" target:self] retain];
    }
    return _specifiers;
}

-(void)setHexColour:(id)value specifier:(id)specifier {
    NSLog(@"Strife_prefs: Hex value is %@", value);
}
@end

@implementation mainThemePageController
-(id)specifiers {
	if(_specifiers == nil) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"Main theme" target:self] retain];
    }
    return _specifiers;
}
@end