//
//  PositionConverter.cpp
//  A*
//
//  Created by Ricard Perez del Campo on 26/02/16.
//  Copyright © 2016 Ricard Perez del Campo. All rights reserved.
//

#include "PositionConverter.hpp"

namespace AStar
{
    PositionConverter::PositionConverter()
    : graphWidth(0)
    , graphHeight(0)
    , screenWidth(0.0f)
    , screenHeight(0.0f)
    , scaleWidthGraphToScreen(0.0f)
    , scaleHeightGraphToScreen(0.0f)
    , scaleWidthScreenToGraph(0.0f)
    , scaleHeightScreenToGraph(0.0f)
    {
    }
    
    void PositionConverter::setGraphSize(int width, int height)
    {
        graphWidth = width;
        graphHeight = height;
        
        recalculateScales();
    }
    
    void PositionConverter::setScreenSize(float width, float height)
    {
        screenWidth = width;
        screenHeight = height;
        
        recalculateScales();
    }
    
    GraphPosition PositionConverter::graphPositionFromScreenPosition(const ScreenPosition& screenPosition) const
    {
        GraphPosition result;
        
        result.x = (screenPosition.x * scaleWidthScreenToGraph);
        result.y = (screenPosition.y * scaleHeightScreenToGraph);
        
        return result;
    }
    
    ScreenPosition PositionConverter::screenPositionFromGraphPosition(const GraphPosition& graphPosition) const
    {
        ScreenPosition result;
        
        result.x = (graphPosition.x * scaleWidthGraphToScreen);
        result.y = (graphPosition.y * scaleHeightGraphToScreen);
        
        return result;
    }
    
    void PositionConverter::recalculateScales()
    {
        scaleWidthGraphToScreen = (graphWidth > 0.0f ? (screenWidth / graphWidth) : 0.0f);
        scaleHeightGraphToScreen = (graphHeight > 0.0f ? (screenHeight / graphHeight) : 0.0f);
        
        scaleWidthScreenToGraph = (screenWidth > 0.0f ? (graphWidth / screenWidth) : 0.0f);
        scaleHeightScreenToGraph = (screenHeight > 0.0f ? (graphHeight / screenHeight) : 0.0f);
    }
}
