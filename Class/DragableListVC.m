//
//  DragableListVC.m
//  DragAndDrop
//
//  Created by martin on 05/06/2013.
//  Copyright (c) 2013 doduck.com. All rights reserved.
//

#import "DragableListVC.h"
#import "DragableStaticContainer.h"

#define PADDING_LEFT_ITEM 10
#define PADDING_BOTTOM_ITEM 20
@implementation DragableListVC


-(id)initWithDragableStaticContainers:(NSArray *)_dragableStaticContainers withDelegate:(id<DragableManager>)_delegate{
    self = [super init];
    if(self){
        dragableStaticContainers = [_dragableStaticContainers retain];
        delegate = [_delegate retain];
    }
    return self;
}

-(void)createScrollWithDragableItems{
    [scroll removeFromSuperview];
    
    scroll = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scroll.backgroundColor = [UIColor lightGrayColor];
    
    int y = 0;
    for(DragableStaticContainer *dsContainer in dragableStaticContainers){
        CGRect positionInScroll = CGRectMake(PADDING_LEFT_ITEM,
                                y,
                                dsContainer.dragableView.frame.size.width,
                                dsContainer.dragableView.frame.size.height);
        
        dsContainer.staticView.frame = positionInScroll;
        dsContainer.dragableView.frame = positionInScroll;
        
        
        dsContainer.dragableView.staticView = dsContainer.staticView;
        dsContainer.staticView.dragableView = dsContainer.dragableView;
        
        [scroll addSubview:dsContainer.staticView];
        [scroll addSubview:dsContainer.dragableView];
        
        dsContainer.dragableView.delegate = self;
        dsContainer.staticView.delegate = self;
        
        y += dsContainer.dragableView.frame.size.height + PADDING_BOTTOM_ITEM;
    }
    
    scroll.contentSize = CGSizeMake(self.view.frame.size.width, y - PADDING_BOTTOM_ITEM);
    
    self.view = scroll;
}

-(BOOL)isInList:(DragableView *) dragableView{
    for(DragableStaticContainer *item in dragableStaticContainers){
        if(item.dragableView == dragableView){
            NSArray *subViews = [scroll subviews];
            for(UIView *sub in subViews){
                if(sub == dragableView){
                    return YES;
                }
            }
        }
    }
    return NO;
}

-(void)enableScrool:(BOOL)enable{
    scroll.scrollEnabled = enable;
}


-(CGRect) positionInScrollViewForMotherView:(StaticView *)staticView{
    CGPoint scrollPos = scroll.contentOffset;
    return CGRectMake(staticView.frame.origin.x + scroll.frame.origin.x - scrollPos.x,
                      staticView.frame.origin.y + scroll.frame.origin.y - scrollPos.y,
                      staticView.frame.size.width, staticView.frame.size.height);
}


-(void) isDragingStart:(DragableView *) dragableView{
    [self enableScrool:NO];
    [delegate isDragingStart:dragableView];
}


-(void) isDragingEnd:(DragableView *) dragableView{
    [self enableScrool:YES];
    [delegate isDragingEnd:dragableView];
}

-(void) isDragingMoved:(DragableView *) dragableView{
    [delegate isDragingMoved:dragableView];
}

-(void) isTap:(DragableView *) dragableView{
    if(!dragableView.isHome){
        [delegate requestHome:dragableView];
    }else{
        [currentSelected setUnSelected];
        [currentSelected release];
        currentSelected = [dragableView retain];
        [currentSelected setSelected];
        [delegate selected:dragableView];
    }
}

-(void) isStaticTap:(StaticView *) staticView{
    [delegate requestHome:staticView.dragableView];
}

-(void)dealloc{
    [delegate release];
    [dragableStaticContainers release];
    [super dealloc];
}

@end
