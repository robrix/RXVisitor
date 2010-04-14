// RXVisitorTests.m
// Created by Rob Rix on 2010-04-14
// Copyright 2010 Monochrome Industries

#import "RXAssertions.h"
#import "RXVisitor.h"

@interface RXTestVisitor : RXVisitor
@end

@implementation RXTestVisitor

-(NSString *)nameForObject:(id<RXVisitable>)object {
	return [object isKindOfClass: [NSArray class]] ? @"Branch" : @"Leaf";
}


-(id)leaveBranch:(id)branch withVisitedChildren:(id)children {
	return [NSString stringWithFormat: @"(%@)", [children componentsJoinedByString: @" "]];
}

-(id)leaveLeaf:(id)leaf {
	return [leaf description];
}

@end


@interface RXVisitorTests : SenTestCase {
	RXTestVisitor *visitor;
}
@end

@implementation RXVisitorTests

-(void)setUp {
	visitor = [[RXTestVisitor alloc] init];
}

-(void)tearDown {
	[visitor release];
}


-(void)testVisitsObjectsWithNamedMethods {
	RXAssertEquals(([[NSArray arrayWithObjects: @"a", @"b", [NSArray arrayWithObject: @"c"], @"d", [NSArray arrayWithObject: [NSArray arrayWithObject: @"e"]], nil] acceptVisitor: visitor]), @"(a b (c) d ((e)))");
}

@end


@interface NSObject (RXVisitorTests) <RXVisitable>
@end

@implementation NSObject (RXVisitorTests)

-(id)acceptVisitor:(id<RXVisitor>)visitor {
	[visitor visitObject: self];
	return [visitor leaveObject: self withVisitedChildren: nil];
}

@end


@interface NSArray (RXVisitorTests) <RXVisitable>
@end

@implementation NSArray (RXVisitorTests)

-(id)acceptVisitor:(id<RXVisitor>)visitor {
	[visitor visitObject: self];
	NSMutableArray *children = [[NSMutableArray alloc] init];
	for(id<RXVisitable> child in self) {
		id result = [child acceptVisitor: visitor];
		if(result) [children addObject: result];
	}
	return [visitor leaveObject: self withVisitedChildren: children];
}

@end
