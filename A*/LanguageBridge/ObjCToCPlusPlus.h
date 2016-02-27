//
//  ObjCToCPlusPlus.h
//  A*
//
//  Created by Ricard Perez del Campo on 27/02/16.
//  Copyright © 2016 Ricard Perez del Campo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScreenPositionObjC : NSObject

- (instancetype)initWithX:(CGFloat)x y:(CGFloat)y;

- (CGFloat)x;
- (CGFloat)y;

@end

@interface GraphPositionObjC : NSObject

- (instancetype)initWithX:(NSInteger)x y:(NSInteger)y;

- (NSInteger)x;
- (NSInteger)y;

@end

@interface GraphObjC : NSObject

- (instancetype)initWithWidth:(NSInteger)width height:(NSInteger)height;
- (void)dealloc;

- (NSInteger)width;
- (NSInteger)height;
- (BOOL)isPositionWalkableAtX:(NSInteger)x y:(NSInteger)y;
- (void)markPositionAsNonWalkableAtX:(NSInteger)x y:(NSInteger)y;
- (void)unmarkPositionAsNonWalkableAtX:(NSInteger)x y:(NSInteger)y;
- (BOOL)isPositionValidAtX:(NSInteger)x y:(NSInteger)y;

@end

@interface PathFinderObjC : NSObject

- (instancetype)initWithGraph:(GraphObjC*)graphObjC;
- (void)dealloc;
- (BOOL)findPathWaypointsWithOrigin:(GraphPositionObjC*)origin destination:(GraphPositionObjC*)destination result:(NSMutableArray*)outWaypoints;

@end

@interface PositionConverterObjC : NSObject

- (void)setGraphSizeWithWidth:(NSInteger)width height:(NSInteger)height;
- (void)setScreenSizeWithWidth:(CGFloat)width height:(CGFloat)height;
- (GraphPositionObjC*)graphPositionFromScreenPosition:(ScreenPositionObjC*)screenPosition;
- (ScreenPositionObjC*)screenPositionFromGraphPosition:(GraphPositionObjC*)graphPosition;

@end
