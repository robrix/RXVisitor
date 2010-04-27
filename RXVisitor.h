// RXVisitor.h
// Created by Rob Rix on 2010-04-14
// Copyright 2010 Monochrome Industries

#import <Foundation/Foundation.h>

@protocol RXVisitor;

@protocol RXVisitable <NSObject>

-(id)acceptVisitor:(id<RXVisitor>)visitor;

@end


@protocol RXVisitor <NSObject>

-(void)visitObject:(id<RXVisitable>)object;
-(id)leaveObject:(id<RXVisitable>)object withVisitedChildren:(id)children;

@end


@interface RXVisitor : NSObject <RXVisitor>

-(NSString *)nameForObject:(id<RXVisitable>)object;

-(SEL)selectorForVisitingObject:(id<RXVisitable>)object;
-(SEL)selectorForLeavingObject:(id<RXVisitable>)object;

@end
