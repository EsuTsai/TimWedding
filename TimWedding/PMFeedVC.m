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

@interface PMFeedVC () <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UITableView *feedTableView;
    NSMutableArray *feedList;
}
@end

@implementation PMFeedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    feedList = [[NSMutableArray alloc] init];
    
    feedTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_BOUNDS.size.width, SCREEN_BOUNDS.size.height-64-49)];
    feedTableView.backgroundColor = [UIColor whiteColor];
    feedTableView.dataSource = self;
    feedTableView.delegate = self;
    feedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:feedTableView];
    
    UIButton *photoBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_BOUNDS.size.width - 20 - 50, SCREEN_BOUNDS.size.height-64-49-20-50, 50, 50)];
    photoBtn.layer.cornerRadius = 25;
    photoBtn.backgroundColor = [UIColor redColor];
    [photoBtn addTarget:self action:@selector(openCameraRoll) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:photoBtn];
    [self getData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getData
{
    PFQuery *query = [PFQuery queryWithClassName:@"PostObject"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
                PFFile *imageFile = object[@"uuid"];
                NSDictionary *objectDic = @{@"id":object.objectId,
                                            @"username":object[@"username"],
                                            @"description":object[@"description"],
                                            @"uuid":imageFile.url
                                            };
                [feedList addObject:objectDic];
            }
            [feedTableView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)openCameraRoll
{

    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    NSMutableDictionary * dict= [NSMutableDictionary dictionaryWithDictionary:editingInfo];
    
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
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PMFeedCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }
    
    [cell setContent:[feedList objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //code
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_BOUNDS.size.width + 4;
}

@end
