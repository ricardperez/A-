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
@interface ScreenPositionObjC()
{
    AStar::ScreenPosition _screenPosition;
}

- (AStar::ScreenPosition)screenPosition;

@end

@implementation ScreenPositionObjC

- (instancetype)initWithX:(CGFloat)x y:(CGFloat)y
{
    if (self = [super init])
    {
        _screenPosition.set((float)x, (float)y);
    }
    
    return self;
}

- (CGFloat)x
{
    return (CGFloat)_screenPosition.x;
}

- (CGFloat)y
{
    return (CGFloat)_screenPosition.y;
}

- (AStar::ScreenPosition)screenPosition
{
    return _screenPosition;
}

@end

#pragma mark - GraphPositionObjC
@interface GraphPositionObjC()
{
    AStar::GraphPosition _graphPosition;
}

- (AStar::GraphPosition)graphPosition;

@end

@implementation GraphPositionObjC

- (instancetype)initWithX:(NSInteger)x y:(NSInteger)y
{
    if (self = [super init])
    {
        _graphPosition.set((int)x, (int)y);
    }
    
    return self;
}

- (NSInteger)x
{
    return (NSInteger)_graphPosition.x;
}

- (NSInteger)y
{
    return (NSInteger)_graphPosition.y;
}

- (AStar::GraphPosition)graphPosition
{
    return _graphPosition;
}

@end

#pragma mark - GraphObjC
@interface GraphObjC()
{
    AStar::Graph* _graph;
}

- (AStar::Graph*)graph;

@end

@implementation GraphObjC

- (instancetype)initWithWidth:(NSInteger)width height:(NSInteger)height
{
    if (self = [super init])
    {
        _graph = new AStar::Graph((int)width, (int)height);
    }
    
    return self;
}

- (void)dealloc
{
    delete _graph;
}

- (NSInteger)width
{
    return _graph->getWidth();
}

- (NSInteger)height
{
    return _graph->getHeight();
}

- (BOOL)isPositionWalkableAtX:(NSInteger)x y:(NSInteger)y;
{
    return _graph->isPositionWalkable((int)x, (int)y);
}

- (void)markPositionAsNonWalkableAtX:(NSInteger)x y:(NSInteger)y;
{
    _graph->markPositionAsNonWalkable((int)x, (int)y);
}

- (void)unmarkPositionAsNonWalkableAtX:(NSInteger)x y:(NSInteger)y;
{
    _graph->unmarkPositionAsNonWalkable((int)x, (int)y);
}

- (BOOL)isPositionValidAtX:(NSInteger)x y:(NSInteger)y;
{
    return _graph->isPositionValid((int)x, (int)y);
}

- (AStar::Graph*)graph
{
    return _graph;
}

@end

#pragma mark - PathFinderObjC
@interface PathFinderObjC()
{
    AStar::PathFinder* _pathFinder;
}

@end

@implementation PathFinderObjC

- (instancetype)initWithGraph:(GraphObjC*)graphObjC
{
    if (self = [super init])
    {
        _pathFinder = new AStar::PathFinder(*([graphObjC graph]));
    }
    
    return self;
}

- (void)dealloc
{
    delete _pathFinder;
}

- (BOOL)findPathWaypointsWithOrigin:(GraphPositionObjC*)origin destination:(GraphPositionObjC*)destination result:(NSMutableArray*)outWaypoints
{
    std::vector<AStar::GraphPosition> realOutWaypoints;
    bool result = _pathFinder->findPathWaypoints(origin.graphPosition, destination.graphPosition, realOutWaypoints);
    
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
@interface PositionConverterObjC()
{
    AStar::PositionConverter _positionConverter;
}

@end

@implementation PositionConverterObjC

- (void)setGraphSizeWithWidth:(NSInteger)width height:(NSInteger)height
{
    _positionConverter.setGraphSize((int)width, (int)height);
}

- (void)setScreenSizeWithWidth:(CGFloat)width height:(CGFloat)height
{
    _positionConverter.setScreenSize((float)width, (float)height);
}

- (GraphPositionObjC*)graphPositionFromScreenPosition:(ScreenPositionObjC*)screenPosition
{
    AStar::GraphPosition pos = _positionConverter.graphPositionFromScreenPosition([screenPosition screenPosition]);
    GraphPositionObjC* result = [[GraphPositionObjC alloc] initWithX:pos.x y:pos.y];
    return result;
}

- (ScreenPositionObjC*)screenPositionFromGraphPosition:(GraphPositionObjC*)graphPosition
{
    AStar::ScreenPosition pos = _positionConverter.screenPositionFromGraphPosition([graphPosition graphPosition]);
    return [[ScreenPositionObjC alloc] initWithX:pos.x y:pos.y];
}

@end
