//
//  Position.hpp
//  A*
//
//  Created by Ricard Perez del Campo on 26/02/16.
//  Copyright © 2016 Ricard Perez del Campo. All rights reserved.
//

#ifndef Position_hpp
#define Position_hpp

#include <cmath>
#include <limits>

namespace AStar
{
    template <class T>
    struct Position
    {
        T x;
        T y;
        Position() : x(0), y(0) {}
        Position(T x, T y) : x(x), y(y) {}
        bool operator<(const Position& other) const { return ((y < other.y) || ((y == other.y) && (x < other.x))); }
        bool operator==(const Position& other) const { return ((x == other.x) && (y == other.y)); }
        float dist(const Position& other) const { return std::sqrt((other.x-x)*(other.x-x) + (other.y-y)*(other.y-y)); }
        void set(T x, T y) { this->x = x; this->y = y; }
        
    protected:
        virtual bool isEqual(T a, T b) = 0;
    };
    
    struct ScreenPosition : Position<float>
    {
        virtual bool isEqual(float a, float b) override { return (std::abs(a-b) <= std::numeric_limits<float>::epsilon()); }
    };
    
    struct GraphPosition : Position<int>
    {
    protected:
        virtual bool isEqual(int a, int b) override { return (a == b); }
    };
}

#endif /* Position_hpp */
