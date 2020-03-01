//
//  ExportProgressWindowController.h
//  Extract Touchbar Icons
//
//  Created by Alfonso Maria Tesauro on 01/03/2020.
//  Copyright © 2020 Alfonso Maria Tesauro. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExportProgressWindowController : NSWindowController

@property (weak) IBOutlet NSProgressIndicator *spinningIndicator;


@end

NS_ASSUME_NONNULL_END
