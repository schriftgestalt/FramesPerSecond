//
//  FramesPerSecond.m
//  FramesPerSecond
//
//  Created by Georg Seifert on 22.12.17.
//Copyright © 2017 Georg Seifert. All rights reserved.
//

#import "FramesPerSecond.h"
#import <GlyphsCore/GlyphsFilterProtocol.h>
#import <GlyphsCore/NSString+BadgeDrawing.h>

@interface NSString ()
- (NSRect)drawAtPoint:(NSPoint)DrawPoint color:(NSColor *)TextColor alignment:(GSAlignment)Alignment;
@end

@implementation FramesPerSecond {
	NSTimeInterval _fpsMilisec;
}

- (id) init {
	self = [super init];
	if (self) {
		// do stuff
	}
	return self;
}

- (void) loadPlugin {
	// Is called when the plugin is loaded.
}


- (NSUInteger) interfaceVersion {
	// Distinguishes the API verison the plugin was built for. Return 1.
	return 1;
}

- (NSString*) title {
	// This is the name as it appears in the menu in combination with 'Show'.
	// E.g. 'return @"Nodes";' will make the menu item read "Show Nodes".
	return @"Frames per Second";
}

- (NSString*) keyEquivalent {
	// The key for the keyboard shortcut. Set modifier keys in modifierMask further below.
	// Pretty tricky to find a shortcut that is not taken yet, so be careful.
	// If you are not sure, use 'return nil;'. Users can set their own shortcuts in System Prefs.
	return nil;
}

- (int) modifierMask {
	// Use any combination of these to determine the modifier keys for your default shortcut:
	// return NSShiftKeyMask | NSControlKeyMask | NSCommandKeyMask | NSAlternateKeyMask;
	// Or:
	// return 0;
	// ... if you do not want to set a shortcut.
	return 0;
}

- (void) drawForegroundForLayer:(GSLayer*)Layer {}

- (void)drawForegroundWithOptions:(NSDictionary *)options {
	CGFloat fpsFramesPerSecond = 1 / ([NSDate timeIntervalSinceReferenceDate] - _fpsMilisec);
	_fpsMilisec = [NSDate timeIntervalSinceReferenceDate];
	
	NSRect VisibleRect = [editViewController.graphicView visibleRect];
	VisibleRect = NSInsetRect(VisibleRect, 2, 2);
	NSColor* color;
	if (fpsFramesPerSecond > 22) {
		color = [NSColor greenColor];
	}
	else if (fpsFramesPerSecond > 14) {
		color = [NSColor greenColor];
	}
	else {
		color = [NSColor redColor];
	}
	[[NSString stringWithFormat:@"fps: %.1f", fpsFramesPerSecond] drawAtPoint:VisibleRect.origin color:color alignment:GSBottomLeft];
}

- (void) drawBackgroundForLayer:(GSLayer*)Layer {}

- (void) drawBackgroundForInactiveLayer:(GSLayer*)Layer {}

- (BOOL) needsExtraMainOutlineDrawingForInactiveLayer:(GSLayer*)Layer {
	// Return NO to disable the black outline. Otherwise remove the method.
	return YES;
}

- (void) setController:(NSViewController <GSGlyphEditViewControllerProtocol>*)Controller {
	// Use [self controller]; as object for the current view controller.
	editViewController = Controller;
}

@end
