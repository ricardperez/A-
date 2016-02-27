//
//  Graph.cpp
//  A*
//
//  Created by Ricard Perez del Campo on 26/02/16.
//  Copyright © 2016 Ricard Perez del Campo. All rights reserved.
//

#include "Graph.hpp"
#include <cassert>

namespace AStar
{
    Graph::Graph(int width, int height)
    : width(width)
    , height(height)
    {
        area.reserve(width);
        for (int i=0; i<width; ++i)
        {
            area.push_back(std::vector<bool>());
            area[i].reserve(height);
            for (int j=0; j<height; ++j)
            {
                area[i].push_back(true);
            }
        }
    }
    
    int Graph::getWidth() const
    {
        return width;
    }
    
    int Graph::getHeight() const
    {
        return height;
    }
    
    bool Graph::isPositionWalkable(int x, int y) const
    {
        assert(isPositionValid(x, y));
        
        return area[x][y];
    }
    
    void Graph::markPositionAsNonWalkable(int x, int y)
    {
        assert(isPositionValid(x, y));
        
        area[x][y] = false;
    }
    
    void Graph::unmarkPositionAsNonWalkable(int x, int y)
    {
        assert(isPositionValid(x, y));
        
        area[x][y] = true;
    }
    
    bool Graph::isPositionValid(int x, int y) const
    {
        return ((x >= 0) && (x < width) && (y >= 0) && (y < height));
    }
}