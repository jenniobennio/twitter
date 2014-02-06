//
//  NewVC.m
//  twitter
//
//  Created by Jenny Kwan on 2/3/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "NewVC.h"

@interface NewVC ()

@property (nonatomic, strong) User *me;

- (void)onCancelButton;
- (void)onTweetButton;
@end

@implementation NewVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(onTweetButton)];
    
    self.charLeftCount.text = [NSString stringWithFormat:@"%d", 140];
    self.tweet.text = self.replyText;
    self.tweet.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.me = [User currentUser];
    [self.profilePic setImageWithURL:[NSURL URLWithString: self.me.profilePic]];
    self.name.text = self.me.name;
    self.handle.text = [NSString stringWithFormat:@"@%@", self.me.handle];
    
    [self.tweet becomeFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self onTweetButton];
    }
    if (textView.text.length + (text.length - range.length) <= 140) {
        self.charLeftCount.textColor = [UIColor lightGrayColor];
        return YES;
    } else {
        self.charLeftCount.textColor = [UIColor redColor];
        return NO;
    }
    return textView.text.length + (text.length - range.length) <= 140;
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.charLeftCount.text = [NSString stringWithFormat:@"%d", 140-textView.text.length];
}


- (void)textViewDidChange:(UITextView *)textView
{
    self.charLeftCount.text = [NSString stringWithFormat:@"%d", 140-textView.text.length];
}

- (void)onCancelButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onTweetButton
{
    [self.view endEditing:YES];
    TwitterClient *client = [TwitterClient instance];
    
    id params;
    if (self.replyText)
        params = @{ @"status": self.tweet.text , @"in_reply_to_status_id": self.replyID};
    else
        params = @{ @"status": self.tweet.text};

    
    [client postPath:@"https://api.twitter.com/1.1/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Published tweet");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    

    [self.navigationController popViewControllerAnimated:YES];
}
@end
