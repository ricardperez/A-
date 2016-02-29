//
//  PathFinder.cpp
//  A*
//
//  Created by Ricard Perez del Campo on 26/02/16.
//  Copyright © 2016 Ricard Perez del Campo. All rights reserved.
//

#include "PathFinder.hpp"
#include "Graph.hpp"
#include <set>
#include <cassert>

namespace AStar
{
    PathFinder::PathFinder(const Graph& graph)
    : graph(&graph)
    {
    }
    
    bool PathFinder::findPathWaypoints(const GraphPosition& origin, const GraphPosition& destination, std::vector<GraphPosition>& outWaypoints)
    {
        std::set<GraphPosition> closedSet;
        std::set<GraphPosition> openSet = {origin};
        std::map<GraphPosition, GraphPosition> cameFrom;
        
        std::map<GraphPosition, float> gScore;
        gScore[origin] = 0;
        
        std::map<GraphPosition, float> fScore;
        fScore[origin] = origin.dist(destination);
        
        while (!openSet.empty())
        {
            int currentBestScore = std::numeric_limits<int>::max();
            const GraphPosition* current = nullptr;
            for (auto& position : openSet)
            {
                auto it = fScore.find(position);
                if (it != fScore.end())
                {
                    if (it->second < currentBestScore)
                    {
                        currentBestScore = it->second;
                        current = &position;
                    }
                }
            }
            
            assert(current != nullptr);
            
            if (*current == destination)
            {
                reconstructPath(cameFrom, destination, outWaypoints);
                return true;
            }
            
            openSet.erase(*current);
            closedSet.insert(*current);
            
            auto neighborsWithWeights = getNeighbors(*current);
            for (auto& neighborWithWeight : neighborsWithWeights)
            {
                auto& neighbor = neighborWithWeight.first;
                if (closedSet.find(neighbor) != closedSet.end())
                {
                    continue;
                }
                
                float tentativeGScore = gScore[*current] + neighborWithWeight.second;
                if (openSet.find(neighbor) == openSet.end())
                {
                    openSet.insert(neighbor);
                } else if ((gScore.find(neighbor) != gScore.end()) && (tentativeGScore >= gScore[neighbor]))
                {
                    continue;
                }
                
                cameFrom[neighbor] = *current;
                gScore[neighbor] = tentativeGScore;
                fScore[neighbor] = tentativeGScore + neighbor.dist(destination);
            }
        }
        
        return false;
    }
    
    std::vector<std::pair<GraphPosition, float>> PathFinder::getNeighbors(const GraphPosition& position) const
    {
        std::vector<std::pair<GraphPosition, float>> result;
        
        auto addIfCorrect = [&](int dx, int dy, float weight) -> void
        {
            GraphPosition neighbor = position;
            neighbor.x += dx;
            neighbor.y += dy;
            
            if (graph->isPositionValid(neighbor.x, neighbor.y) && graph->isPositionWalkable(neighbor.x, neighbor.y))
            {
                result.push_back(std::make_pair(neighbor, weight));
            }
            
        };
        
        addIfCorrect(1,0, 1.0f);
        addIfCorrect(1,1, 1.4142f);
        addIfCorrect(0,1, 1.0f);
        addIfCorrect(-1,1, 1.4142f);
        addIfCorrect(-1,0, 1.0f);
        addIfCorrect(-1,-1, 1.4142f);
        addIfCorrect(0,-1, 1.0f);
        addIfCorrect(1,-1, 1.4142f);
        
        return result;
    }
    
    void PathFinder::reconstructPath(const std::map<GraphPosition, GraphPosition>& cameFrom, const GraphPosition& current, std::vector<GraphPosition>& outWaypoints) const
    {
        std::vector<GraphPosition> reversedVector;
        auto currentPtr = &current;
        while (currentPtr != nullptr)
        {
            reversedVector.push_back(*currentPtr);
            auto it = cameFrom.find(*currentPtr);
            if (it == cameFrom.end() || ((*currentPtr) == it->second))
            {
                currentPtr = nullptr;
            }
            else
            {
                currentPtr = &(it->second);
            }
        }
        
        while (!reversedVector.empty())
        {
            outWaypoints.push_back(reversedVector.back());
            reversedVector.pop_back();
        }
    }
}