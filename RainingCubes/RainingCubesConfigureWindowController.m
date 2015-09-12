//
//  RainingCubesConfigureWindowController.m
//  RainingCubes
//
//  Created by Nick Zitzmann on 9/9/15.
//  Copyright © 2015 Nick Zitzmann. All rights reserved.
//

#import "RainingCubesConfigureWindowController.h"
@import ScreenSaver;

@interface RainingCubesConfigureWindowController ()

@end

@implementation RainingCubesConfigureWindowController

- (void)windowDidLoad
{
	ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName:[[NSBundle bundleForClass:self.class] bundleIdentifier]];
	NSUInteger i = 2UL;
	
	[super windowDidLoad];
	
	[self.FSAAPopUp removeAllItems];
	[self.FSAAPopUp addItemWithTitle:NSLocalizedStringFromTableInBundle(@"None", @"RainingCubes", [NSBundle bundleForClass:self.class], @"No FSAA")];
	self.FSAAPopUp.lastItem.tag = 1L;
	for (i = 2UL ; i <= 10UL ; i++)
	{
		if ([self.device supportsTextureSampleCount:i])
		{
			[self.FSAAPopUp addItemWithTitle:[NSString stringWithFormat:@"%ldx", (unsigned long)i]];
			self.FSAAPopUp.lastItem.tag = i;
		}
	}
	[self.FSAAPopUp selectItemWithTag:[defaults integerForKey:@"RCFSAASamples"]];
	
	self.numberOfCubesSlider.integerValue = [defaults integerForKey:@"RCNumberOfCubes"];
	self.numberOfCubesTxt.integerValue = self.numberOfCubesSlider.integerValue;
	self.GPUTxt.stringValue = self.device.name;
	self.preferDiscreteGPUButton.state = [defaults boolForKey:@"RCPreferDiscreteGPU"] ? NSOnState : NSOffState;
	self.mainScreenOnlyButton.state = [defaults boolForKey:@"RCMainScreenOnly"] ? NSOnState : NSOffState;
}


- (IBAction)numberOfCubesAction:(id)sender
{
	ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName:[[NSBundle bundleForClass:self.class] bundleIdentifier]];
	
	[defaults setInteger:[sender integerValue] forKey:@"RCNumberOfCubes"];
	self.numberOfCubesTxt.integerValue = self.numberOfCubesSlider.integerValue;
}


- (IBAction)FSAAAction:(id)sender
{
	ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName:[[NSBundle bundleForClass:self.class] bundleIdentifier]];
	
	[defaults setInteger:[sender selectedTag] forKey:@"RCFSAASamples"];
}


- (IBAction)preferDiscreteGPUAction:(id)sender
{
	ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName:[[NSBundle bundleForClass:self.class] bundleIdentifier]];
	
	[defaults setBool:[sender state] == NSOnState forKey:@"RCPreferDiscreteGPU"];
}


- (IBAction)mainScreenOnlyAction:(id)sender
{
	ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName:[[NSBundle bundleForClass:self.class] bundleIdentifier]];
	
	[defaults setBool:[sender state] == NSOnState forKey:@"RCMainScreenOnly"];
}


- (IBAction)okayAction:(id)sender
{
	ScreenSaverDefaults *defaults = [ScreenSaverDefaults defaultsForModuleWithName:[[NSBundle bundleForClass:self.class] bundleIdentifier]];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"RCUserDefaultsChangedNotification" object:nil];
	[defaults synchronize];
	[NSApp endSheet:self.window];
}

@end
