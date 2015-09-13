//
//  PMSelectPhotoVC.m
//  TimWedding
//
//  Created by Esu Tsai on 2015/9/13.
//  Copyright (c) 2015年 Esu Tsai. All rights reserved.
//

#import "PMSelectPhotoVC.h"
#import <Parse/Parse.h>

@interface PMSelectPhotoVC () <UITextFieldDelegate, UITextViewDelegate>
{
    UIImage *selectPhoto;
    UITextField *userName;
    UITextView *feedInfo;
    UIButton *userNameLayer;
}
@end

@implementation PMSelectPhotoVC

- (id)initWithPhoto:(UIImage *)image
{
    self = [super init];
    if(self){
        selectPhoto = image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    userName = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, SCREEN_BOUNDS.size.width, 50)];
    userName.backgroundColor = [UIColor whiteColor];
    userName.delegate = self;
    userName.placeholder = @"請輸入暱稱";
    userName.font = [UIFont fontWithName:defaultFont size:18.];
    [[userName valueForKey:@"textInputTraits"] setValue:[UIColor colorWithRed:0.698 green:0.698 blue:0.698 alpha:1.000] forKey:@"insertionPointColor"];
    
    UIView *userNamePaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 50)];
    userName.leftView = userNamePaddingView;
    userName.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:userName];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, userName.frame.size.height, SCREEN_BOUNDS.size.width, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line];
    
    feedInfo = [[UITextView alloc] initWithFrame:CGRectMake(0, userName.frame.size.height + line.frame.size.height, SCREEN_BOUNDS.size.width, 100)];
    feedInfo.delegate = self;
    [self.view addSubview:feedInfo];
    
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, feedInfo.frame.origin.y + feedInfo.frame.size.height, SCREEN_BOUNDS.size.width, 1)];
    line2.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line2];
    
    UIImageView *postImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, feedInfo.frame.origin.y + feedInfo.frame.size.height, SCREEN_BOUNDS.size.width, SCREEN_BOUNDS.size.height - 64-49-50-100-50)];
    postImage.contentMode = UIViewContentModeScaleAspectFit;
    postImage.clipsToBounds = YES;
    [postImage setImage:selectPhoto];
    [self.view addSubview:postImage];
    
    UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_BOUNDS.size.height - 64 - 49 -50, SCREEN_BOUNDS.size.width, 50)];
    sendBtn.backgroundColor = [UIColor blueColor];
    [sendBtn addTarget:self action:@selector(sendFeed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendBtn];
    
    userNameLayer = [[UIButton alloc] initWithFrame:CGRectMake(0, userName.frame.size.height+feedInfo.frame.size.height, SCREEN_BOUNDS.size.width, SCREEN_BOUNDS.size.height-64-49-userName.frame.size.height-feedInfo.frame.size.height-sendBtn.frame.size.height)];
    userNameLayer.userInteractionEnabled = NO;
    [userNameLayer addTarget:self action:@selector(dissmissKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:userNameLayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    userNameLayer.userInteractionEnabled = YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    userNameLayer.userInteractionEnabled = YES;
}

- (void)dissmissKeyboard
{
    [userName resignFirstResponder];
    [feedInfo resignFirstResponder];
}

- (void)sendFeed
{
    NSData *imageData = UIImagePNGRepresentation(selectPhoto);
    NSString *imageType = [self contentTypeForImageData:imageData];
    PFFile *imageFile = [PFFile fileWithName:[NSString stringWithFormat:@"image1.%@",imageType] data:imageData];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (succeeded) {
            PFObject *postObject = [PFObject objectWithClassName:@"PostObject"];
            postObject[@"username"] = userName.text;
            postObject[@"description"] = feedInfo.text;
            postObject[@"uuid"] = imageFile;
            [postObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } else {
            // There was a problem, check error.description
        }
    }];
    
    
}

- (NSString *)contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"jpeg";
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        case 0x49:
            break;
        case 0x42:
            return @"bmp";
        case 0x4D:
            return @"tiff";
    }
    return nil;
}


@end
