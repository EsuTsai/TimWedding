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
#import "PMMessageCell.h"
#import "NSString+Height.h"
#import <DGActivityIndicatorView.h>

@interface PMMessageVC () <UITextFieldDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource>
{
    NSString *feedId;
    UITextField *userName;
    UITextView *message;
    NSMutableArray *messageList;
    UILabel *messageLabel;
    UIButton *bottomBtn;
    UITableView *messageTableView;
    UIButton *sendBtn;
    BOOL isSending;
    UIImageView *sendingView;
    UILabel *sendingText;
    DGActivityIndicatorView *activityIndicatorView;
}
@end

@implementation PMMessageVC
@synthesize messageDelegate = _messageDelegate;


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
    self.title = @"留言";
    self.view.backgroundColor = [UIColor whiteColor];
    isSending = NO;
    messageList = [[NSMutableArray alloc] init];
    
    messageTableView                = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_BOUNDS.size.width, SCREEN_BOUNDS.size.height - 64 - 49 - 30 - 16 -1 - 30 -8-10)];
    messageTableView.delegate       = self;
    messageTableView.dataSource     = self;
    messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:messageTableView];
    
    bottomBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_BOUNDS.size.width, SCREEN_BOUNDS.size.height - 64 - 49)];
    [bottomBtn addTarget:self action:@selector(dissmissKeyboard) forControlEvents:UIControlEventTouchUpInside];
    bottomBtn.userInteractionEnabled = NO;
    [self.view addSubview:bottomBtn];
    
    messageLabel                        = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_BOUNDS.size.height - 64 - 49 - 40 - 16 -1 - 30 -8 , SCREEN_BOUNDS.size.width, 200)];
    [messageLabel layoutIfNeeded];
    messageLabel.userInteractionEnabled = YES;
    messageLabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:messageLabel];
    
//    UIVisualEffect *blurEffect;
//    blurEffect             = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    UIVisualEffectView *visualEffectView;
//    visualEffectView       = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//    visualEffectView.frame = messageLabel.bounds;
//    [messageLabel addSubview:visualEffectView];
    
    UILabel *line        = [[UILabel alloc] initWithFrame:CGRectMake(10, 1, SCREEN_BOUNDS.size.width-20, 1)];
    line.backgroundColor = [UIColor colorWithWhite:0.798 alpha:1.000];
    [messageLabel addSubview:line];
    
    userName                    = [[UITextField alloc] initWithFrame:CGRectMake(10, 8+1, SCREEN_BOUNDS.size.width-20 - 58, 30)];
    userName.backgroundColor    = [UIColor whiteColor];
    userName.layer.borderColor  = [UIColor colorWithWhite:0.798 alpha:1.000].CGColor;
    userName.layer.borderWidth  = 1.f;
    userName.layer.cornerRadius = 4.f;
    userName.delegate           = self;
    userName.text               = [[PMUtility sharedInstance] userName];
    userName.placeholder        = @"請輸入暱稱";
    userName.font               = [UIFont fontWithName:defaultFont size:18.];
    [[userName valueForKey:@"textInputTraits"] setValue:[UIColor colorWithRed:0.698 green:0.698 blue:0.698 alpha:1.000] forKey:@"insertionPointColor"];
    
    UIView *userNamePaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 50)];
    userName.leftView           = userNamePaddingView;
    userName.leftViewMode       = UITextFieldViewModeAlways;
    [messageLabel addSubview:userName];
    
    sendBtn                      = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_BOUNDS.size.width - 10 - 50,8+1, 50, 30)];
    sendBtn.layer.cornerRadius   = 4.f;
    sendBtn.backgroundColor      = [UIColor colorWithRed:78.0/255.0 green:139.0/255.0 blue:115.0/255.0 alpha:1.000];
    [sendBtn setTitle:@"發送" forState:UIControlStateNormal];
    sendBtn.titleLabel.textColor = [UIColor whiteColor];
    sendBtn.titleLabel.font      = [UIFont fontWithName:defaultFont size:14];
    [sendBtn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    [messageLabel addSubview:sendBtn];
    
    message                    = [[UITextView alloc] initWithFrame:CGRectMake(10, 8+1+30+8, SCREEN_BOUNDS.size.width-20, 40)];
    message.delegate           = self;
    message.layer.borderColor  = [UIColor colorWithWhite:0.798 alpha:1.000].CGColor;
    message.layer.borderWidth  = 1.f;
    message.layer.cornerRadius = 4.f;
    message.text               = @"  我要說點什麼...";
    message.font               = [UIFont fontWithName:defaultFont size:16];
    message.textColor          = [UIColor colorWithRed:0.698 green:0.698 blue:0.698 alpha:1.000];
    [messageLabel addSubview:message];
    
    sendingView = [[UIImageView alloc] initWithFrame:messageLabel.bounds];
    sendingView.hidden = YES;
    [sendingView setImage:[UIImage imageNamed:@"jc-4501.jpg"]];
    sendingView.contentMode   = UIViewContentModeScaleAspectFill;
    sendingView.clipsToBounds = YES;
    UIVisualEffect *blurEffect1;
    blurEffect1             = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *visualEffectView1;
    visualEffectView1       = [[UIVisualEffectView alloc] initWithEffect:blurEffect1];
    visualEffectView1.frame = sendingView.bounds;
    [sendingView addSubview:visualEffectView1];
    [messageLabel addSubview:sendingView];
    
    sendingText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_BOUNDS.size.width, 90)];
    sendingText.text = @"發送中...";
    sendingText.textColor = [UIColor whiteColor];
    sendingText.layer.shadowColor = [UIColor colorWithWhite:0.544 alpha:1.000].CGColor;
    sendingText.layer.shadowOffset = CGSizeMake(3.0, 3.0);
    sendingText.layer.shadowRadius = 3.0;
    sendingText.layer.shadowOpacity = 1.0;
    sendingText.textAlignment = NSTextAlignmentCenter;
    sendingText.font = [UIFont fontWithName:defaultFont size:18];
    [sendingView addSubview:sendingText];
    
    activityIndicatorView        = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeDoubleBounce tintColor:[UIColor colorWithRed:78.0/255.0 green:139.0/255.0 blue:115.0/255.0 alpha:1.000] size:30.0f];
    activityIndicatorView.frame  = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
    activityIndicatorView.center = CGPointMake(SCREEN_BOUNDS.size.width/2, (SCREEN_BOUNDS.size.height-64-49)/2);
    [self.view addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    [self getData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    bottomBtn.userInteractionEnabled = YES;
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
    bottomBtn.userInteractionEnabled = YES;
    if ([textView.text isEqualToString:@"  我要說點什麼..."]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }

    [UIView animateWithDuration:.25 animations:^{
        messageLabel.frame = CGRectMake(0, messageLabel.frame.origin.y-216, messageLabel.frame.size.width, messageLabel.frame.size.height);
    } completion:nil];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"  我要說點什麼...";
        textView.textColor = [UIColor colorWithRed:0.698 green:0.698 blue:0.698 alpha:1.000];
    }

    [UIView animateWithDuration:.25 animations:^{
        messageLabel.frame = CGRectMake(0, messageLabel.frame.origin.y+216, messageLabel.frame.size.width, messageLabel.frame.size.height);
    } completion:nil];
}

- (void)dissmissKeyboard
{
    [userName resignFirstResponder];
    [message resignFirstResponder];
    bottomBtn.userInteractionEnabled = NO;
}

- (void)getData
{
    PFQuery *query = [PFQuery queryWithClassName:@"MessageObject"];
    [query whereKey:@"feedid" equalTo:feedId];
    [query setLimit:1000];
    [query setSkip:0];
    [query orderByAscending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            messageList = [[NSMutableArray alloc] init];
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
                NSDictionary *objectDic = @{@"id":object.objectId,
                                            @"username":object[@"username"],
                                            @"description":object[@"description"],
                                            @"usertoken":object[@"usertoken"],
                                            @"createdat":object.createdAt
                                            };
                [messageList addObject:objectDic];
            }
            
            [messageTableView reloadData];

        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        if(isSending){
            [self restView];
            if (_messageDelegate && [_messageDelegate respondsToSelector:@selector(refreshMessageCount:)] ){
                
                [_messageDelegate refreshMessageCount:[messageList count]];
            }
        }
        [activityIndicatorView stopAnimating];
    }];

}

- (void)restView{
    message.text = @"  我要說點什麼...";
    message.textColor = [UIColor colorWithRed:0.698 green:0.698 blue:0.698 alpha:1.000];
    userName.text = [[PMUtility sharedInstance] userName];
    [sendBtn setTitle:@"發送" forState:UIControlStateNormal];
    sendBtn.userInteractionEnabled = YES;
    [message resignFirstResponder];
    [userName resignFirstResponder];
    [UIView animateWithDuration:.25 animations:^{
        sendingView.alpha = 0.0;
    } completion:^(BOOL finished) {
        sendingView.hidden = YES;
    }];
//    CGFloat yOffset = 0;
//    
//    if (messageTableView.contentSize.height > messageTableView.bounds.size.height) {
//        yOffset = messageTableView.contentSize.height - messageTableView.bounds.size.height;
//    }
//    
//    [messageTableView setContentOffset:CGPointMake(0, yOffset) animated:YES];
    isSending = NO;
}

- (void)sendMessage
{
    if([message.text isEqualToString:@"  我要說點什麼..."]){
        message.text = @"";
    }
    if([message.text isEqualToString:@""] || [userName.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"請填入您的暱稱以及想要說的話唷～"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"確認", nil];
        
        [alert show];
        return;
    }
    [UIView animateWithDuration:.5 animations:^{
        sendingView.alpha = 1.0;
    } completion:^(BOOL finished) {
        sendingView.hidden = NO;
    }];
    
    [sendBtn setTitle:@"發送中" forState:UIControlStateNormal];
    sendBtn.userInteractionEnabled = NO;
    
    PFObject *postObject = [PFObject objectWithClassName:@"MessageObject"];
    postObject[@"feedid"] = feedId;
    postObject[@"username"] = userName.text;
    postObject[@"description"] = message.text;
    postObject[@"usertoken"] = [[PMUtility sharedInstance] userToken];
    [postObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if(succeeded){
            PFQuery *query = [PFQuery queryWithClassName:@"PostObject"];
            [query getObjectInBackgroundWithId:feedId
                                         block:^(PFObject *postObject, NSError *error) {
                                             [postObject incrementKey:@"messagecount"];
                                             [postObject saveInBackground];
                                        }];
            [[PMUtility sharedInstance] updateUserName:userName.text];
            isSending = YES;
            [self getData];
            
        }else{
            [sendBtn setTitle:@"發送" forState:UIControlStateNormal];

        }
        
    }];
    
}

#pragma mark - UITableViewDataSourece
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; //optional
//{
//    return <#NSInteger#>;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [messageList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"PMMessageCell";
    PMMessageCell *cell = [messageTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSArray *nib        = [[NSBundle mainBundle] loadNibNamed:@"PMMessageCell" owner:self options:nil];
        cell                = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    [cell setContent:[messageList objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //code
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight = [[NSString circulateLabelHeight:[[messageList objectAtIndex:indexPath.row] objectForKey:@"description"] labelWidth:SCREEN_BOUNDS.size.width-20 labelFont:[UIFont fontWithName:defaultFont size:16]] floatValue];
    if(cellHeight > 0){
        return cellHeight+30+1;
    }else{
        return 51;
    }
    
    
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 51.;
//}
@end
