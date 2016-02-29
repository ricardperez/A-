//
//  GraphView.swift
//  A*
//
//  Created by Ricard Perez del Campo on 26/02/16.
//  Copyright © 2016 Ricard Perez del Campo. All rights reserved.
//

import Cocoa

class GraphView: NSView {
    
    enum PathSearchState
    {
        case eOrigin
        case eDestination
        case eDone
    }
    
    enum MouseState
    {
        case eWaypoints
        case eCreatingWalls
        case eClearingWalls
    }
    
    var graph: GraphObjC
    var pathFinder: PathFinderObjC
    var positionConverter : PositionConverterObjC
    var pathSearchState : PathSearchState
    var originPosition : GraphPositionObjC
    var destinationPosition : GraphPositionObjC
    var path : NSMutableArray
    var mouseState : MouseState
    var mouseActive : Bool

    override init(frame frameRect: NSRect) {
        
        graph = GraphObjC(width: 25, height: 25)
        pathFinder = PathFinderObjC(graph: graph)
        positionConverter = PositionConverterObjC()
        pathSearchState = PathSearchState.eOrigin
        originPosition = GraphPositionObjC()
        destinationPosition = GraphPositionObjC()
        path = NSMutableArray()
        mouseState = MouseState.eWaypoints
        mouseActive = false
        
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
        mouseState = MouseState.eWaypoints
        mouseActive = false
        
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
                CGContextAddRect(context, getCellRect(waypoint.x(), y: waypoint.y(), width: cellsWidth, height: cellsHeight, scale: 0.65))
                CGContextDrawPath(context, .FillStroke)
            }
        }
        
        CGContextSetFillColorWithColor(context, NSColor.purpleColor().CGColor)
        if (pathSearchState != PathSearchState.eOrigin)
        {
            CGContextAddRect(context, getCellRect(originPosition.x(), y: originPosition.y(), width: cellsWidth, height: cellsHeight, scale: 1.0))
            CGContextDrawPath(context, .FillStroke)
        }
        
        if (pathSearchState == PathSearchState.eDone)
        {
            CGContextAddRect(context, getCellRect(destinationPosition.x(), y: destinationPosition.y(), width: cellsWidth, height: cellsHeight, scale: 1.0))
            CGContextDrawPath(context, .FillStroke)
        }
        
        positionConverter.setScreenSizeWithWidth(dirtyRect.size.width, height:dirtyRect.size.height)
    }
    
    func getCellRect(x: Int, y: Int, width: CGFloat, height: CGFloat, scale: CGFloat) -> CGRect
    {
        let offsetX : CGFloat = (CGFloat(x) * width + (width*(0.5 - scale/2.0)))
        let offsetY : CGFloat = (CGFloat(y) * height + (height*(0.5 - scale/2.0)))
        
        return CGRect(x: offsetX, y: offsetY, width: width*scale, height: height*scale);
    }
    
    override func mouseUp(theEvent: NSEvent)
    {
        if (mouseActive)
        {
            handleMouseEvent(theEvent);
        }
        
        mouseState = MouseState.eWaypoints
        mouseActive = false
        
        super.mouseUp(theEvent)
    }
    
    override func mouseDown(theEvent: NSEvent)
    {
        mouseActive = true
        if (theEvent.modifierFlags.contains(NSEventModifierFlags.CommandKeyMask))
        {
            let graphPosition: GraphPositionObjC = graphPositionFromMouseEvent(theEvent);
            if (graph.isPositionWalkableAtX(graphPosition.x(), y: graphPosition.y()))
            {
                mouseState = MouseState.eCreatingWalls
            } else
            {
                mouseState = MouseState.eClearingWalls
            }
        } else
        {
            mouseState = MouseState.eWaypoints
        }
        
        super.mouseDown(theEvent)
    }
    
    override func mouseMoved(theEvent: NSEvent)
    {
        if (mouseActive && ((mouseState == MouseState.eCreatingWalls) || (mouseState == MouseState.eClearingWalls)))
        {
            handleMouseEvent(theEvent)
        }
        
        super.mouseMoved(theEvent)
    }
    
    override func mouseDragged(theEvent: NSEvent)
    {
        if (mouseActive && ((mouseState == MouseState.eCreatingWalls) || (mouseState == MouseState.eClearingWalls)))
        {
            handleMouseEvent(theEvent)
        }
        super.mouseDragged(theEvent)
    }
    
    func handleMouseEvent(theEvent: NSEvent)
    {
        if (mouseState == MouseState.eWaypoints)
        {
            handleMouseEventWaypoints(theEvent)
        } else
        {
            if (theEvent.modifierFlags.contains(NSEventModifierFlags.CommandKeyMask))
            {
                handleMouseEventWalls(theEvent)
            }
            else
            {
                mouseActive = false
                mouseState = MouseState.eWaypoints
            }
        }
        
        setNeedsDisplayInRect(frame);
    }
    
    func handleMouseEventWaypoints(theEvent: NSEvent)
    {
        let graphPosition : GraphPositionObjC = graphPositionFromMouseEvent(theEvent);
        
        if ((pathSearchState == PathSearchState.eDestination))
        {
            destinationPosition = GraphPositionObjC(x: graphPosition.x(), y: graphPosition.y())
            path.removeAllObjects()
            if (!pathFinder.findPathWaypointsWithOrigin(originPosition, destination: destinationPosition, result: path))
            {
                path.removeAllObjects()
            }
            pathSearchState = PathSearchState.eDone
        } else
        {
            path.removeAllObjects()
            originPosition = GraphPositionObjC(x: graphPosition.x(), y: graphPosition.y())
            pathSearchState = PathSearchState.eDestination
        }
    }
    
    func handleMouseEventWalls(theEvent: NSEvent)
    {
        let graphPosition : GraphPositionObjC = graphPositionFromMouseEvent(theEvent);
        let wallExists : Bool = !(graph.isPositionWalkableAtX(graphPosition.x(), y: graphPosition.y()))
        var changesMade : Bool = false
        
        if ((mouseState == MouseState.eCreatingWalls) && !wallExists)
        {
            graph.markPositionAsNonWalkableAtX(graphPosition.x(), y: graphPosition.y())
            changesMade = true
        } else if ((mouseState == MouseState.eClearingWalls) && wallExists)
        {
            graph.unmarkPositionAsNonWalkableAtX(graphPosition.x(), y: graphPosition.y())
            changesMade = true
        }
        
        if (changesMade && (pathSearchState == PathSearchState.eDone))
        {
            path.removeAllObjects()
            if (!pathFinder.findPathWaypointsWithOrigin(originPosition, destination: destinationPosition, result: path))
            {
                path.removeAllObjects()
            }
        }
    }
    
    func graphPositionFromMouseEvent(theEvent: NSEvent) -> GraphPositionObjC
    {
        let position : NSPoint = convertPoint(theEvent.locationInWindow, fromView: nil);
        let screenPosition : ScreenPositionObjC = ScreenPositionObjC(x: position.x, y: position.y);
        let graphPosition : GraphPositionObjC = positionConverter.graphPositionFromScreenPosition(screenPosition);
        
        return graphPosition;
    }
    
}
