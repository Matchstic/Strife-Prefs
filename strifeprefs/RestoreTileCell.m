/**
* Name: Backgrounder
* Type: iPhone OS SpringBoard extension (MobileSubstrate-based)
* Description: allow applications to run in the background
* Author: Lance Fetters (aka. ashikase)
* Last-modified: 2010-06-21 00:16:38
*/
/**
* Copyright (C) 2008-2010 Lance Fetters (aka. ashikase)
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions
* are met:
*
* 1. Redistributions of source code must retain the above copyright
* notice, this list of conditions and the following disclaimer.
*
* 2. Redistributions in binary form must reproduce the above copyright
* notice, this list of conditions and the following disclaimer in
* the documentation and/or other materials provided with the
* distribution.
*
* 3. The name of the author may not be used to endorse or promote
* products derived from this software without specific prior
* written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS
* OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
* ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
* INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
* HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
* STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
* IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
* POSSIBILITY OF SUCH DAMAGE.
*/

/**
* AippAppListCell.m
*
* edited by deVbug
*/

/*
* RestoreTileCell.m
*
* edited by matchstick
*/

#import <RestoreTileCell.h>
#import <QuartzCore/CALayer.h>


// SpringBoardServices
extern NSString * SBSCopyLocalizedApplicationNameForDisplayIdentifier(NSString *identifier);
extern NSString * SBSCopyIconImagePathForDisplayIdentifier(NSString *identifier);
extern NSArray * SBSCopyApplicationDisplayIdentifiers(BOOL activeOnly, BOOL unknown);


NSInteger compareDisplayNames(NSString *a, NSString *b, void *context) {
    NSInteger ret;

    NSString *name_a = SBSCopyLocalizedApplicationNameForDisplayIdentifier(a);
    NSString *name_b = SBSCopyLocalizedApplicationNameForDisplayIdentifier(b);
    
    ret = [name_a caseInsensitiveCompare:name_b];
    [name_a release];
    [name_b release];

    return ret;
}

NSArray *extraApplicationDisplayIdentifiers() {
    
    NSError *error = nil;
    NSString *path = @"/var/mobile/Library/Preferences/strifeprefs/Tiles/";
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSArray *directory = [fileManager contentsOfDirectoryAtPath:path error:&error];
    
    NSString *appName = nil;
    
    // Record list of valid identifiers
    NSMutableArray *identifiers = [NSMutableArray array];
    for (NSArray *array in [NSArray arrayWithObject:directory]) {//nonhidden, hidden, nil]) {
        for (NSString *identifier in array) {
            // Get display names for backed up additional tiles
            if (identifier && ![identifier hasPrefix:@"com.apple"])
                
                appName = SBSCopyLocalizedApplicationNameForDisplayIdentifier(identifier);
                if (appName != nil) {
                    [identifiers addObject:identifier];
                }
        }
    }
    
    // Clean-up
    //[directory release];
    [appName release];
    
    return identifiers;
}


NSArray *defaultApplicationDisplayIdentifiers() {

    NSError *error = nil;
    NSString *path = @"/var/mobile/Library/Preferences/strifeprefs/Tiles/";
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSArray *directory = [fileManager contentsOfDirectoryAtPath:path error:&error];
    
    NSString *appName = nil;
    
    // Record list of valid identifiers
    NSMutableArray *identifiers = [NSMutableArray array];
    for (NSArray *array in [NSArray arrayWithObject:directory]) {//nonhidden, hidden, nil]) {
        for (NSString *identifier in array) {
            NSRange range = [identifier rangeOfString:@"apple"];
            // Get display names for backed up default tiles
            if (identifier) 
                if (range.location != NSNotFound) {
                    appName = SBSCopyLocalizedApplicationNameForDisplayIdentifier(identifier);
                    if (appName != nil) {
                        [identifiers addObject:identifier];
                    }
                }
        }
    }

    // Clean-up
    //[directory release];
    [appName release];

    return identifiers;
}


static BOOL isFirmware3x = NO;
static NSData * (*SBSCopyIconImagePNGDataForDisplayIdentifier)(NSString *identifier) = NULL;


@implementation RestoreTileCell

@synthesize displayId, inArray;

+(void)initialize {
    // Determine firmware version
    isFirmware3x = [[[UIDevice currentDevice] systemVersion] hasPrefix:@"3"];
    if (!isFirmware3x) {
        // Firmware >= 4.0
        SBSCopyIconImagePNGDataForDisplayIdentifier = dlsym(RTLD_DEFAULT, "SBSCopyIconImagePNGDataForDisplayIdentifier");
    }
}

-(void)setDisplayId:(NSString *)identifier {
    if (![displayId isEqualToString:identifier]) {
        [displayId release];
        displayId = [identifier copy];

        NSString *displayName = SBSCopyLocalizedApplicationNameForDisplayIdentifier(identifier);
        self.textLabel.text = displayName;
        [displayName release];

        inArray = NotInArray;
    }
}

-(void)layoutSubviews {
    [super layoutSubviews];

    // Rounded Rect for cell image
    CALayer *cellImageLayer = self.imageView.layer;
    [cellImageLayer setCornerRadius:9];
    [cellImageLayer setMasksToBounds:YES];
    
    //CGSize size = self.bounds.size;
    self.imageView.frame = CGRectMake(20.0, 8.0, 300.0, 30.0);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;

    //self.accessoryType = UITableViewCellAccessoryCheckmark;
    //self.textLabel.textColor = [UIColor colorWithRed:81/255.0 green:102/255.0 blue:145/255.0 alpha:1];
}

@end