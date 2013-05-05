//
//  strifeprefsController.m
//  strifeprefs
//
//  Created by Matt Clarke (Matchstic, matchstick) on 28/03/2013.
//

#import "strifeprefsController.h"
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSViewController.h>
#import <Preferences/PSRootController.h>
#import "ALApplicationList.h"
#include <dispatch/dispatch.h>

#import <ChooseRestoreTiles.h>

//RGB color macro
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

static NSString *settingsFile = @"/var/mobile/Library/DreamBoard/Strife/Info.plist";

@implementation strifeprefsController
// Load up the cells from the plist
-(id)specifiers {
	if(_specifiers == nil) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"strifeprefs" target:self] retain];
        _specifiers = [self localizedSpecifiersForSpecifiers:_specifiers];
    }
    return _specifiers;
}

- (NSArray *)localizedSpecifiersForSpecifiers:(NSArray *)s {
	int i;
	for(i=0; i<[s count]; i++) {
		if([[s objectAtIndex: i] name]) {
			[[s objectAtIndex: i] setName:[[self bundle] localizedStringForKey:[[s objectAtIndex: i] name] value:[[s objectAtIndex: i] name] table:nil]];
		}
		if([[s objectAtIndex: i] titleDictionary]) {
			NSMutableDictionary *newTitles = [[NSMutableDictionary alloc] init];
			for(NSString *key in [[s objectAtIndex: i] titleDictionary]) {
				[newTitles setObject: [[self bundle] localizedStringForKey:[[[s objectAtIndex: i] titleDictionary] objectForKey:key] value:[[[s objectAtIndex: i] titleDictionary] objectForKey:key] table:nil] forKey: key];
			}
			[[s objectAtIndex: i] setTitleDictionary: [newTitles autorelease]];
		}
	}
	
	return s;
};

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
        _specifiers = [self localizedSpecifiersForSpecifiers:_specifiers];
    }
    return _specifiers;
}

- (NSArray *)localizedSpecifiersForSpecifiers:(NSArray *)s {
	int i;
	for(i=0; i<[s count]; i++) {
		if([[s objectAtIndex: i] name]) {
			[[s objectAtIndex: i] setName:[[self bundle] localizedStringForKey:[[s objectAtIndex: i] name] value:[[s objectAtIndex: i] name] table:nil]];
		}
		if([[s objectAtIndex: i] titleDictionary]) {
			NSMutableDictionary *newTitles = [[NSMutableDictionary alloc] init];
			for(NSString *key in [[s objectAtIndex: i] titleDictionary]) {
				[newTitles setObject: [[self bundle] localizedStringForKey:[[[s objectAtIndex: i] titleDictionary] objectForKey:key] value:[[[s objectAtIndex: i] titleDictionary] objectForKey:key] table:nil] forKey: key];
			}
			[[s objectAtIndex: i] setTitleDictionary: [newTitles autorelease]];
		}
	}
	
	return s;
};

// not a clue if this is even needed now!
-(void)setHexColour:(id)value specifier:(id)specifier {
    NSLog(@"Strife_prefs: Hex value is %@", value);
}
@end

@implementation mainThemePageController
-(id)specifiers {
	if(_specifiers == nil) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"Main theme" target:self] retain];
        _specifiers = [self localizedSpecifiersForSpecifiers:_specifiers];
    }
    return _specifiers;
}

- (NSArray *)localizedSpecifiersForSpecifiers:(NSArray *)s {
	int i;
	for(i=0; i<[s count]; i++) {
		if([[s objectAtIndex: i] name]) {
			[[s objectAtIndex: i] setName:[[self bundle] localizedStringForKey:[[s objectAtIndex: i] name] value:[[s objectAtIndex: i] name] table:nil]];
		}
		if([[s objectAtIndex: i] titleDictionary]) {
			NSMutableDictionary *newTitles = [[NSMutableDictionary alloc] init];
			for(NSString *key in [[s objectAtIndex: i] titleDictionary]) {
				[newTitles setObject: [[self bundle] localizedStringForKey:[[[s objectAtIndex: i] titleDictionary] objectForKey:key] value:[[[s objectAtIndex: i] titleDictionary] objectForKey:key] table:nil] forKey: key];
			}
			[[s objectAtIndex: i] setTitleDictionary: [newTitles autorelease]];
		}
	}
	
	return s;
};
@end

@implementation lockAppPageController
-(id)specifiers {
	if(_specifiers == nil) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"Lockapps" target:self] retain];
        _specifiers = [self localizedSpecifiersForSpecifiers:_specifiers];
    }
    return _specifiers;
}

- (NSArray *)localizedSpecifiersForSpecifiers:(NSArray *)s {
	int i;
	for(i=0; i<[s count]; i++) {
		if([[s objectAtIndex: i] name]) {
			[[s objectAtIndex: i] setName:[[self bundle] localizedStringForKey:[[s objectAtIndex: i] name] value:[[s objectAtIndex: i] name] table:nil]];
		}
		if([[s objectAtIndex: i] titleDictionary]) {
			NSMutableDictionary *newTitles = [[NSMutableDictionary alloc] init];
			for(NSString *key in [[s objectAtIndex: i] titleDictionary]) {
				[newTitles setObject: [[self bundle] localizedStringForKey:[[[s objectAtIndex: i] titleDictionary] objectForKey:key] value:[[[s objectAtIndex: i] titleDictionary] objectForKey:key] table:nil] forKey: key];
			}
			[[s objectAtIndex: i] setTitleDictionary: [newTitles autorelease]];
		}
	}
	
	return s;
};

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
        _specifiers = [self localizedSpecifiersForSpecifiers:_specifiers];
    }
    return _specifiers;
}


- (NSArray *)localizedSpecifiersForSpecifiers:(NSArray *)s {
	int i;
	for(i=0; i<[s count]; i++) {
		if([[s objectAtIndex: i] name]) {
			[[s objectAtIndex: i] setName:[[self bundle] localizedStringForKey:[[s objectAtIndex: i] name] value:[[s objectAtIndex: i] name] table:nil]];
		}
		if([[s objectAtIndex: i] titleDictionary]) {
			NSMutableDictionary *newTitles = [[NSMutableDictionary alloc] init];
			for(NSString *key in [[s objectAtIndex: i] titleDictionary]) {
				[newTitles setObject: [[self bundle] localizedStringForKey:[[[s objectAtIndex: i] titleDictionary] objectForKey:key] value:[[[s objectAtIndex: i] titleDictionary] objectForKey:key] table:nil] forKey: key];
			}
			[[s objectAtIndex: i] setTitleDictionary: [newTitles autorelease]];
		}
	}
	
	return s;
};

-(void)backUpTiles {
    
    hud = [[UIProgressHUD alloc] initWithWindow:[[UIApplication sharedApplication] keyWindow]];
    [hud setText:@"Backing up..."];
    [hud show:YES];
    [hud setAlpha:0.0f];
    CGAffineTransform affine = CGAffineTransformMakeScale (0.3, 0.3);
    [hud setTransform: affine];
    [UIView beginAnimations: nil context: NULL];
    [UIView setAnimationDuration: 0.2];
    [hud setAlpha:1.0f];
    affine = CGAffineTransformMakeScale (1.0, 1.0);
    [hud setTransform: affine];
    [UIView commitAnimations];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        // Copy Tiles dir to Preferences/strifeprefs
        NSFileManager *fileManger=[NSFileManager defaultManager];
        NSError *error;
    
        NSString *tilesDest= @"/var/mobile/Library/Preferences/strifeprefs/Tiles";
    
        NSString *tilesSource = @"/var/mobile/Library/DreamBoard/Strife/Resources/Tiles";
    
        [fileManger removeItemAtPath:tilesDest error:&error];
    
        [fileManger copyItemAtPath:tilesSource toPath:tilesDest error:&error];
    
        [fileManger release];
    
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.matchstick.strifeprefs.plist"];
            [plistDict setValue:[NSNumber numberWithBool:YES] forKey:@"tilesBackedUp"];
            [plistDict writeToFile:@"/var/mobile/Library/Preferences/com.matchstick.strifeprefs.plist" atomically:YES];
            [plistDict release];
            
            [hud setText:@"Done!"];
            [hud done];
            [self performSelector:@selector(hideHud) withObject:nil afterDelay:1.5f];
        });
    });
    
}

-(void)restoreTiles {
    // Display alert to say failed
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed"
                                                    message:@"Currently, you need to do this manually. Tiles are located at /var/mobile/Library/Preferences/strifeprefs/Tiles"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    
    // Create the root view controller for the navigation controller
    
    //restoreTilesController *addController = [[restoreTilesController alloc] init];
    
    // Present it.
    //[popToViewController:addController animated:YES];
    
    //[addController release];
}

-(void)backUpPrefs {
    
    hud = [[UIProgressHUD alloc] initWithWindow:[[UIApplication sharedApplication] keyWindow]];
    [hud setText:@"Backing up..."];
    [hud show:YES];
    [hud setAlpha:0.0f];
    CGAffineTransform affine = CGAffineTransformMakeScale (0.3, 0.3);
    [hud setTransform: affine];
    [UIView beginAnimations: nil context: NULL];
    [UIView setAnimationDuration: 0.2];
    [hud setAlpha:1.0f];
    affine = CGAffineTransformMakeScale (1.0, 1.0);
    [hud setTransform: affine];
    [UIView commitAnimations];
    
    // Copy Info.plist and Tiles.plist to Preferences/strifeprefs
    NSFileManager *fileManger=[NSFileManager defaultManager];
    NSError *error;
    
    NSString *infoPlistDest= @"/var/mobile/Library/Preferences/strifeprefs/Info.plist";
    NSString *tilesPlistDest= @"/var/mobile/Library/Preferences/strifeprefs/Tiles.plist";
    
    NSString *infoPlistSource = @"/var/mobile/Library/DreamBoard/Strife/Info.plist";
    NSString *tilesPlistSource = @"/var/mobile/Library/DreamBoard/Strife/Tiles.plist";
    
    [fileManger removeItemAtPath:infoPlistDest error:&error];
    [fileManger removeItemAtPath:tilesPlistDest error:&error];
    
    [fileManger copyItemAtPath:infoPlistSource toPath:infoPlistDest error:&error];
    [fileManger copyItemAtPath:tilesPlistSource toPath:tilesPlistDest error:&error];
    
    [fileManger release];
    
    [hud setText:@"Done!"];
    [hud done];
    [self performSelector:@selector(hideHud) withObject:nil afterDelay:1.5f];
}

-(void)hideHud {
    [hud hide];
    [hud release];
}

-(void)restorePrefs {
    
    hud = [[UIProgressHUD alloc] initWithWindow:[[UIApplication sharedApplication] keyWindow]];
    [hud setText:@"Restoring..."];
    [hud show:YES];
    [hud setAlpha:0.0f];
    CGAffineTransform affine = CGAffineTransformMakeScale (0.3, 0.3);
    [hud setTransform: affine];
    [UIView beginAnimations: nil context: NULL];
    [UIView setAnimationDuration: 0.2];
    [hud setAlpha:1.0f];
    affine = CGAffineTransformMakeScale (1.0, 1.0);
    [hud setTransform: affine];
    [UIView commitAnimations];
    
    // Copy Info.plist and Tiles.plist to Strife folder
    NSFileManager *fileManger=[NSFileManager defaultManager];
    NSError *error;
    
    NSString *infoPlistSource= @"/var/mobile/Library/Preferences/strifeprefs/Info.plist";
    NSString *tilesPlistSource= @"/var/mobile/Library/Preferences/strifeprefs/Tiles.plist";
    
    NSString *infoPlistDest = @"/var/mobile/Library/DreamBoard/Strife/Info.plist";
    NSString *tilesPlistDest = @"/var/mobile/Library/DreamBoard/Strife/Tiles.plist";
    
    if ([fileManger fileExistsAtPath:infoPlistSource ] == YES) {
        [fileManger removeItemAtPath:infoPlistDest error:&error];
        [fileManger removeItemAtPath:tilesPlistDest error:&error];
        
        [fileManger copyItemAtPath:infoPlistSource toPath:infoPlistDest error:&error];
        [fileManger copyItemAtPath:tilesPlistSource toPath:tilesPlistDest error:&error];
        
        [hud setText:@"Done!"];
        [hud done];
        [self performSelector:@selector(hideHud) withObject:nil afterDelay:1.5f];
        
    } else {
        [hud hide];
        [hud release];
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

@implementation restoreTilesController
-(id)specifiers {
    if (_specifiers == nil) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"RestoreTiles" target:self] retain];
        _specifiers = [self localizedSpecifiersForSpecifiers:_specifiers];
    }
    return _specifiers;
}

- (NSArray *)localizedSpecifiersForSpecifiers:(NSArray *)s {
	int i;
	for(i=0; i<[s count]; i++) {
		if([[s objectAtIndex: i] name]) {
			[[s objectAtIndex: i] setName:[[self bundle] localizedStringForKey:[[s objectAtIndex: i] name] value:[[s objectAtIndex: i] name] table:nil]];
		}
		if([[s objectAtIndex: i] titleDictionary]) {
			NSMutableDictionary *newTitles = [[NSMutableDictionary alloc] init];
			for(NSString *key in [[s objectAtIndex: i] titleDictionary]) {
				[newTitles setObject: [[self bundle] localizedStringForKey:[[[s objectAtIndex: i] titleDictionary] objectForKey:key] value:[[[s objectAtIndex: i] titleDictionary] objectForKey:key] table:nil] forKey: key];
			}
			[[s objectAtIndex: i] setTitleDictionary: [newTitles autorelease]];
		}
	}
	
	return s;
};

-(void)restoreSelected {
    hud = [[UIProgressHUD alloc] initWithWindow:[[UIApplication sharedApplication] keyWindow]];
    [hud setText:@"Restoring..."];
    [hud show:YES];
    [hud setAlpha:0.0f];
    CGAffineTransform affine = CGAffineTransformMakeScale (0.3, 0.3);
    [hud setTransform: affine];
    [UIView beginAnimations: nil context: NULL];
    [UIView setAnimationDuration: 0.2];
    [hud setAlpha:1.0f];
    affine = CGAffineTransformMakeScale (1.0, 1.0);
    [hud setTransform: affine];
    [UIView commitAnimations];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        NSError *error = nil;
        NSString *tilesSource = @"/var/mobile/Library/Preferences/strifeprefs/Tiles/";
        NSString *tilesDest = @"/var/mobile/Library/DreamBoard/Strife/Resources/Tiles/";
        NSFileManager* fileManager = [NSFileManager defaultManager];
        NSArray *availableTiles = [fileManager contentsOfDirectoryAtPath:tilesSource error:&error];
    
        NSMutableDictionary *data = [NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.matchstick.strifeprefs.plist"];
        NSArray *restoreTiles = [[data objectForKey:@"restoreTiles"] retain];
    
        // Check if directory name is in restoreTiles
        for (availableTiles in restoreTiles) {
            for (NSString *identifier in restoreTiles) {
                // If it is, copy it.
                if (identifier)
                    // However, we must parse the directory to make sure it doesn't have any non-writeable files, so
                    // set their owner to be mobile!
                    
                    // www.exilesofthardware.blogspot.com/2013/01/ios-run-application-with-root-privileges.html
                    setuid(0);
                
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                
                    [dict setObject:@"mobile" forKey:NSFileOwnerAccountName];
                    [dict setObject:@"mobile" forKey:NSFileGroupOwnerAccountName];
                
                    NSArray *subPaths = [fileManager subpathsAtPath:[tilesDest stringByAppendingString:identifier]];
                    for (NSString *aPath in subPaths) {
                        // Change the permissions on the file
                        setuid(0);
                        NSError *error = nil;
                        NSLog(@"Setting file permissions in main directory");
                        [[NSFileManager defaultManager] setAttributes:dict ofItemAtPath:aPath error:&error];
                        
                        // Mucking about with directory permissions ;P
                        BOOL isDirectory;
                        [fileManager fileExistsAtPath:aPath isDirectory:&isDirectory];
                        if (isDirectory) {
                            NSLog(@"Ooh, we have ourselves a subdirectory!");
                            // Change the permissions of files in directory here
                            NSError *error = nil;
                            NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:aPath];
                            NSLog(@"About to enter while loop");
                            // Change permissions of file
                            for (NSString *file in dirEnum) {
                                [fileManager setAttributes:dict ofItemAtPath:[aPath stringByAppendingPathComponent:file] error:&error];
                                // If it's actually a subdirectory, repeat this for files within it
                                NSString *subdirPath = [aPath stringByAppendingPathComponent:file];
                                [fileManager fileExistsAtPath:subdirPath isDirectory:&isDirectory];
                                NSLog(@"Checked if its a subdir or not");
                                if (isDirectory) {
                                    NSLog(@"'Tis a subdir");
                                    [self isActuallySubdirectory:subdirPath];
                                }
                            }
                        }
                    }
                
                    [dict release];
                
                    [fileManager removeItemAtPath:[tilesDest stringByAppendingString:identifier] error:&error];
                    setuid(501);
                    [fileManager copyItemAtPath:[tilesSource stringByAppendingString:identifier] toPath:[tilesDest stringByAppendingString:identifier] error:&error];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud setText:@"Done!"];
            [hud done];
            [self performSelector:@selector(hideHud) withObject:nil afterDelay:1.5f];
        });
        
        // Clean-up
        [restoreTiles release];
        [availableTiles release];
        [tilesDest release];
        [tilesSource release];
        [error release];
        
    });
}
                   
-(void)hideHud {
    [hud hide];
    [hud release];
}

-(void)isActuallySubdirectory:(NSString *)subdirPath {
    NSLog(@"Let's run that funky method");
    NSError *error = nil;
    NSString *subPath = subdirPath;
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSArray *availableFiles = [fileManager contentsOfDirectoryAtPath:subPath error:&error];
    
    // Check for files in subdirectory
        for (NSString *filename in availableFiles) {
            NSLog(@"There's filenames in the directory!");
            // If it is, copy it.
            if (filename) {
                // Parse the directory to make sure it doesn't have any non-writeable files
                setuid(0);
            
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            
                [dict setObject:@"mobile" forKey:NSFileOwnerAccountName];
                [dict setObject:@"mobile" forKey:NSFileGroupOwnerAccountName];
            
                NSArray *subPaths = [fileManager subpathsAtPath:[subPath stringByAppendingString:filename]];
                for (NSString *aPath in subPaths) {
                    NSLog(@"There's aPath in subPaths");
                    // Change the permissions on the file
                    setuid(0);
                    NSError *error = nil;
                    [[NSFileManager defaultManager] setAttributes:dict ofItemAtPath:aPath error:&error];
                    
                    NSLog(@"Set it's permissions");
                    // Mucking about with directory permissions ;P
                    BOOL isDirectory;
                    [fileManager fileExistsAtPath:aPath isDirectory:&isDirectory];
                    if (isDirectory) {
                        NSLog(@"It's a subdir!");
                        // Change the permissions of files in directory here
                        NSError *error = nil;
                        NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:aPath];
                        NSString *file;
                        // Change permissions of file
                        for (file in dirEnum) {
                            NSLog(@"Entering while loop");
                            [fileManager setAttributes:dict ofItemAtPath:[aPath stringByAppendingPathComponent:file] error:&error];
                            // If it's actually a subdirectory, repeat this for files within it
                            NSString *subdirPath = [aPath stringByAppendingPathComponent:file];
                            [fileManager fileExistsAtPath:aPath isDirectory:&isDirectory];
                            if (isDirectory) {
                                NSLog(@"'Tis another subdir!");
                                [self isActuallySubdirectory:subdirPath];
                            }
                        }
                    }
                }
            
            [dict release];
            }
        }
}

@end

@interface restoreTilesCell : PSTableCell <PreferencesTableCustomView> {
    UILabel *_label;
}
-(CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length;
-(UIColor *)colorWithHexString: (NSString *) hexString;

@end

@implementation restoreTilesCell
- (id)initWithSpecifier:(PSSpecifier *)specifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell" specifier:specifier];
    if (self) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/DreamBoard/Strife/Info.plist"];
        NSString *backgroundColour = [dict objectForKey:@"Theme"];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        [_label setLineBreakMode:NSLineBreakByWordWrapping];
        [_label setNumberOfLines:0];
        [_label setText:@"Restore tiles"];
        [_label setBackgroundColor:[UIColor clearColor]];
        [_label setShadowColor:[UIColor whiteColor]];
        [_label setShadowOffset:CGSizeMake(0,1)];
        [_label setTextAlignment:NSTextAlignmentCenter];
        
        //[self addSubview:_label];
        [_label release];
        
        UIImageView *backgroundView;
        UIImageView *tileView;
        
        // Let's get the background colour for our preview
        // First, check if the iDevice has a retina display
        if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            ([UIScreen mainScreen].scale == 2.0)) {
            // Create dark background
            if ([backgroundColour isEqual: @"Dark"]) {
                CGRect rect = CGRectMake(0, 0, 270, 270);
                UIGraphicsBeginImageContext(rect.size);
                CGContextRef context = UIGraphicsGetCurrentContext();
            
                CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
                CGContextFillRect(context, rect);
            
                UIImage *background = UIGraphicsGetImageFromCurrentImageContext();
                backgroundView = [[UIImageView alloc] initWithImage:background];
                [background release];
                UIGraphicsEndImageContext();
            // Create light background
            } else {
                CGRect rect = CGRectMake(0, 0, 270, 270);
                UIGraphicsBeginImageContext(rect.size);
                CGContextRef context = UIGraphicsGetCurrentContext();
                
                CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
                CGContextFillRect(context, rect);
                
                UIImage *background = UIGraphicsGetImageFromCurrentImageContext();
                backgroundView = [[UIImageView alloc] initWithImage:background];
                [background release];
                UIGraphicsEndImageContext();
            }
        } else {
            if ([backgroundColour isEqual: @"Dark"]) {
                CGRect rect = CGRectMake(0, 0, 130, 130);
                UIGraphicsBeginImageContext(rect.size);
                CGContextRef context = UIGraphicsGetCurrentContext();
                
                CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
                CGContextFillRect(context, rect);
                
                UIImage *background = UIGraphicsGetImageFromCurrentImageContext();
                backgroundView = [[UIImageView alloc] initWithImage:background];
                [background release];
                UIGraphicsEndImageContext();
            } else {
                CGRect rect = CGRectMake(0, 0, 130, 130);
                UIGraphicsBeginImageContext(rect.size);
                CGContextRef context = UIGraphicsGetCurrentContext();
                
                CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
                CGContextFillRect(context, rect);
                
                UIImage *background = UIGraphicsGetImageFromCurrentImageContext();
                backgroundView = [[UIImageView alloc] initWithImage:background];
                [background release];
                UIGraphicsEndImageContext();
            }
        }
        
        // Now, let's get the current hex colour, and create an image the appropriate size
        NSString *tileColour = [dict objectForKey:@"AccentColorHex"];
        if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            ([UIScreen mainScreen].scale == 2.0)) {
            CGRect rect = CGRectMake(0, 0, 230, 230);
            UIGraphicsBeginImageContext(rect.size);
            CGContextRef context = UIGraphicsGetCurrentContext();
            
            //CGContextSetFillColorWithColor(context, [UIColorFromRGB([@"0x" stringByAppendingString:tileColour]) CGColor]);
            CGContextSetFillColorWithColor(context, [[self colorWithHexString:tileColour] CGColor]);
            CGContextFillRect(context, rect);
            
            UIImage *tile = UIGraphicsGetImageFromCurrentImageContext();
            tileView = [[UIImageView alloc] initWithImage:tile];
            [tile release];
            UIGraphicsEndImageContext();
        } else {
            CGRect rect = CGRectMake(0, 0, 115, 115);
            UIGraphicsBeginImageContext(rect.size);
            CGContextRef context = UIGraphicsGetCurrentContext();
                
            //CGContextSetFillColorWithColor(context, [UIColorFromRGB([@"0x" stringByAppendingString:tileColour]) CGColor]);
            CGContextSetFillColorWithColor(context, [[self colorWithHexString:tileColour] CGColor]);
            CGContextFillRect(context, rect);
                
            UIImage *tile = UIGraphicsGetImageFromCurrentImageContext();
            tileView = [[UIImageView alloc] initWithImage:tile];
            [tile release];
            UIGraphicsEndImageContext();
        }
        
        // Almost done! Now get the settings tile image
        UIImage *tileImage = [UIImage imageWithContentsOfFile:@"/var/mobile/Library/DreamBoard/Strife/Resources/Tiles/com.apple.Preferences/Tile.png"];
        UIImageView *tileImageView = [[UIImageView alloc] initWithImage:tileImage];
        
        // Layer image views together into single UIImageView
        UIImageView *previewLayered = [UIImageView alloc];
        
        if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            ([UIScreen mainScreen].scale == 2.0)) {
            [previewLayered setFrame:CGRectMake(0, 0, 270, 270)];
        } else {
            [previewLayered setFrame:CGRectMake(0, 0, 130, 130)];
        }
        
        [previewLayered addSubview:backgroundView];
        [previewLayered addSubview:tileView];
        [previewLayered addSubview:tileImageView];
        
        // Add final view to cell
        [self addSubview:previewLayered];
        
        NSLog(@"Added previewLayered view to cell");
        // Cleanup
        [backgroundView release];
        [tileImageView release];
        [tileView release];
        [dict release];
        [previewLayered release];
    }
    return self;
}

- (float)preferredHeightForWidth:(float)arg1
{
    // Return a custom cell height.
    return 60.f;
}

// This section from Micah Hainline (http://stackoverflow.com/questions/1560081/how-can-i-create-a-uicolor-from-a-hex-string)
-(UIColor *)colorWithHexString: (NSString *) hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
        default:
            [NSException raise:@"Invalid color value" format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
            break;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

-(CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}
@end

@implementation TestController

// Load up the cells from the plist
-(id)specifiers {
	if(_specifiers == nil) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"Nothing" target:self] retain];
        _specifiers = [self localizedSpecifiersForSpecifiers:_specifiers];
    }
    return _specifiers;
}

- (NSArray *)localizedSpecifiersForSpecifiers:(NSArray *)s {
	int i;
	for(i=0; i<[s count]; i++) {
		if([[s objectAtIndex: i] name]) {
			[[s objectAtIndex: i] setName:[[self bundle] localizedStringForKey:[[s objectAtIndex: i] name] value:[[s objectAtIndex: i] name] table:nil]];
		}
		if([[s objectAtIndex: i] titleDictionary]) {
			NSMutableDictionary *newTitles = [[NSMutableDictionary alloc] init];
			for(NSString *key in [[s objectAtIndex: i] titleDictionary]) {
				[newTitles setObject: [[self bundle] localizedStringForKey:[[[s objectAtIndex: i] titleDictionary] objectForKey:key] value:[[[s objectAtIndex: i] titleDictionary] objectForKey:key] table:nil] forKey: key];
			}
			[[s objectAtIndex: i] setTitleDictionary: [newTitles autorelease]];
		}
	}
	
	return s;
};

@end