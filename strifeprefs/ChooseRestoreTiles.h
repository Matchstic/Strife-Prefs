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
* AippAppListCell.h
*
* edited by deVbug
*/

/**
* RestoreTileCell.h
*
* edited by matchstick
*/

#import <UIKit/UIKit.h>

@interface RestoreTilesController: PSViewController <UITableViewDelegate, UITableViewDataSource> {
    UITableView *_tableView;
    NSMutableArray *_defaultList;
    NSMutableArray *_extraList;
    NSMutableString *_title;
    UIView *window;
    UIView *__view;
}

- (id)initForContentSize:(CGSize)size;
- (id)view;
- (id)_tableView;
- (id)navigationTitle;
- (void)dealloc;

- (void)loadAvailableTiles;

- (int)numberOfSectionsInTableView:(UITableView *)tableView;
- (id)tableView:(UITableView *)tableView titleForHeaderInSection:(int)section;
- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(int)section;
- (id)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@property(retain) NSIndexPath* lastIndexPath;

@end