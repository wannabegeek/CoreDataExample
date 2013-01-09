//
//  TFExchange.h
//  CoreDataExample
//
//  Created by Tom Fewster on 09/01/2013.
//  Copyright (c) 2013 Tom Fewster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TFExchange : NSManagedObject

@property (nonatomic, retain) NSString * mnemonic;
@property (nonatomic, retain) NSSet *symbols;
@end

@interface TFExchange (CoreDataGeneratedAccessors)

- (void)addSymbolsObject:(NSManagedObject *)value;
- (void)removeSymbolsObject:(NSManagedObject *)value;
- (void)addSymbols:(NSSet *)values;
- (void)removeSymbols:(NSSet *)values;

@end
