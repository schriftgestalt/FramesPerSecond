//
//  FramesPerSecond.m
//  FramesPerSecond
//
//  Created by Georg Seifert on 22.12.17.
// Copyright © 2017 Georg Seifert. All rights reserved.
//

#import "FramesPerSecond.h"
#import <GlyphsCore/GlyphsFilterProtocol.h>
#import <GlyphsCore/NSString+BadgeDrawing.h>
#import <GlyphsCore/GSGeometrieHelper.h>


@implementation FramesPerSecond {
	NSTimeInterval _fpsMilisec;
	CGFloat _fps1;
	CGFloat _fps2;
}

@synthesize controller = _controller;

- (void)loadPlugin {
	// Is called when the plugin is loaded.
}

- (NSUInteger)interfaceVersion {
	// Distinguishes the API verison the plugin was built for. Return 1.
	return 1;
}

- (NSString *)title {
	// This is the name as it appears in the menu in combination with 'Show'.
	// E.g. 'return @"Nodes";' will make the menu item read "Show Nodes".
	return @"Frames per Second";
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
	NSRect visibleRect = [_controller.graphicView visibleRect];
	NSScrollView *scrollview = [_controller.frameView enclosingScrollView];
	if ([scrollview scrollerStyle] == NSScrollerStyleLegacy) {
		visibleRect.origin.y += 11;
	}
	visibleRect = NSInsetRect(visibleRect, 2, 2);
	NSColor* color;
	if (smoothedFPS > 22) {
		color = [NSColor greenColor];
	}
	else if (smoothedFPS > 14) {
		color = [NSColor orangeColor];
	}
	else {
		color = [NSColor redColor];
	}
	NSString *fpsString = [NSString stringWithFormat:@"fps: %03d", (int)round(smoothedFPS)];
	[fpsString drawAtPoint:visibleRect.origin color:color alignment:GSBottomLeft handleSize:-1];
}

- (BOOL)needsExtraMainOutlineDrawingForInactiveLayer:(GSLayer*)Layer {
	// Return NO to disable the black outline. Otherwise remove the method.
	return YES;
}

@end
