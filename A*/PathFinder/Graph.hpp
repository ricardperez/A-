//
//  Graph.hpp
//  A*
//
//  Created by Ricard Perez del Campo on 26/02/16.
//  Copyright © 2016 Ricard Perez del Campo. All rights reserved.
//

#ifndef Graph_hpp
#define Graph_hpp

#include <vector>

namespace AStar
{
    class Graph
    {
    public:
        Graph(int width, int height);
        
        int getWidth() const;
        int getHeight() const;
        
        bool isPositionWalkable(int x, int y) const;
        void markPositionAsNonWalkable(int x, int y);
        void unmarkPositionAsNonWalkable(int x, int y);
        bool isPositionValid(int x, int y) const;
        
    private:
        const int width;
        const int height;
        std::vector<std::vector<bool>> area;
    };
}

#endif /* Graph_hpp */
