//
//  PathFinder.hpp
//  A*
//
//  Created by Ricard Perez del Campo on 26/02/16.
//  Copyright © 2016 Ricard Perez del Campo. All rights reserved.
//

#ifndef PathFinder_hpp
#define PathFinder_hpp

#include <vector>
#include <map>
#include "Position.hpp"

namespace AStar
{
    class Graph;
    
    class PathFinder
    {
    public:
        PathFinder(const Graph& graph);
        bool findPathWaypoints(const GraphPosition& origin, const GraphPosition& destination, std::vector<GraphPosition>& outWaypoints);
        
    private:
        std::vector<GraphPosition> getNeighbors(const GraphPosition& position) const;
        void reconstructPath(const std::map<GraphPosition, GraphPosition>& cameFrom, const GraphPosition& current, std::vector<GraphPosition>& outWaypoints) const;
        
    private:
        const Graph* graph;
    };
}

#endif /* PathFinder_hpp */
