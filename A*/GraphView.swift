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
    var positionConverter : PositionConverterObjC;

    override init(frame frameRect: NSRect) {
        
        self.graph = GraphObjC(width: 25, height: 25)
        self.pathFinder = PathFinderObjC(graph: graph)
        self.positionConverter = PositionConverterObjC();
        
        super.init(frame: frameRect);
        
        self.positionConverter.setGraphSizeWithWidth(self.graph.width(), height:self.graph.height())
        self.positionConverter.setScreenSizeWithWidth(frame.size.width, height:frame.size.height)
    }

    required init?(coder: NSCoder) {
        
        self.graph = GraphObjC(width: 25, height: 25)
        self.pathFinder = PathFinderObjC(graph: self.graph)
        
        self.positionConverter = PositionConverterObjC();
        
        super.init(coder: coder)
        
        self.positionConverter.setGraphSizeWithWidth(self.graph.width(), height:self.graph.height())
        self.positionConverter.setScreenSizeWithWidth(frame.size.width, height:frame.size.height)
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        NSLog("Redrawing");
        
        let context = NSGraphicsContext.currentContext()?.CGContext
        CGContextClearRect(context, dirtyRect)
        CGContextSetFillColorWithColor(context, NSColor.yellowColor().CGColor)
        CGContextFillRect(context, dirtyRect)
        
        CGContextSetStrokeColorWithColor(context, NSColor.redColor().CGColor)
        
        let cellsWidth : CGFloat = (dirtyRect.size.width / CGFloat(self.graph.width()));
        let cellsHeight : CGFloat = (dirtyRect.size.height / CGFloat(self.graph.height()));
        
        for (var i=0; i<self.graph.width(); ++i)
        {
            CGContextMoveToPoint(context, CGFloat(i)*cellsWidth, 0);
            CGContextAddLineToPoint(context, CGFloat(i)*cellsWidth, dirtyRect.size.height);
            CGContextStrokePath(context)
        }
        
        for (var j=0; j<self.graph.height(); ++j)
        {
            CGContextMoveToPoint(context, 0, CGFloat(j)*cellsHeight);
            CGContextAddLineToPoint(context, dirtyRect.size.width, CGFloat(j)*cellsHeight);
            CGContextStrokePath(context)
        }
        
        CGContextSetFillColorWithColor(context, NSColor.greenColor().CGColor)
        
        for (var i=0; i<self.graph.width(); ++i)
        {
            for (var j=0; j<self.graph.height(); ++j)
            {
                if (!self.graph.isPositionWalkableAtX(i, y:j))
                {
                    CGContextAddRect(context, CGRectMake(CGFloat(i)*cellsWidth, CGFloat(j)*cellsHeight, cellsWidth, cellsHeight));
                    CGContextDrawPath(context, .FillStroke)
                }
            }
        }
        
        self.positionConverter.setScreenSizeWithWidth(dirtyRect.size.width, height:dirtyRect.size.height)
    }
    
    override func mouseUp(theEvent: NSEvent) {
        let position : NSPoint = self.convertPoint(theEvent.locationInWindow, fromView: nil);
        let screenPosition : ScreenPositionObjC = ScreenPositionObjC(x: position.x, y: position.y);
        let graphPosition : GraphPositionObjC = self.positionConverter.graphPositionFromScreenPosition(screenPosition);
        
        if (self.graph.isPositionWalkableAtX(graphPosition.x(), y: graphPosition.y()))
        {
            self.graph.markPositionAsNonWalkableAtX(graphPosition.x(), y: graphPosition.y());
        } else
        {
            self.graph.unmarkPositionAsNonWalkableAtX(graphPosition.x(), y: graphPosition.y());
        }
        
        self.setNeedsDisplayInRect(self.frame);
    }
}
