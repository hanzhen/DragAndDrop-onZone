//
//  DragDropVC.m
//  DragAndDrop
//
//  Created by martin on 05/06/2013.
//  Copyright (c) 2013 doduck.com. All rights reserved.
//
#import "DragDropManagerVC.h"
#import "ZoneView.h"

@implementation DragDropManagerVC

-(id)initWithDragableItem:(NSArray *)_dragableItems withZones:(NSArray *)_zones forZoneView:(UIView *)_zoneView{
    self = [super init];
    if(self){
        dragableItems = [_dragableItems retain];
        zones = [_zones retain];
        zoneView = [_zoneView retain];
    }
    return self;
}

-(void)viewDidLoad{
    dList = [[DragableListVC alloc] initWithDragableItem:dragableItems withDelegate:self];
    dList.view.frame = CGRectMake(50, 50, 120, 300);
    [dList createScrollWithDragableItems];
    [self.view addSubview:dList.view];
    
    dZone = [[MultiZoneVC alloc] initWithZones:zones withBg:zoneView];
    dZone.view.frame = CGRectMake(200, 50, zoneView.frame.size.width, zoneView.frame.size.height);
    [self.view addSubview:dZone.view];
}

-(void) isDragingStart:(DragableView *) dragableView{
    
    if([dList isInList:dragableView]){
        dragableView.frame = CGRectMake(dragableView.frame.origin.x+dList.view.frame.origin.x,
                                    dragableView.frame.origin.y+dList.view.frame.origin.y,
                                    dragableView.frame.size.width,
                                    dragableView.frame.size.height);
        [self.view addSubview:dragableView];
    }
}


-(void) isDragingEnd:(DragableView *) dragableView{
    
    ZoneView *matchingZone = [dZone inAZone:dragableView];
    if(matchingZone != nil){
        [matchingZone dropIn:dragableView];
        [dragableView dropInZone:matchingZone];
    }
}

-(void) isDragingMoved:(DragableView *) dragableView{
    
    ZoneView *matchingZone = [dZone inAZone:dragableView];
    if(matchingZone != nil){
        [matchingZone movedIn:dragableView];
        [dragableView movedInZone:matchingZone];
        
        lastOverZone = matchingZone;
    }else if(lastOverZone != nil){
        [lastOverZone movedOut:dragableView];
        [dragableView movedOutZone:lastOverZone];
        lastOverZone = nil;
    }

}

-(void)dealloc{
    [dragableItems release];
    [dList release];
    [super dealloc];
}


@end