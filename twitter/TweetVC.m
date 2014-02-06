//
//  TweetVC.m
//  twitter
//
//  Created by Jenny Kwan on 2/3/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "TweetVC.h"
#import "NewVC.h"

@interface TweetVC ()
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

- (IBAction)onReply:(id)sender;
- (IBAction)onRetweet:(id)sender;
- (IBAction)onFavorite:(id)sender;

- (void)onReplyButton;
@end

@implementation TweetVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Tweet";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reply" style:UIBarButtonItemStylePlain target:self action:@selector(onReplyButton)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.nameLabel.text = self.tweet.name;
    self.handleLabel.text = [NSString stringWithFormat:@"@%@",self.tweet.screen_name];
    [self.profilePic setImageWithURL:[NSURL URLWithString:self.tweet.picURL]];
    self.tweetLabel.text = self.tweet.text;
    self.dateLabel.text = [self.tweet longDate];
    self.retweetLabel.text = [NSString stringWithFormat:@"%d",self.tweet.numRetweets];
    self.favoriteLabel.text = [NSString stringWithFormat:@"%d",self.tweet.numFavorites];
    if (self.tweet.isFavorite)
        self.favoriteButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    if (self.tweet.isRetweet)
        self.retweetButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        [self.delegate reloadTwitterData];
    }
    [super viewWillDisappear:animated];
}

- (IBAction)onReply:(id)sender
{
    [self onReplyButton];
}

- (IBAction)onRetweet:(id)sender {
    if (self.tweet.isRetweet) { //self.retweetButton.titleLabel.font == [UIFont boldSystemFontOfSize:15.0f]) {
        [self.tweet onRetweet];
        if (!self.tweet.isRetweet)
            self.retweetButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        self.retweetLabel.text = [NSString stringWithFormat:@"%d",self.tweet.numRetweets];

    } else {
        [self.tweet onRetweet];
        if (self.tweet.isRetweet)
            self.retweetButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        self.retweetLabel.text = [NSString stringWithFormat:@"%d",self.tweet.numRetweets];
    }
}

- (IBAction)onFavorite:(id)sender {
    if (self.tweet.isFavorite) { //self.favoriteButton.titleLabel.font == [UIFont boldSystemFontOfSize:15.0f]) {
        [self.tweet onFavorite];
        if (!self.tweet.isFavorite)
            self.favoriteButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        self.favoriteLabel.text = [NSString stringWithFormat:@"%d",self.tweet.numFavorites];


    } else {
        [self.tweet onFavorite];
        if (self.tweet.isFavorite)
            self.favoriteButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        self.favoriteLabel.text = [NSString stringWithFormat:@"%d",self.tweet.numFavorites];
    }
}

- (void)onReplyButton
{
    NewVC *replyVC = [[NewVC alloc] init];
    replyVC.replyText = [NSString stringWithFormat:@"@%@ ", self.tweet.screen_name];
    replyVC.replyID = [NSString stringWithFormat:@"%@", self.tweet.numID];
    [self.navigationController pushViewController:replyVC animated:YES];
}

@end
