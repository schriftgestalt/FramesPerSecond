//
//  FramesPerSecond.m
//  FramesPerSecond
//
//  Created by Georg Seifert on 22.12.17.
// Copyright © 2017 Georg Seifert. All rights reserved.
//

#import "FramesPerSecond.h"
#import <GlyphsCore/GlyphsCore.h>
#if GLYPHS_VERSION >= 4
#import <GlyphsApp/GlyphsApp.h>
#endif

static NSString *fpsLabel;

@implementation FramesPerSecond {
	NSTimeInterval _fpsMilisec;
	CGFloat _fps1;
	CGFloat _fps2;
}

@synthesize controller = _controller;

+ (void)initialize {
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	fpsLabel = NSLocalizedStringFromTableInBundle(@"fps: %03d", nil, bundle, @"fpsLabel");
}

- (void)loadPlugin {
	// Is called when the plugin is loaded.
}

- (NSUInteger)interfaceVersion {
	// Distinguishes the API version the plugin was built for. Return 1.
	return 1;
}

- (NSString *)title {
	// This is the name as it appears in the menu in combination with 'Show'.
	// E.g. 'return @"Nodes";' will make the menu item read "Show Nodes".
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	return NSLocalizedStringFromTableInBundle(@"Frames per Second", nil, bundle, @"plugin title");
}

- (NSString *)keyEquivalent {
	// The key for the keyboard shortcut. Set modifier keys in modifierMask further below.
	// Pretty tricky to find a shortcut that is not taken yet, so be careful.
	// If you are not sure, use 'return nil;'. Users can set their own shortcuts in System Prefs.
	return nil;
}

- (NSEventModifierFlags)modifierMask {
	// Use any combination of these to determine the modifier keys for your default shortcut:
	// return NSShiftKeyMask | NSControlKeyMask | NSCommandKeyMask | NSAlternateKeyMask;
	// Or:
	// return 0;
	// ... if you do not want to set a shortcut.
	return 0;
}

- (void)drawForegroundWithOptions:(NSDictionary*)options {
	CGFloat fps = 1 / ([NSDate timeIntervalSinceReferenceDate] - _fpsMilisec);
	_fpsMilisec = [NSDate timeIntervalSinceReferenceDate];
	CGFloat smoothedFPS = MAX(MAX(fps, _fps1), _fps2);
	_fps2 = _fps1;
	_fps1 = fps;
	NSRect visibleRect = [_controller.graphicView userVisibleRect];
	NSScrollView *scrollview = [_controller.frameView enclosingScrollView];
	if ([scrollview scrollerStyle] == NSScrollerStyleLegacy) {
		visibleRect.origin.y += 11;
	}
	visibleRect = NSInsetRect(visibleRect, 10, 10);
	NSColor* color;
	if (smoothedFPS > 22) {
		color = [NSColor systemGreenColor];
	}
	else if (smoothedFPS > 14) {
		color = [NSColor orangeColor];
	}
	else {
		color = [NSColor redColor];
	}
	NSString *fpsString = [NSString stringWithFormat:fpsLabel, (int)round(smoothedFPS)];
	CGFloat fontSize = [NSString fontSizeForHandleSize:-1];
	[fpsString drawAtPoint:visibleRect.origin color:color alignment:GSBottomLeft fontSize:fontSize + 2];
}

- (BOOL)needsExtraMainOutlineDrawingForInactiveLayer:(GSLayer*)Layer {
	// Return NO to disable the black outline. Otherwise remove the method.
	return YES;
}

@end
