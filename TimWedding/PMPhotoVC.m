//
//  PMPhotoVC.m
//  TimWedding
//
//  Created by Esu Tsai on 2015/9/10.
//  Copyright (c) 2015年 Esu Tsai. All rights reserved.
//

#import "PMPhotoVC.h"
#import "PMPhotoCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "IDMPhotoBrowser.h"

@interface PMPhotoVC () <UICollectionViewDataSource, UICollectionViewDelegate, IDMPhotoBrowserDelegate>
{
    UICollectionView *photoView;
    NSArray *photoList;
}
@end

@implementation PMPhotoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"婚紗";
    // Do any additional setup after loading the view.
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.itemSize =CGSizeMake((SCREEN_BOUNDS.size.width), (SCREEN_BOUNDS.size.width/2));
    
    photoView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_BOUNDS.size.width, SCREEN_BOUNDS.size.height-64-49) collectionViewLayout:layout];
    [self.view addSubview:photoView];
    
    [photoView registerClass:[PMPhotoCell class] forCellWithReuseIdentifier:@"CustomCell"];
    photoView.dataSource = self;
    photoView.delegate = self;
    
    photoList = [[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PhotoList" ofType:@"plist"]] objectAtIndex:0];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return [photoList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CustomCell";
    PMPhotoCell *cell = (PMPhotoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor darkGrayColor];
    NSString *picUrlString = [NSString stringWithFormat:@"%@",[[photoList objectAtIndex:indexPath.row] valueForKey:@"url"]];
    
    cell.imageView.tag = indexPath.row;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapImage:)];
    [cell.imageView addGestureRecognizer:tapGesture];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:picUrlString] placeholderImage:[UIImage imageNamed:@"pic-loading.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize cellSize = CGSizeMake((SCREEN_BOUNDS.size.width/2), (SCREEN_BOUNDS.size.width/2));
    return cellSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)didTapImage:(UITapGestureRecognizer *)tapGesture
{
    [self openImageViewWithTag:tapGesture.view.tag view:tapGesture.view];
}

- (void)openImageViewWithTag:(NSInteger)index view:(id)sender
{
    UIImageView *image = nil;
    if ([sender isKindOfClass:[UIImageView class]]) {
        image = (UIImageView *)sender;
    }
    
    NSMutableArray *photos = [NSMutableArray new];
    IDMPhoto *photo;
    
    for (int i = 0; i<[photoList count]; i++) {
        NSString *picUrlString = [NSString stringWithFormat:@"%@",[[photoList objectAtIndex:i] valueForKey:@"url"]];
        photo = [IDMPhoto photoWithURL:[NSURL URLWithString:picUrlString]];
        [photos addObject:photo];
    }
    
    IDMPhotoBrowser *browser;
    if(image != nil){
        browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos animatedFromView:image];
        browser.scaleImage = image.image;
    }
    browser.delegate = self;
    browser.displayCounterLabel = YES;
    browser.displayActionButton = NO;
    browser.displayArrowButton = NO;
    browser.usePopAnimation = YES;
    
    [browser setInitialPageIndex:index];
    
    [self presentViewController:browser animated:NO completion:nil];
}

@end
