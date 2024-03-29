//
//  NSManagedObjectContext+SearchExtensions.m
//  ShootStudio
//
//  Created by Tom Fewster on 14/07/2011.
//  Copyright 2011 Tom Fewster. All rights reserved.
//

#import "NSManagedObjectContext+SearchExtensions.h"


@implementation NSManagedObjectContext (SearchExtensions)

// Convenience method to fetch the set of objects for a given Entity
// name in the context, optionally limiting by a predicate or by a predicate
// made from a format NSString and variable arguments.
//
- (NSSet *)fetchObjectsForEntityName:(NSString *)newEntityName withPredicate:(id)stringOrPredicate, ... {
	NSEntityDescription *entity = [NSEntityDescription entityForName:newEntityName inManagedObjectContext:self];

	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
    
	if (stringOrPredicate) {
		NSPredicate *predicate;
		if ([stringOrPredicate isKindOfClass:[NSString class]]) {
			va_list variadicArguments;
			va_start(variadicArguments, stringOrPredicate);
			predicate = [NSPredicate predicateWithFormat:stringOrPredicate arguments:variadicArguments];
			va_end(variadicArguments);
		} else {
			NSAssert2([stringOrPredicate isKindOfClass:[NSPredicate class]], @"Second parameter passed to %s is of unexpected class %s", sel_getName(_cmd), object_getClassName(stringOrPredicate));
			predicate = (NSPredicate *)stringOrPredicate;
		}
		[request setPredicate:predicate];
	}

	NSError *error = nil;
	NSArray *results = [self executeFetchRequest:request error:&error];
	if (error != nil) {
		[NSException raise:NSGenericException format:@"%@", [error description]];
	}
    
	return [NSSet setWithArray:results];
}

@end
