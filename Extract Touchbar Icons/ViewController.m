//
//  ViewController.m
//  Extract Touchbar Icons
//
//  Created by Alfonso Maria Tesauro on 01/03/2020.
//  Copyright © 2020 Alfonso Maria Tesauro. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    [self loadAllImagesNames:self];
   
}

- (void)loadAllImagesNames:(id)sender {
    
    NSError *error;
          NSString *allIconsTextFilePath = [[NSBundle mainBundle] pathForResource:@"AppleDeveloper" ofType:@"txt"];
          
          NSString *allIconsTextString = [NSString stringWithContentsOfFile:allIconsTextFilePath encoding:NSUTF8StringEncoding error:&error];
          
          NSArray *lines = [allIconsTextString componentsSeparatedByString:@"\n"];
          
       
          self.touchBarImagesArray = [[NSMutableArray alloc] init];
       
          for (NSString *currentLine in lines) {
              
              if ([currentLine rangeOfString:@".    "].location == NSNotFound) {
                  continue;
              }
              
              NSArray *componentsOfSpecificLine = [currentLine componentsSeparatedByString:@".    "];
              
              NSString *searchedWord = [componentsOfSpecificLine lastObject];
              
              NSString *finalWord = [searchedWord stringByReplacingOccurrencesOfString:@"touchBar" withString:@"NSImageNameTouchBar"];
              NSString *finalWordProcessed = [searchedWord stringByReplacingOccurrencesOfString:@"touchBar" withString:@"NSTouchBar"];
              
              NSMutableDictionary *entry = [NSMutableDictionary new];
              [entry setValue:finalWord forKey:@"extractedName"];
              [entry setValue:finalWordProcessed forKey:@"extractedNameForCocoa"];
              
              
              [entry setValue:[NSImage imageNamed:finalWordProcessed] forKey:@"icon"];

              
              [self.touchBarImagesArray addObject:entry];
              
          }
    
    [self.tableView reloadData];
    
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)userDidSelectExportAsPNGMenuItem:(NSMenuItem *)senderMenuItem {
    
    NSUInteger row = [self.tableView clickedRow];
    
    NSMutableDictionary *entry = self.touchBarImagesArray[row];
    
    NSSavePanel *panel = [NSSavePanel new];
    panel.message = @"Select a destination";
    NSString *desktopFolderPath = [NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES) firstObject];
    panel.directoryURL = [NSURL fileURLWithPath:desktopFolderPath];
    panel.nameFieldStringValue = [NSString stringWithFormat:@"%@.png",[entry valueForKey:@"extractedName"]];
    
    [panel beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse result) {
        
        if (result == NSModalResponseOK) {
            NSString *path = panel.URL.path;
         
            if (self.exportProgressWindowController == nil) {
                self.exportProgressWindowController = [[ExportProgressWindowController alloc] init];
            }
            
            [self.view.window beginSheet:self.exportProgressWindowController.window completionHandler:^(NSModalResponse returnCode) {
                
            }];
            
            dispatch_queue_t backgroundQueue =
            dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
            dispatch_async(backgroundQueue, ^{
                // Do Work
                
                [TouchBarIconExtractManager writeImageToDisk:[entry valueForKey:@"icon"] withPath:path];
              
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Return Result
                    [self.view.window endSheet:self.exportProgressWindowController.window];
                    dispatch_async(dispatch_get_main_queue(), ^{

                    NSAlert *alert = [NSAlert new];
                    alert.messageText = @"Extract TouchBar Icons Message";
                    alert.informativeText = @"The image has been correctly exported.";
                    NSButton *shouldRevealButton = [[NSButton alloc] initWithFrame:NSMakeRect(0,0,230,40)];
                    [shouldRevealButton setButtonType:NSButtonTypeSwitch];
                    shouldRevealButton.title = @"Reveal the extracted file in Finder";
                    alert.accessoryView = shouldRevealButton;
                        
                    [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
                        
                        if (shouldRevealButton.state == NSControlStateValueOn) {
                            [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:@[[NSURL fileURLWithPath:path]]];
                        }
                        
                    }];
                    
                });
                    
                });
            });
            
           
        }
        
    }];
    
    
    
    
    
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.touchBarImagesArray.count;
}


- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"iconsCellIdentifier" owner:self];
    
    cellView.textField.stringValue = self.touchBarImagesArray[row][@"extractedName"];
    cellView.imageView.image = self.touchBarImagesArray[row][@"icon"];
    
    return cellView;
    
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 65.0;
}

@end





