// RXVisitor.m
// Created by Rob Rix on 2010-04-14
// Copyright 2010 Monochrome Industries

#import "RXVisitor.h"


@implementation RXVisitor

-(NSString *)nameForObject:(id<RXVisitable>)object {
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}


-(SEL)selectorForVisitingObject:(id<RXVisitable>)object {
	return NSSelectorFromString([NSString stringWithFormat: @"visit%@:", [self nameForObject: object]]);
}


-(SEL)selectorForLeavingObject:(id<RXVisitable>)object {
	SEL selector = NSSelectorFromString([NSString stringWithFormat: @"leave%@:", [self nameForObject: object]]);
	if(![self respondsToSelector: selector])
		selector = NSSelectorFromString([NSString stringWithFormat: @"leave%@:withVisitedChildren:", [self nameForObject: object]]);
	return selector;
}


-(void)visitObject:(id<RXVisitable>)object {
	SEL selector = [self selectorForVisitingObject: object];
	if(selector && [self respondsToSelector: selector])
		[self performSelector: selector withObject: object];
}

-(id)leaveObject:(id<RXVisitable>)object withVisitedChildren:(NSArray *)children {
	SEL selector = [self selectorForLeavingObject: object];
	id result = nil;
	if(selector && [self respondsToSelector: selector])
		result = [self performSelector: selector withObject: object withObject: children];
	return result;
}

@end
