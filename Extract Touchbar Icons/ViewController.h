//
//  ViewController.h
//  Extract Touchbar Icons
//
//  Created by Alfonso Maria Tesauro on 01/03/2020.
//  Copyright © 2020 Alfonso Maria Tesauro. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TouchBarIconExtractManager.h"

@interface ViewController : NSViewController <NSTableViewDataSource,NSTableViewDelegate>

@property (strong) NSMutableArray   *touchBarImagesArray;
@property (weak) IBOutlet NSTableView   *tableView;

@end

