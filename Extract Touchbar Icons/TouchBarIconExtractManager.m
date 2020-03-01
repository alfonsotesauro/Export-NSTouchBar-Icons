//
//  TouchBarIconExtractManager.m
//  Extract Touchbar Icons
//
//  Created by Alfonso Maria Tesauro on 01/03/2020.
//  Copyright © 2020 Alfonso Maria Tesauro. All rights reserved.
//

#import "TouchBarIconExtractManager.h"

BOOL CGImageWriteToFile(CGImageRef image, NSString *path);

@implementation TouchBarIconExtractManager

+ (void)writeImageToDisk:(NSImage *)icon withPath:(NSString *)destinationPath {
    
    // I could not find a more direct way other than drawing the source into a new NSImage
    // With Lockfocus.
    
    NSImage *renderedIcon = [[NSImage alloc] initWithSize:CGSizeMake(2048, 2048)];
    [renderedIcon lockFocus];

    double ratio = icon.size.width / icon.size.height;
    
    double difference = 2048 - (2048 * ratio);
    
    NSRect inRect = NSMakeRect(difference / 2, 0, 2048 * ratio, 2048);

    [icon drawInRect:inRect];
    
    [renderedIcon unlockFocus];
    
    NSArray *representations = [renderedIcon representations];
   
    // The following returns an instance of NSCGImageSnapshotRep.
    // This uses direct pointer manipulation that forced me to disable ARC
    // For this file. This is not strictly necessary but makes the code
    // Easier to read.
    id cgImageSnapshotRep = [representations firstObject];
    
    // we cast the pointer to any pointer, like for example a long.
    long *corresponding = (long *)cgImageSnapshotRep;
    
    // During debugging, I discovered that the address of the cgImage we are
    // Looking for is 64 bits shifted to the right of the 'corresponding' pointer.
    // Pointer arithmetic works by type, so the following shifts of 64 bits.
    
    corresponding += 8;
    
    // A Further indirection is needed to obtain the address of the cgImage that we see
    // In the debugger.
    
    CGImageRef result2 = (CGImageRef)*corresponding;
    
    // Now everything is easy, we just have to save the cgImage to disk.
    
    BOOL success = CGImageWriteToFile(result2,destinationPath);
    
    if (success) {
        NSLog(@"Picture correctly saved.");
    } else {
        NSLog(@"An error has occurred.");
    }
    
}



BOOL CGImageWriteToFile(CGImageRef image, NSString *path) {
    CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:path];
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL(url, kUTTypePNG, 1, NULL);
    if (!destination) {
        NSLog(@"Failed to create CGImageDestination for %@", path);
        return NO;
    }

    CGImageDestinationAddImage(destination, image, nil);

    if (!CGImageDestinationFinalize(destination)) {
        NSLog(@"Failed to write image to %@", path);
        CFRelease(destination);
        return NO;
    }

    CFRelease(destination);
    return YES;
}

@end
