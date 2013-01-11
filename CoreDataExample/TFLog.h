//
//  TFLog.h
//
//  Created by Tom Fewster on 08/06/2010.
//

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
#	import <UIKit/UIKit.h>
#else
#	import <Cocoa/Cocoa.h>
#endif

#ifdef DEBUG
#	define DebugLog(format, ...) NSLog(@"<Debug>: " format @" [" __FILE__ @":%i]", ##__VA_ARGS__, __LINE__)
#	ifdef TRACE_LOG
#		define DebugTrace(format, ...) NSLog(@"<Trace>: " format @" [" __FILE__ @":%i]", ##__VA_ARGS__, __LINE__)
#	else
#		define DebugTrace(format, ...)
#	endif
#	define InfoLog(format, ...) NSLog(@"<Info> " format @" [" __FILE__ @":%i]", ##__VA_ARGS__, __LINE__)
#	define WarningLog(format, ...) NSLog(@"<Warning> " format @" [" __FILE__ @":%i]", ##__VA_ARGS__, __LINE__)
#	define ErrorLog(format, ...) NSLog(@"<Error> " format @" [" __FILE__ @":%i]", ##__VA_ARGS__, __LINE__)
#else
#	define DebugLog(format, ...)
#	define DebugTrace(format, ...)
#	define InfoLog(format, ...) NSLog(@"<Info>: " format, ##__VA_ARGS__)
#	define WarningLog(format, ...) NSLog(@"<Warning>: " format, ##__VA_ARGS__)
#	define ErrorLog(format, ...) NSLog(@"<Error>: " format, ##__VA_ARGS__)
#endif

void initialiseLogger(void);
