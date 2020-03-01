//
//  ExportProgressWindowController.m
//  Extract Touchbar Icons
//
//  Created by Alfonso Maria Tesauro on 01/03/2020.
//  Copyright © 2020 Alfonso Maria Tesauro. All rights reserved.
//

#import "ExportProgressWindowController.h"

@interface ExportProgressWindowController ()

@end

@implementation ExportProgressWindowController

- (instancetype)init {
    
    self = [super initWithWindowNibName:[self className] owner:self];
    
    if (self) {
        
    }
    
    return self;
}


- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    [self.spinningIndicator startAnimation:self];
}

@end
