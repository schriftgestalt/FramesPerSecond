//
//  FramesPerSecond.h
//  FramesPerSecond
//
//  Created by Georg Seifert on 22.12.17.
//Copyright © 2017 Georg Seifert. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <GlyphsCore/GlyphsCore.h>
#if GLYPHS_VERSION >= 4
#import <GlyphsApp/GlyphsReporterProtocol.h>
#else
#import <GlyphsCore/GlyphsReporterProtocol.h>
#endif


@interface FramesPerSecond : NSObject <GlyphsReporter>

@end
