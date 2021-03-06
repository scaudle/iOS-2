//  Copyright 2011 WidgetAvenue - Librelio. All rights reserved.

#import "WATilingView.h"
#import <QuartzCore/CATiledLayer.h>
#import "WAUtilities.h"
#import "WAOperationsManager.h"



@implementation WATilingView
@synthesize annotates,pdfDocument,page;

+ (Class)layerClass {
	return [CATiledLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        CATiledLayer *tiledLayer = (CATiledLayer *)[self layer];
        //tiledLayer.levelsOfDetail = 3;
		//tiledLayer.levelsOfDetailBias = 2;
		tiledLayer.tileSize = CGSizeMake(2048,2048);//The actual size will be much smaller, due to the bias  
    }
    return self;
}

-(void)layoutSubviews{
    //Hack: on Retina display only, correct contentScaleFactor
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] == YES && [[UIScreen mainScreen] scale] == 2.00) {
        self.contentScaleFactor=0.5;
    }
    [super layoutSubviews];
}

- (void)dealloc {
    //SLog(@"Will dealloc %@",self);
    [super dealloc];
	
}


- (void)drawRect:(CGRect)rect {
    //Hack: sometimes, self.superview is deallocated, but not yet self, which crashes the app
    if (self.superview){
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        // get the scale from the context by getting the current transform matrix, then asking for
        // its "a" component, which is one of the two scale components. We could also ask for "d".
        // This assumes (safely) that the view is being scaled equally in both dimensions.
        CGFloat scale = CGContextGetCTM(context).a;
        
        
        //SLog(@"Drawing rect for  page %i at position x %f position y %f  with scale %f height %f bias %i view %@ contentScaleFactor %f",page,rect.origin.x, rect.origin.y,scale,self.superview.frame.size.height,(int)[(CATiledLayer *)[self layer]levelsOfDetailBias],self,self.contentScaleFactor) ;
        CGRect tileRect = CGRectMake(rect.origin.x*scale, rect.origin.y*scale, rect.size.width*scale, rect.size.height*scale);
        CGRect imageRect = CGRectMake(0, 0, self.superview.frame.size.width*scale, self.superview.frame.size.height*scale);
        
        UIImage * tileImage = [pdfDocument drawTileForPage:page withTileRect:tileRect withImageRect:imageRect];
        //NSData * imgData = UIImageJPEGRepresentation(tileImage,0.7);
        
        //[LibrelioUtilities storeCacheFileForDocument:@"test" forPage:0 forSize:(int)rect.origin.x*scale*10000+rect.origin.y*scale withData:imgData];
        [tileImage drawInRect:rect];

        
    }
	

}




@end
