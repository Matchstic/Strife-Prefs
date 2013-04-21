//
//  strifeprefsController.m
//  strifeprefs
//
//  Created by Matt Clarke on 28/03/2013.
//

#import "strifeprefsController.h"
#import <Preferences/PSSpecifier.h>
#import "ALApplicationList.h"

static NSString *settingsFile = @"/var/mobile/Library/DreamBoard/Strife/Info.plist";

@implementation strifeprefsController
-(id)specifiers {
	if(_specifiers == nil) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"strifeprefs" target:self] retain];
    }
    return _specifiers;
}
-(void)viewDidAppear:(BOOL)arg1 {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsFile];
    BOOL lockscreen = [[dict objectForKey:@"ShowsLockscreen"] boolValue];
    [dict release];
    
    NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.matchstick.strifeprefs.plist"];
    [plistDict setValue:[NSNumber numberWithBool:lockscreen] forKey:@"ShowsLockscreen"];
    [plistDict writeToFile:@"/var/mobile/Library/Preferences/com.matchstick.strifeprefs.plist" atomically:YES];
    [plistDict release];
    
    [self reloadSpecifiers];
}

// Hiding/showing cells when on/off
-(void)setLockscreenOn:(id)value specifier:(id)specifier {
	[self setPreferenceValue:value specifier:specifier];
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

-(BOOL)getLockscreenOn {
    BOOL lockscreen = nil;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsFile];
    lockscreen = [[dict objectForKey:@"ShowsLockscreen"] boolValue];
    
    [dict release];
    return lockscreen;
}

-(NSString *)tileColour {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsFile];
    NSString *colour = [dict objectForKey:@"AccentColorHex"];
   
    // There must be a better way acheive this!
    if ([colour isEqualToString:@"A4C400"]) {
        colour = @"Lime";
    } else if ([colour isEqualToString:@"60A917"]) {
        colour = @"Green";
    } else if ([colour isEqualToString:@"008A00"]) {
        colour = @"Emerald";
    } else if ([colour isEqualToString:@"00ABA9"]) {
        colour = @"Teal";
    } else if ([colour isEqualToString:@"1BA1E2"]) {
        colour = @"Cyan";
    } else if ([colour isEqualToString:@"0050EF"]) {
        colour = @"Cobalt";
    } else if ([colour isEqualToString:@"6A00FF"]) {
        colour = @"Indigo";
    } else if ([colour isEqualToString:@"AA00FF"]) {
        colour = @"Violet";
    } else if ([colour isEqualToString:@"F472D0"]) {
        colour = @"Pink";
    } else if ([colour isEqualToString:@"D80073"]) {
        colour = @"Magenta";
    } else if ([colour isEqualToString:@"A20025"]) {
        colour = @"Crimson";
    } else if ([colour isEqualToString:@"E51400"]) {
        colour = @"Red";
    } else if ([colour isEqualToString:@"FA6800"]) {
        colour = @"Orange";
    } else if ([colour isEqualToString:@"F0A30A"]) {
        colour = @"Amber";
    } else if ([colour isEqualToString:@"E3C800"]) {
        colour = @"Yellow";
    } else if ([colour isEqualToString:@"825A2C"]) {
        colour = @"Brown";
    } else if ([colour isEqualToString:@"6D8764"]) {
        colour = @"Olive";
    } else if ([colour isEqualToString:@"647687"]) {
        colour = @"Steel";
    } else if ([colour isEqualToString:@"76608A"]) {
        colour = @"Mauve";
    } else if ([colour isEqualToString:@"87794E"]) {
        colour = @"Taupe";
    } else {
        colour = @"Custom";
    }
    
    [dict release];
    return colour;
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

@implementation lockAppPageController
-(id)specifiers {
	if(_specifiers == nil) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"Lockapps" target:self] retain];
    }
    return _specifiers;
}

-(void)viewDidAppear:(BOOL)arg1 {
    [self reloadSpecifiers];
}

-(NSString *)lockappOne {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsFile];
    NSString *bundleID = [dict objectForKey:@"LockApp1"];
    
    ALApplicationList *al = [ALApplicationList sharedApplicationList];
    NSString *appName = [al valueForKey:@"displayName" forDisplayIdentifier:bundleID];
    
    [dict release];
    return appName;
}
-(NSString *)lockappTwo {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsFile];
    NSString *bundleID = [dict objectForKey:@"LockApp2"];
    
    ALApplicationList *al = [ALApplicationList sharedApplicationList];
    NSString *appName = [al valueForKey:@"displayName" forDisplayIdentifier:bundleID];
    
    [dict release];
    return appName;
}
-(NSString *)lockappThree {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsFile];
    NSString *bundleID = [dict objectForKey:@"LockApp3"];
    
    ALApplicationList *al = [ALApplicationList sharedApplicationList];
    NSString *appName = [al valueForKey:@"displayName" forDisplayIdentifier:bundleID];
    
    [dict release];
    return appName;
}
-(NSString *)lockappFour {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsFile];
    NSString *bundleID = [dict objectForKey:@"LockApp4"];
    
    ALApplicationList *al = [ALApplicationList sharedApplicationList];
    NSString *appName = [al valueForKey:@"displayName" forDisplayIdentifier:bundleID];
    
    [dict release];
    return appName;
}
-(NSString *)lockappFive {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsFile];
    NSString *bundleID = [dict objectForKey:@"LockApp5"];
    
    ALApplicationList *al = [ALApplicationList sharedApplicationList];
    NSString *appName = [al valueForKey:@"displayName" forDisplayIdentifier:bundleID];
    
    [dict release];
    return appName;
}
@end