Main view
- select tiles
  - get array of items in tiles folder
  
    NSError *error = nil;
    NSString *path = @"/var/mobile/Library/Preferences/strifeprefs/Tiles/";
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSArray *directory = [fileManager contentsOfDirectoryAtPath:pathForDirectory error:&error];

    NSMutableArray *dirnames = [[directory mutableCopy] autorelease];
    
  - get display name for each in turn, then add each one to new array (2)
  
  - create a switch cell for each display name from array 2
  - show cells in view, all disabled
  - when switched, get bundle id for the cell's name
  - save bundle id with appropriate bool to plist
- Restore
  - get array of bundle id's that have a bool of true
  - compare each bundle id to folder name
    - if same, copy it back home
  - repeat for all
  - hide modal view
