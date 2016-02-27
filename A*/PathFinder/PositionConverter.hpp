//
//  PositionConverter.hpp
//  A*
//
//  Created by Ricard Perez del Campo on 26/02/16.
//  Copyright © 2016 Ricard Perez del Campo. All rights reserved.
//

#ifndef PositionConverter_hpp
#define PositionConverter_hpp

#include "Position.hpp"

namespace AStar
{
    class PositionConverter
    {
    public:
        PositionConverter();
        void setGraphSize(int width, int height);
        void setScreenSize(float width, float height);
        
        GraphPosition graphPositionFromScreenPosition(const ScreenPosition& screenPosition) const;
        ScreenPosition screenPositionFromGraphPosition(const GraphPosition& graphPosition) const;
        
    private:
        void recalculateScales();
        
    private:
        int graphWidth;
        int graphHeight;
        float screenWidth;
        float screenHeight;
        
        float scaleWidthGraphToScreen;
        float scaleHeightGraphToScreen;
        float scaleWidthScreenToGraph;
        float scaleHeightScreenToGraph;
    };
}

#endif /* PositionConverter_hpp */
