//
//  strifeprefsController.m
//  strifeprefs
//
//  Created by Matt Clarke (Matchstic, matchstick) on 28/03/2013.
//

#import "strifeprefsController.h"
#import <Preferences/PSSpecifier.h>
#import "ALApplicationList.h"

static NSString *settingsFile = @"/var/mobile/Library/DreamBoard/Strife/Info.plist";

@implementation strifeprefsController
// Load up the cells from the plist
-(id)specifiers {
	if(_specifiers == nil) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"strifeprefs" target:self] retain];
    }
    return _specifiers;
}

// Hack to display correct value on the lockscreen enabled cell
-(void)viewDidAppear:(BOOL)arg1 {
    // Load correct value
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsFile];
    BOOL lockscreen = [[dict objectForKey:@"ShowsLockscreen"] boolValue];
    [dict release];
    
    // Set correct value in a file Preferences can load up the bool from
    NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.matchstick.strifeprefs.plist"];
    [plistDict setValue:[NSNumber numberWithBool:lockscreen] forKey:@"ShowsLockscreen"];
    [plistDict writeToFile:@"/var/mobile/Library/Preferences/com.matchstick.strifeprefs.plist" atomically:YES];
    [plistDict release];
    
    [self reloadSpecifiers];
}

// Correctly set ShowsLockscreen in the Info.plist
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

// backend to respring button
-(IBAction)respring:(id)sender {
    setuid(0);
    system("killall SpringBoard");
}

// not a clue if this is even needed now!
-(BOOL)getLockscreenOn {
    BOOL lockscreen = nil;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsFile];
    lockscreen = [[dict objectForKey:@"ShowsLockscreen"] boolValue];
    
    [dict release];
    return lockscreen;
}

// Hack to get current tile colour to display on the PSLinkListCell
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

// not a clue if this is even needed now!
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
    // Make sure that any changes are reflected when moving back in preferences
    [self reloadSpecifiers];
}

// Series of hacks to get current lock app display names - needed for the PSLinkListCell's again
-(NSString *)lockappOne {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsFile];
    NSString *bundleID = [dict objectForKey:@"LockApp1"];
    
    // Use AppList to get a list of installed apps, and get the displayID from that
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

@implementation backupPageController
-(id)specifiers {
	if(_specifiers == nil) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"backup" target:self] retain];
    }
    return _specifiers;
}

-(void)backUpPrefs {
    // Copy Info.plist and Tiles.plist to Application Support/strifeprefs
    NSFileManager *fileManger=[NSFileManager defaultManager];
    NSError *error;
    
    NSString *infoPlistDest= @"/Library/Application Support/strifeprefs/Info.plist";
    NSString *tilesPlistDest= @"/Library/Application Support/strifeprefs/Tiles.plist";
    
    NSString *infoPlistSource = @"/var/mobile/Library/DreamBoard/Strife/Info.plist";
    NSString *tilesPlistSource = @"/var/mobile/Library/DreamBoard/Strife/Tiles.plist";
    
    [fileManger removeItemAtPath:infoPlistDest error:&error];
    [fileManger removeItemAtPath:tilesPlistDest error:&error];
    
    [fileManger copyItemAtPath:infoPlistSource toPath:infoPlistDest error:&error];
    [fileManger copyItemAtPath:tilesPlistSource toPath:tilesPlistDest error:&error];
    
    [fileManger release];
    
    // Display alert to say completed
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Completed"
                                                    message:@"Backup of Strife preferences completed, remember to press Restore after updating Strife."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

-(void)restorePrefs {
    // Copy Info.plist and Tiles.plist to Strife folder
    NSFileManager *fileManger=[NSFileManager defaultManager];
    NSError *error;
    
    NSString *infoPlistSource= @"/Library/Application Support/strifeprefs/Info.plist";
    NSString *tilesPlistSource= @"/Library/Application Support/strifeprefs/Tiles.plist";
    
    NSString *infoPlistDest = @"/var/mobile/Library/DreamBoard/Strife/Info.plist";
    NSString *tilesPlistDest = @"/var/mobile/Library/DreamBoard/Strife/Tiles.plist";
    
    if ([fileManger fileExistsAtPath:infoPlistSource ] == YES) {
        [fileManger removeItemAtPath:infoPlistDest error:&error];
        [fileManger removeItemAtPath:tilesPlistDest error:&error];
        
        [fileManger copyItemAtPath:infoPlistSource toPath:infoPlistDest error:&error];
        [fileManger copyItemAtPath:tilesPlistSource toPath:tilesPlistDest error:&error];
        
        // Display alert to say completed
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Completed"
                                                        message:@"Restore of Strife preferences completed, respring to show the changes."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    } else {
        // Display alert to say failed
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed"
                                                        message:@"Restore failed, there's no backup available to restore from."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    [fileManger release];
}
@end