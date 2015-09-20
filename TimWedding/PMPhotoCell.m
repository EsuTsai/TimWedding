//
//  PMPhotoCell.m
//  TimWedding
//
//  Created by Esu Tsai on 2015/9/11.
//  Copyright (c) 2015年 Esu Tsai. All rights reserved.
//

#import "PMPhotoCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation PMPhotoCell
@synthesize imageView;

- (void)setContent:(NSString *)url
{
    UIImageView *imgView           = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_BOUNDS.size.width/2, SCREEN_BOUNDS.size.width/2)];
    imgView.contentMode            = UIViewContentModeScaleAspectFill;
    imgView.clipsToBounds          = YES;
    imgView.userInteractionEnabled = YES;
    
    [imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"pic-loading.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    [self.contentView addSubview:imgView];
}


- (id)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];
    {
        UILabel *background = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width-1, self.frame.size.height-1)];
        background.backgroundColor = [UIColor darkGrayColor];
        [self addSubview:background];
        
        //we create the UIImageView in this overwritten init so that we always have it at hand.
        imageView                        = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_BOUNDS.size.width/2, SCREEN_BOUNDS.size.width/2)];
        imageView.contentMode            = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds          = YES;
        imageView.userInteractionEnabled = YES;
        //set specs and special wants for the imageView here.
        [self addSubview:imageView]; //the only place we want to do this addSubview: is here!
        
        //You wanted the imageView to react to touches and gestures. We can do that here too.
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onButtonTapped:)];
        [tap setNumberOfTapsRequired:1];
        [self addGestureRecognizer:tap];
        
        //We can also prepare views with additional contents here!
        //just add more labels/views/whatever you want.
    }
    return self;
}

-(void)onButtonTapped:(id)sender
{
    //the response to the gesture.
    //mind that this is done in the cell. If you don't want things to happen from this cell.
    //then you can still activate this the way you did in your question.
    
}

@end
