/*
*
* AlwaysiPodPlaySettings.m
* AlwaysiPodPlay's Settings bundle
*
*
* Always iPod Play
* Copyright (C) 2011 deVbug (devbug@devbug.me)
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program. If not, see <http://www.gnu.org/licenses/>.
*
*/

/*
Preference.m
Edit by r_plus.
1. Replace MBProgressHUD to UIProgressHUD(PrivateAPI).
*/

/*
ChooseRestoreFiles.m
Edit by matchstick
*/

#import <UIKit/UITextView.h>
#import <Preferences/Preferences.h>

#import <RestoreTileCell.h>
#import <ChooseRestoreTiles.h>

#include <objc/runtime.h>

#define PREFERENCE_PATH @"/var/mobile/Library/Preferences/com.matchstick.strifeprefs.plist"


extern NSInteger compareDisplayNames(NSString *a, NSString *b, void *context);
extern NSArray *defaultApplicationDisplayIdentifiers();
extern NSArray *extraApplicationDisplayIdentifiers();

@implementation RestoreTilesController

-(id)initForContentSize:(CGSize)size {
    if ((self = [super initForContentSize:size]) != nil) {
        _defaultList = nil;
        _extraList = nil;

        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480-64) style:UITableViewStyleGrouped];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];

        __view = nil;
        window = [[UIApplication sharedApplication] keyWindow];
        if (window == nil) {
            __view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480-64)];
            [__view addSubview:_tableView];
            window = __view;
        }

        if(!_title)
            _title = [[NSMutableString alloc] init];

        [_title setString:@"Tiles"];

        if ([self respondsToSelector:@selector(navigationItem)])
            [[self navigationItem] setTitle:_title];

        [self loadAvailableTiles];
    }

return self;
}

-(void)loadAvailableTiles {
    [_extraList release];
    [_defaultList release];
    _defaultList = nil;
    _extraList = nil;

    NSSet *set = [NSSet setWithArray:defaultApplicationDisplayIdentifiers()];
    NSArray *sortedArray = [[set allObjects] sortedArrayUsingFunction:compareDisplayNames context:NULL];
    
    NSSet *setTwo = [NSSet setWithArray:extraApplicationDisplayIdentifiers()];
    NSArray *sortedArrayTwo = [[setTwo allObjects] sortedArrayUsingFunction:compareDisplayNames context:NULL];

    _defaultList = [sortedArray retain];
    _extraList = [sortedArrayTwo retain];

    [_tableView reloadData];
}


-(id)view {
    if (__view)
        return __view;

    return _tableView;
}

-(id)_tableView {
    return _tableView;
}

-(id)navigationTitle {
    return _title;
}

-(int)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(id)tableView:(UITableView *)tableView titleForHeaderInSection:(int)section {
    if(section == 0)
        return @"Default tiles";
    else
        return @"Additional tiles";
}

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(int)section {
    if(!_defaultList)
        return 0;
    if(section == 0)
        return [_defaultList count];
    else
        return [_extraList count];
}

-(id)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RestoreTileCell *cell = (RestoreTileCell *)[tableView dequeueReusableCellWithIdentifier:@"RestoreTileCell"];
    if (!cell)
        cell = [[[RestoreTileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RestoreTileCell"] autorelease];
    
    NSString *identifier = nil;
    
    // Set up the cells
    if(indexPath.section == 0)
        cell.displayId = [_defaultList objectAtIndex:indexPath.row];
    else
        cell.displayId = [_extraList objectAtIndex:indexPath.row];

    BOOL isInArray = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:PREFERENCE_PATH]) {
        NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:PREFERENCE_PATH];
        
        if (data) {
            if(indexPath.section == 0) {
                identifier = [_defaultList objectAtIndex:indexPath.row];
            } else {
                identifier = [_extraList objectAtIndex:indexPath.row];
            }
            NSArray *tiles = [data objectForKey:@"restoreTiles"];
            
            if (tiles != nil) {
                for (NSString *str in tiles) {
                    if ([identifier isEqualToString:str]) {
                        isInArray = YES;
                        break;
                    }
                }
            }
        }
    }
    
    if (isInArray) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    // Initialize thumbnails
    //NSArray *thumbnails = [NSArray arrayWithObjects:@"Lime.jpg", @"Green.jpg", @"Emerald.jpg", @"Teal.jpg", @"Cyan.jpg", @"Cobalt.jpg", @"Indigo.jpg", @"Violet.jpg", @"Pink.jpg", @"Magenta.jpg", @"Crimson.jpg", @"Red.jpg", @"Orange.jpg", @"Amber.jpg", @"Yellow.jpg", @"Brown.jpg", @"Olive.jpg", @"Steel.jpg", @"Mauve.jpg", @"Taupe.jpg", nil];
    
    //cell.imageView.image = [UIImage imageNamed:[thumbnails objectAtIndex:indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RestoreTileCell *cell = (RestoreTileCell *)[tableView cellForRowAtIndexPath:indexPath];

    [tableView deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:YES];
    NSString *identifier = nil;
    
    if(indexPath.section == 0) {
        identifier = [_defaultList objectAtIndex:indexPath.row];
    } else {
        identifier = [_extraList objectAtIndex:indexPath.row];
    }
    
    NSMutableDictionary *data;
    if ([[NSFileManager defaultManager] fileExistsAtPath:PREFERENCE_PATH]) {
        data = [NSMutableDictionary dictionaryWithContentsOfFile:PREFERENCE_PATH];
    } else {
        data = [NSMutableDictionary dictionary];
    }

    NSMutableArray *tiles = [[data objectForKey:@"restoreTiles"] retain];
    if (tiles == nil)
        tiles = [[NSMutableArray alloc] init];

    NSInteger ind = [tiles indexOfObject:identifier];
    if (ind != NSNotFound) {
        [tiles removeObjectAtIndex:ind];
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        [tiles addObject:identifier];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    self.lastIndexPath = indexPath;

    [data setObject:tiles forKey:@"restoreTiles"];
    [tiles release];

    [data writeToFile:PREFERENCE_PATH atomically:YES];
}

- (void) dealloc {
    [_tableView release];
    [_defaultList release];
    [_extraList release];
    [_title release];
    [__view release];

    [super dealloc];
}


@end


id $PSViewController$initForContentSize$(PSRootController *self, SEL _cmd, CGSize contentSize) {
    return [self init];
}

__attribute__((constructor))
    static void aippInit() {
        if (![[PSViewController class] instancesRespondToSelector:@selector(initForContentSize:)])
            class_addMethod([PSViewController class], @selector(initForContentSize:), (IMP)$PSViewController$initForContentSize$, "@@:{ff}");
    }