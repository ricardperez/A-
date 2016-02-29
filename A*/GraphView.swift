//
//  GraphView.swift
//  A*
//
//  Created by Ricard Perez del Campo on 26/02/16.
//  Copyright © 2016 Ricard Perez del Campo. All rights reserved.
//

import Cocoa

class GraphView: NSView {
    
    var graph: GraphObjC
    var pathFinder: PathFinderObjC
    var positionConverter : PositionConverterObjC
    
    enum PathSearchState
    {
        case eOrigin
        case eDestination
        case eDone
    }
    
    var pathSearchState : PathSearchState
    var originPosition : GraphPositionObjC
    var destinationPosition : GraphPositionObjC
    var path : NSMutableArray

    override init(frame frameRect: NSRect) {
        
        graph = GraphObjC(width: 25, height: 25)
        pathFinder = PathFinderObjC(graph: graph)
        positionConverter = PositionConverterObjC()
        pathSearchState = PathSearchState.eOrigin
        originPosition = GraphPositionObjC()
        destinationPosition = GraphPositionObjC()
        path = NSMutableArray()
        
        super.init(frame: frameRect);
        
        positionConverter.setGraphSizeWithWidth(graph.width(), height:graph.height())
        positionConverter.setScreenSizeWithWidth(frame.size.width, height:frame.size.height)
    }

    required init?(coder: NSCoder) {
        
        graph = GraphObjC(width: 25, height: 25)
        pathFinder = PathFinderObjC(graph: graph)
        positionConverter = PositionConverterObjC()
        pathSearchState = PathSearchState.eOrigin
        originPosition = GraphPositionObjC()
        destinationPosition = GraphPositionObjC()
        path = NSMutableArray()
        
        super.init(coder: coder)
        
        positionConverter.setGraphSizeWithWidth(graph.width(), height:graph.height())
        positionConverter.setScreenSizeWithWidth(frame.size.width, height:frame.size.height)
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        let context = NSGraphicsContext.currentContext()?.CGContext
        CGContextClearRect(context, dirtyRect)
        CGContextSetFillColorWithColor(context, NSColor.whiteColor().CGColor)
        CGContextFillRect(context, dirtyRect)
        
        CGContextSetStrokeColorWithColor(context, NSColor.redColor().CGColor)
        
        let cellsWidth : CGFloat = (dirtyRect.size.width / CGFloat(graph.width()))
        let cellsHeight : CGFloat = (dirtyRect.size.height / CGFloat(graph.height()))
        
        for (var i=0; i<graph.width(); ++i)
        {
            CGContextMoveToPoint(context, CGFloat(i)*cellsWidth, 0);
            CGContextAddLineToPoint(context, CGFloat(i)*cellsWidth, dirtyRect.size.height)
            CGContextStrokePath(context)
        }
        
        for (var j=0; j<graph.height(); ++j)
        {
            CGContextMoveToPoint(context, 0, CGFloat(j)*cellsHeight);
            CGContextAddLineToPoint(context, dirtyRect.size.width, CGFloat(j)*cellsHeight)
            CGContextStrokePath(context)
        }
        
        CGContextSetFillColorWithColor(context, NSColor.greenColor().CGColor)
        for (var i=0; i<graph.width(); ++i)
        {
            for (var j=0; j<graph.height(); ++j)
            {
                if (!graph.isPositionWalkableAtX(i, y:j))
                {
                    CGContextAddRect(context, CGRectMake(CGFloat(i)*cellsWidth, CGFloat(j)*cellsHeight, cellsWidth, cellsHeight));
                    CGContextDrawPath(context, .FillStroke)
                }
            }
        }
        
        CGContextSetFillColorWithColor(context, NSColor.blackColor().CGColor)
        if (pathSearchState == PathSearchState.eDone)
        {
            for waypointObj in path
            {
                let waypoint : GraphPositionObjC = waypointObj as! GraphPositionObjC
                CGContextAddRect(context, CGRectMake(CGFloat(waypoint.x())*cellsWidth, CGFloat(waypoint.y())*cellsHeight, cellsWidth, cellsHeight))
                CGContextDrawPath(context, .FillStroke)
            }
        }
        
        CGContextSetFillColorWithColor(context, NSColor.purpleColor().CGColor)
        if (pathSearchState != PathSearchState.eOrigin)
        {
            CGContextAddRect(context, CGRectMake(CGFloat(originPosition.x())*cellsWidth, CGFloat(originPosition.y())*cellsHeight, cellsWidth, cellsHeight))
            CGContextDrawPath(context, .FillStroke)
        }
        
        if (pathSearchState == PathSearchState.eDone)
        {
            CGContextAddRect(context, CGRectMake(CGFloat(destinationPosition.x())*cellsWidth, CGFloat(destinationPosition.y())*cellsHeight, cellsWidth, cellsHeight))
            CGContextDrawPath(context, .FillStroke)
        }
        
        positionConverter.setScreenSizeWithWidth(dirtyRect.size.width, height:dirtyRect.size.height)
    }
    
    override func mouseUp(theEvent: NSEvent) {
        let position : NSPoint = convertPoint(theEvent.locationInWindow, fromView: nil);
        let screenPosition : ScreenPositionObjC = ScreenPositionObjC(x: position.x, y: position.y);
        let graphPosition : GraphPositionObjC = positionConverter.graphPositionFromScreenPosition(screenPosition);
        
        if (theEvent.modifierFlags.contains(NSEventModifierFlags.CommandKeyMask))
        {
            if (graph.isPositionWalkableAtX(graphPosition.x(), y: graphPosition.y()))
            {
                graph.markPositionAsNonWalkableAtX(graphPosition.x(), y: graphPosition.y())
            } else
            {
                graph.unmarkPositionAsNonWalkableAtX(graphPosition.x(), y: graphPosition.y())
            }
        } else
        {
            if ((pathSearchState == PathSearchState.eDestination))
            {
                destinationPosition = GraphPositionObjC(x: graphPosition.x(), y: graphPosition.y())
                path.removeAllObjects()
                pathFinder.findPathWaypointsWithOrigin(originPosition, destination: destinationPosition, result: path)
                pathSearchState = PathSearchState.eDone
            } else
            {
                path.removeAllObjects()
                originPosition = GraphPositionObjC(x: graphPosition.x(), y: graphPosition.y())
                pathSearchState = PathSearchState.eDestination
            }
        }
        
        setNeedsDisplayInRect(frame)
    }
    
}
