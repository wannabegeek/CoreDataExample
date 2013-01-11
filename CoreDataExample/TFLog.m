//
//  TFLog.m
//
//  Created by Tom Fewster on 06/04/2012.
//

#import "TFLog.h"
#include <assert.h>
#include <stdbool.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/sysctl.h>

void initialiseLogger(void) {
#ifdef DEBUG
	int                 junk;
	int                 mib[4];
	struct kinfo_proc   info;
	size_t              size;

	// Initialize the flags so that, if sysctl fails for some bizarre 
	// reason, we get a predictable result.

	info.kp_proc.p_flag = 0;

	// Initialize mib, which tells sysctl the info we want, in this case
	// we're looking for information about a specific process ID.

	mib[0] = CTL_KERN;
	mib[1] = KERN_PROC;
	mib[2] = KERN_PROC_PID;
	mib[3] = getpid();

	// Call sysctl.

	size = sizeof(info);
	junk = sysctl(mib, sizeof(mib) / sizeof(*mib), &info, &size, NULL, 0);
	assert(junk == 0);

	// We're being debugged if the P_TRACED flag is set.
	// so, if we are being debugged the out put will go to Xcode's console
	// other wise redirect it to a file in our documents directory
	if (!((info.kp_proc.p_flag & P_TRACED) != 0)) {
		// find our applications documents directory
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		
		// create a unique files name keyed off the date
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
		NSString *fileName = [NSString stringWithFormat:@"%@.log", [dateFormatter stringFromDate:[NSDate date]]];
		NSString *logFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
		
		// redirect stderr to our new file
		freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
	}
#endif
}
