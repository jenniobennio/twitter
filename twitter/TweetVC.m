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

- (IBAction)onReply:(id)sender
{
    [self onReplyButton];
}

- (IBAction)onRetweet:(id)sender {
    if (self.retweetButton.titleLabel.font == [UIFont boldSystemFontOfSize:15.0f]) {
        self.retweetButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [self.tweet onRetweet:YES];
        if (self.tweet.isRetweet)
            self.retweetLabel.text = [NSString stringWithFormat:@"%d",self.tweet.numRetweets-1];
        else
            self.retweetLabel.text = [NSString stringWithFormat:@"%d",self.tweet.numRetweets];
        self.retweetLabel.text = [NSString stringWithFormat:@"%d",self.tweet.numRetweets];

    } else {
        self.retweetButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        [self.tweet onRetweet:NO];
        if (self.tweet.isRetweet)
            self.retweetLabel.text = [NSString stringWithFormat:@"%d",self.tweet.numRetweets];
        else
            self.retweetLabel.text = [NSString stringWithFormat:@"%d",self.tweet.numRetweets+1];
        self.retweetLabel.text = [NSString stringWithFormat:@"%d",self.tweet.numRetweets];

    }
}

- (IBAction)onFavorite:(id)sender {
    if (self.favoriteButton.titleLabel.font == [UIFont boldSystemFontOfSize:15.0f]) {
        self.favoriteButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [self.tweet onFavorite:YES];
        if (self.tweet.isFavorite)
            self.favoriteLabel.text = [NSString stringWithFormat:@"%d",self.tweet.numFavorites-1];
        else
            self.favoriteLabel.text = [NSString stringWithFormat:@"%d",self.tweet.numFavorites];

    } else {
        self.favoriteButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        [self.tweet onFavorite:NO];
        if (self.tweet.isFavorite)
            self.favoriteLabel.text = [NSString stringWithFormat:@"%d",self.tweet.numFavorites];
        else
            self.favoriteLabel.text = [NSString stringWithFormat:@"%d",self.tweet.numFavorites+1];
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
