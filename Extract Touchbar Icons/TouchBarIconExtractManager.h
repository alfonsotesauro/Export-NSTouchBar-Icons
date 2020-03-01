//
//  TouchBarIconExtractManager.h
//  Extract Touchbar Icons
//
//  Created by Alfonso Maria Tesauro on 01/03/2020.
//  Copyright © 2020 Alfonso Maria Tesauro. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface TouchBarIconExtractManager : NSObject

@property (strong) NSString *touchBarImageName;

+ (void)writeImageToDisk:(NSImage *)icon withPath:(NSString *)destinationPath;

@end

NS_ASSUME_NONNULL_END
