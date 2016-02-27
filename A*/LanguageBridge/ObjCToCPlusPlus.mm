//
//  ObjCToCPlusPlus.m
//  A*
//
//  Created by Ricard Perez del Campo on 27/02/16.
//  Copyright © 2016 Ricard Perez del Campo. All rights reserved.
//

#import "ObjCToCPlusPlus.h"

#import "Position.hpp"
#import "Graph.hpp"
#import "PathFinder.hpp"
#import "PositionConverter.hpp"

#include <iostream>

#pragma mark - ScreenPositionObjC
@interface ScreenPositionObjC(Wrapped)

- (AStar::ScreenPosition)screenPosition;

@end

@implementation ScreenPositionObjC

AStar::ScreenPosition screenPosition;

- (instancetype)initWithX:(CGFloat)x y:(CGFloat)y
{
    if (self = [super init])
    {
        screenPosition.set((float)x, (float)y);
    }
    
    return self;
}

- (CGFloat)x
{
    return (CGFloat)screenPosition.x;
}

- (CGFloat)y
{
    return (CGFloat)screenPosition.y;
}

- (AStar::ScreenPosition)screenPosition
{
    return screenPosition;
}

@end

#pragma mark - GraphPositionObjC
@interface GraphPositionObjC(Wrapped)

- (AStar::GraphPosition)graphPosition;

@end

@implementation GraphPositionObjC

AStar::GraphPosition graphPosition;

- (instancetype)initWithX:(NSInteger)x y:(NSInteger)y
{
    if (self = [super init])
    {
        graphPosition.set((int)x, (int)y);
    }
    
    return self;
}

- (NSInteger)x
{
    return (NSInteger)graphPosition.x;
}

- (NSInteger)y
{
    return (NSInteger)graphPosition.y;
}

- (AStar::GraphPosition)graphPosition
{
    return graphPosition;
}

@end

#pragma mark - GraphObjC
@interface GraphObjC()

- (AStar::Graph*)graph;

@end

@implementation GraphObjC

AStar::Graph* graph;

- (instancetype)initWithWidth:(NSInteger)width height:(NSInteger)height
{
    if (self = [super init])
    {
        graph = new AStar::Graph((int)width, (int)height);
    }
    
    return self;
}

- (void)dealloc
{
    delete graph;
}

- (NSInteger)width
{
    return graph->getWidth();
}

- (NSInteger)height
{
    return graph->getHeight();
}

- (BOOL)isPositionWalkableAtX:(NSInteger)x y:(NSInteger)y;
{
    return graph->isPositionWalkable((int)x, (int)y);
}

- (void)markPositionAsNonWalkableAtX:(NSInteger)x y:(NSInteger)y;
{
    graph->markPositionAsNonWalkable((int)x, (int)y);
}

- (void)unmarkPositionAsNonWalkableAtX:(NSInteger)x y:(NSInteger)y;
{
    graph->unmarkPositionAsNonWalkable((int)x, (int)y);
}

- (BOOL)isPositionValidAtX:(NSInteger)x y:(NSInteger)y;
{
    return graph->isPositionValid((int)x, (int)y);
}

- (AStar::Graph*)graph
{
    return graph;
}

@end

#pragma mark - PathFinderObjC
@implementation PathFinderObjC

AStar::PathFinder* pathFinder;

- (instancetype)initWithGraph:(GraphObjC*)graphObjC
{
    if (self = [super init])
    {
        pathFinder = new AStar::PathFinder(*([graphObjC graph]));
    }
    
    return self;
}

- (void)dealloc
{
    delete pathFinder;
}

- (BOOL)findPathWaypointsWithOrigin:(GraphPositionObjC*)origin destination:(GraphPositionObjC*)destination result:(NSMutableArray*)outWaypoints
{
    std::vector<AStar::GraphPosition> realOutWaypoints;
    bool result = pathFinder->findPathWaypoints(origin.graphPosition, destination.graphPosition, realOutWaypoints);
    
    if (result)
    {
        for (auto waypoint : realOutWaypoints)
        {
            [outWaypoints addObject:[[GraphPositionObjC alloc] initWithX:waypoint.x y:waypoint.y]];
        }
        
        return YES;
    }
    
    return NO;
}

@end


#pragma mark - PositionConverterObjC
@implementation PositionConverterObjC

AStar::PositionConverter positionConverter;

- (void)setGraphSizeWithWidth:(NSInteger)width height:(NSInteger)height
{
    positionConverter.setGraphSize((int)width, (int)height);
}

- (void)setScreenSizeWithWidth:(CGFloat)width height:(CGFloat)height
{
    positionConverter.setScreenSize((float)width, (float)height);
}

- (GraphPositionObjC*)graphPositionFromScreenPosition:(ScreenPositionObjC*)screenPosition
{
    AStar::GraphPosition pos = positionConverter.graphPositionFromScreenPosition([screenPosition screenPosition]);
    GraphPositionObjC* result = [[GraphPositionObjC alloc] initWithX:pos.x y:pos.y];
    return result;
}

- (ScreenPositionObjC*)screenPositionFromGraphPosition:(GraphPositionObjC*)graphPosition
{
    AStar::ScreenPosition pos = positionConverter.screenPositionFromGraphPosition([graphPosition graphPosition]);
    return [[ScreenPositionObjC alloc] initWithX:pos.x y:pos.y];
}

@end
