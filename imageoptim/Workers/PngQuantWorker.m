//
//  PngQuant.m
//  ImageOptim
//
//  Created by seppo on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PngQuantWorker.h"

@implementation PngQuantWorker

-(id)init {
    if (self = [super init])
    {
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

-(void)run
{
	NSString *temp = [self tempPath];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSLog(@"%d",__LINE__);
	NSTask *task = [self taskForKey:@"PngQuant" bundleName:@"pngquant" arguments:[NSArray arrayWithObjects:@"-force", [[defaults objectForKey:@"PngQuant.Colors"] stringValue], nil]];
	NSLog(@"%d",__LINE__);
    if (!task) {
        return;
    }
    
	NSPipe *commandPipe = [NSPipe pipe];

	[task setStandardInput: [NSFileHandle fileHandleForReadingAtPath:file.filePath]];
	[[NSFileManager defaultManager] createFileAtPath:temp contents:nil attributes:nil];
	[task setStandardOutput: [NSFileHandle fileHandleForWritingAtPath:temp]];
	[task setStandardError: commandPipe];

	[self launchTask:task];

	//[self parseLinesFromHandle:commandHandle];

	[task waitUntilExit];

	if (![task terminationStatus])
	{
		NSUInteger fileSizeOptimized = [File fileByteSize:temp];
		if (fileSizeOptimized)
		{
			[file setFilePathOptimized:temp	size:fileSizeOptimized toolName:[self className]];			
		}
	}
	else NSLog(@"pngquant failed");
}

-(BOOL)makesNonOptimizingModifications
{
	return YES;
}


@end
