//
//  PMMessageVC.m
//  TimWedding
//
//  Created by Esu Tsai on 2015/9/16.
//  Copyright (c) 2015年 Esu Tsai. All rights reserved.
//

#import "PMMessageVC.h"
#import <Parse/Parse.h>
#import "PMUtility.h"

@interface PMMessageVC () <UITextFieldDelegate, UITextViewDelegate>
{
    NSString *feedId;
    UITextField *userName;
    UITextView *message;
    NSMutableArray *messageList;
    UILabel *messageLabel;
    UIButton *bottomBtn;
}
@end

@implementation PMMessageVC

- (id)initWithFeed:(NSString *)objectId
{
    self = [super init];
    if(self){
        feedId = objectId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    messageList = [[NSMutableArray alloc] init];
    
    bottomBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_BOUNDS.size.width, SCREEN_BOUNDS.size.height - 64 - 49)];
    [bottomBtn addTarget:self action:@selector(dissmissKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomBtn];
    
    messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_BOUNDS.size.height - 64 - 49 - 30 - 16 -1 - 30 -8 , SCREEN_BOUNDS.size.width, 24+60+10)];
    [messageLabel layoutIfNeeded];
    messageLabel.userInteractionEnabled = YES;
    [self.view addSubview:messageLabel];
    
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    visualEffectView.frame = messageLabel.bounds;
    [messageLabel addSubview:visualEffectView];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(10, 1, SCREEN_BOUNDS.size.width-20, 1)];
    line.backgroundColor = [UIColor colorWithWhite:0.798 alpha:1.000];
    [messageLabel addSubview:line];
    
    userName = [[UITextField alloc] initWithFrame:CGRectMake(10, 8+1, SCREEN_BOUNDS.size.width-20 - 58, 30)];
    userName.backgroundColor = [UIColor whiteColor];
    userName.layer.borderColor = [UIColor colorWithWhite:0.798 alpha:1.000].CGColor;
    userName.layer.borderWidth = 1.f;
    userName.layer.cornerRadius = 4.f;
    userName.delegate = self;
    userName.placeholder = @"請輸入暱稱";
    userName.font = [UIFont fontWithName:defaultFont size:18.];
    [[userName valueForKey:@"textInputTraits"] setValue:[UIColor colorWithRed:0.698 green:0.698 blue:0.698 alpha:1.000] forKey:@"insertionPointColor"];
    
    UIView *userNamePaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 50)];
    userName.leftView = userNamePaddingView;
    userName.leftViewMode = UITextFieldViewModeAlways;
    [messageLabel addSubview:userName];
    
    UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_BOUNDS.size.width - 10 - 50,8+1, 50, 30)];
    sendBtn.layer.cornerRadius = 4.f;
    sendBtn.backgroundColor = [UIColor colorWithRed:78.0/255.0 green:139.0/255.0 blue:115.0/255.0 alpha:1.000];
    [sendBtn setTitle:@"發送" forState:UIControlStateNormal];
    sendBtn.titleLabel.textColor = [UIColor whiteColor];
    sendBtn.titleLabel.font = [UIFont fontWithName:defaultFont size:14];
    [sendBtn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    [messageLabel addSubview:sendBtn];
    
    message = [[UITextView alloc] initWithFrame:CGRectMake(10, 8+1+30+8, SCREEN_BOUNDS.size.width-20, 30)];
    message.delegate = self;
    message.layer.borderColor =  [UIColor colorWithWhite:0.798 alpha:1.000].CGColor;
    message.layer.borderWidth = 1.f;
    message.layer.cornerRadius = 4.f;
    message.text = @"hihi";
    [messageLabel addSubview:message];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:.25 animations:^{
        messageLabel.frame = CGRectMake(0, messageLabel.frame.origin.y-216, messageLabel.frame.size.width, messageLabel.frame.size.height);
    } completion:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:.25 animations:^{
        messageLabel.frame = CGRectMake(0, messageLabel.frame.origin.y+216, messageLabel.frame.size.width, messageLabel.frame.size.height);
    } completion:nil];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:.25 animations:^{
        messageLabel.frame = CGRectMake(0, messageLabel.frame.origin.y-216, messageLabel.frame.size.width, messageLabel.frame.size.height);
    } completion:nil];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView animateWithDuration:.25 animations:^{
        messageLabel.frame = CGRectMake(0, messageLabel.frame.origin.y+216, messageLabel.frame.size.width, messageLabel.frame.size.height);
    } completion:nil];
}

- (void)dissmissKeyboard
{
    [userName resignFirstResponder];
    [message resignFirstResponder];
}

- (void)getData
{
    PFQuery *query = [PFQuery queryWithClassName:@"MessageObject"];
    [query whereKey:@"feedid" equalTo:feedId];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
                NSDictionary *objectDic = @{@"id":object.objectId,
                                            @"username":object[@"username"],
                                            @"description":object[@"description"],
                                            @"usertoken":object[@"usertoken"]
                                            };
                [messageList addObject:objectDic];
            }
            
//            [messageTableView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
    }];

}

- (void)sendMessage
{
    
    PFObject *postObject = [PFObject objectWithClassName:@"MessageObject"];
    postObject[@"feedid"] = feedId;
    postObject[@"username"] = userName.text;
    postObject[@"description"] = message.text;
    postObject[@"usertoken"] = [[PMUtility sharedInstance] userToken];
    [postObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if(succeeded){
            [self getData];
        }else{
            
        }
        
    }];
    
}
@end
