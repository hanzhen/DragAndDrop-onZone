//
//  DragDropVC.h
//  DragAndDrop
//
//  Created by martin on 05/06/2013.
//  Copyright (c) 2013 doduck.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DragableListVC.h"
#import "MultiZoneVC.h"

@interface DragDropManagerVC: UIViewController<DragableManager, ZoneEvent>{
    
    DragableListVC *dList;
    NSArray* dragableStaticControllers;
    
    MultiZoneVC *dZone;
    NSArray *zones;
    UIView *zoneView;
    
    ZoneView *lastOverZone;
}

@property(retain, nonatomic)DragableView *currentSelectedDragableView;

-(id)initWithDragableStaticControllers:(NSArray *)_dragableStaticControllers withZones:(NSArray *)_zones forZoneView:(UIView *)_zoneView;

-(void) correction;
-(BOOL) isGoodAwnser;

@end
