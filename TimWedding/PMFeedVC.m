//
//  PMFeedVC.m
//  TimWedding
//
//  Created by Esu Tsai on 2015/9/13.
//  Copyright (c) 2015年 Esu Tsai. All rights reserved.
//

#import "PMFeedVC.h"
#import "PMFeedCell.h"
#import "PMSelectPhotoVC.h"
#import <Parse/Parse.h>
#import <FontAwesomeKit/FontAwesomeKit.h>
#import <DGActivityIndicatorView.h>
#import "PMMessageVC.h"
#import "PMUtility.h"
#import "NSString+Height.h"
#import "IDMPhotoBrowser.h"

@interface PMFeedVC () <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, messageBtnDelegate, IDMPhotoBrowserDelegate, EMMessageDelegate>
{
    UITableView *feedTableView;
    NSMutableArray *feedList;
    DGActivityIndicatorView *activityIndicatorView;
    UIImageView *bottomImg;
    UIRefreshControl *refreshControl;
    NSNumber *didSelectCell;
}
@end

@implementation PMFeedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"POM & MIKI";
    // Do any additional setup after loading the view.
    feedList = [[NSMutableArray alloc] init];
    didSelectCell = 0;
    feedTableView                 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_BOUNDS.size.width, SCREEN_BOUNDS.size.height-64-49)];
    feedTableView.backgroundColor = [UIColor whiteColor];
    feedTableView.dataSource      = self;
    feedTableView.delegate        = self;
    feedTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = [UIColor colorWithRed:0.843 green:0.843 blue:0.843 alpha:1.000];
    refreshControl.tintColor = [UIColor lightGrayColor];
    [refreshControl addTarget:self
                       action:@selector(getLatestData)
             forControlEvents:UIControlEventValueChanged];
    
    [feedTableView addSubview:refreshControl];
    [self.view addSubview:feedTableView];
    
    UIButton *photoBtn          = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_BOUNDS.size.width - 20 - 50, SCREEN_BOUNDS.size.height-64-49-20-50, 50, 50)];
    photoBtn.layer.cornerRadius = 25;
    photoBtn.backgroundColor    = [UIColor colorWithRed:1.000 green:0.322 blue:0.325 alpha:1.000];
//    photoBtn.backgroundColor = [UIColor colorWithRed:78.0/255.0 green:139.0/255.0 blue:115.0/255.0 alpha:1.000];
    [photoBtn addTarget:self action:@selector(openCameraRoll) forControlEvents:UIControlEventTouchUpInside];

    FAKIonIcons *cameraIcon = [FAKIonIcons ios7CameraOutlineIconWithSize:34];
    [cameraIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage *cameraImage    = [cameraIcon imageWithSize:CGSizeMake(34, 34)];
    [photoBtn setImage:cameraImage forState:UIControlStateNormal];
    [self.view addSubview:photoBtn];

    bottomImg               = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_BOUNDS.size.width, SCREEN_BOUNDS.size.height-64-49)];
    [bottomImg setImage:[UIImage imageNamed:@"jc-4501.jpg"]];
    bottomImg.contentMode   = UIViewContentModeScaleAspectFill;
    bottomImg.clipsToBounds = YES;
    
    UIVisualEffect *blurEffect;
    blurEffect             = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *visualEffectView;
    visualEffectView       = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame = bottomImg.bounds;
    [bottomImg addSubview:visualEffectView];
    [self.view addSubview:bottomImg];
    
    activityIndicatorView        = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeDoubleBounce tintColor:[UIColor colorWithRed:78.0/255.0 green:139.0/255.0 blue:115.0/255.0 alpha:1.000] size:30.0f];
    activityIndicatorView.frame  = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
    activityIndicatorView.center = CGPointMake(SCREEN_BOUNDS.size.width/2, (SCREEN_BOUNDS.size.height-64-49)/2);
    [self.view addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
    [self getData];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshData" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getData
{
    PFQuery *query = [PFQuery queryWithClassName:@"PostObject"];
    [query orderByDescending:@"createdAt"];
    [query setLimit:1000];
    [query setSkip:0];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
                PFFile *imageFile = object[@"uuid"];
                NSDictionary *objectDic = @{@"id":object.objectId,
                                            @"username":object[@"username"],
                                            @"description":object[@"description"],
                                            @"uuid":imageFile.url,
                                            @"likeList":object[@"likeList"],
                                            @"commentList":object[@"commentList"],
                                            @"messagecount":object[@"messagecount"],
                                            @"likecount":object[@"likecount"],
                                            @"createdat":object.createdAt
                                            };
                [feedList addObject:objectDic];
            }
            
            [feedTableView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        [UIView animateWithDuration:0.4f animations:^{
            bottomImg.alpha = 0.0;
            
        } completion:^(BOOL finished) {
            bottomImg.hidden = YES;
            
        }];
        if (refreshControl) {
            [refreshControl endRefreshing];
        }
        
        [activityIndicatorView stopAnimating];
    }];
    
}

- (void)getLatestData
{
    feedList = [[NSMutableArray alloc] init];
    [self getData];
}

- (void)refreshData
{
    [activityIndicatorView startAnimating];
    feedList = [[NSMutableArray alloc] init];
    [self getData];
}

- (void)refreshMessageCount:(NSInteger)count
{
    if(didSelectCell){
        NSMutableDictionary *feedDict = [[feedList objectAtIndex:[didSelectCell integerValue]] mutableCopy];
        [feedDict removeObjectForKey:@"messagecount"];
        [feedDict setObject:[NSString stringWithFormat:@"%ld",count] forKey:@"messagecount"];
        [feedList replaceObjectAtIndex:[didSelectCell integerValue] withObject:feedDict];
        [feedTableView reloadData];
    }

}

- (void)openCameraRoll
{

    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle   = UIModalPresentationCurrentContext;
    imagePickerController.sourceType               = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate                 = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"refreshData" object:nil];
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:editingInfo];
    
    [dict setObject:image forKey:@"UIImagePickerControllerEditedImage"];
    
    PMSelectPhotoVC *postImage = [[PMSelectPhotoVC alloc] initWithPhoto:image];
    [self.navigationController pushViewController:postImage animated:YES];
    [picker dismissModalViewControllerAnimated:YES];
    

}

#pragma mark - UITableViewDataSourece
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; //optional
//{
//    return <#NSInteger#>;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [feedList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"PMFeedCell";
    PMFeedCell *cell = [feedTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSArray *nib        = [[NSBundle mainBundle] loadNibNamed:@"PMFeedCell" owner:self options:nil];
        cell                = [nib objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    cell.cellDelegate = self;
    [cell setContent:[feedList objectAtIndex:indexPath.row] index:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight = [[NSString circulateLabelHeight:[[feedList objectAtIndex:indexPath.row] objectForKey:@"description"] labelWidth:SCREEN_BOUNDS.size.width-20 labelFont:[UIFont fontWithName:defaultFont size:15]] floatValue];
    
    if(cellHeight > 0){
        return 5+35+5+cellHeight+5+SCREEN_BOUNDS.size.width + 5+30+5+1+5+40+5+4;

    }else{
        return 5+35+5+SCREEN_BOUNDS.size.width + 5+30+5+1+5+40+5+4;

    }
}

- (void)openMessagePage:(NSInteger)index
{
    if([feedList count] > 0){
        didSelectCell = [NSNumber numberWithInteger:index];
        PMMessageVC *messageVC = [[PMMessageVC alloc] initWithFeed:[[feedList objectAtIndex:index] objectForKey:@"id"]];
        messageVC.messageDelegate = self;
        [self.navigationController pushViewController:messageVC animated:YES];

    }
}

- (void)updateLikeData:(NSMutableArray *)likeList index:(NSInteger)index status:(NSInteger)status
{
    NSMutableDictionary *feedDict = [[feedList objectAtIndex:index] mutableCopy];
    NSMutableArray *likeArray = [[feedDict objectForKey:@"likeList"] mutableCopy];
    [likeArray addObject:[[PMUtility sharedInstance] userToken]];
    [feedDict removeObjectForKey:@"likeList"];
    [feedDict setValue:likeArray forKey:@"likeList"];
    NSInteger preLikeCount = [[feedDict objectForKey:@"likecount"] integerValue];
    [feedDict removeObjectForKey:@"likecount"];
    [feedDict setValue:[NSString stringWithFormat:@"%ld",preLikeCount+1] forKey:@"likecount"];
    [feedList replaceObjectAtIndex:index withObject:feedDict];
    [feedTableView reloadData];
}

- (void)openImageWithTag:(NSInteger)tag view:(UIImageView *)sender
{
    IDMPhoto *photo;
    NSString *picUrlString = [NSString stringWithFormat:@"%@",[[feedList objectAtIndex:tag] objectForKey:@"uuid"]];
    NSMutableArray *photos = [NSMutableArray new];
    photo = [IDMPhoto photoWithURL:[NSURL URLWithString:picUrlString]];
    [photos addObject:photo];

    IDMPhotoBrowser *browser;
    browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos animatedFromView:sender];
    browser.scaleImage = sender.image;
    browser.delegate = self;
    browser.displayCounterLabel = NO;
    browser.displayActionButton = NO;
    browser.displayArrowButton = NO;
    browser.usePopAnimation = YES;
    
    [self presentViewController:browser animated:NO completion:nil];

}
@end
