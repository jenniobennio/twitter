//
//  TimelineVC.m
//  twitter
//
//  Created by Timothy Lee on 8/4/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import "TimelineVC.h"
#import "TweetCell.h"
#import "TweetVC.h"
#import "Tweet.h"
#import "NewVC.h"

@interface TimelineVC () <TweetVCDelegate>

@property (nonatomic, strong) NSMutableArray *tweets;

- (void)onSignOutButton;
- (void)onNewButton;
- (void)reload;
- (void)refreshMe:(UIRefreshControl *)refresh;
- (CGFloat)textViewHeightForAttributedText: (NSAttributedString*)text andWidth: (CGFloat)width;

@end

@implementation TimelineVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Home";
        
        // [self reload];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onSignOutButton)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(onNewButton)];

    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to refresh"];
    [refresh addTarget:self action:@selector(refreshMe:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    [self reload];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // [self reload];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweets.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tweet *tweet = self.tweets[indexPath.row];
    CGFloat height = [self textViewHeightForAttributedText:[[NSAttributedString alloc] initWithString:tweet.text] andWidth:240];
    if (height > 0) {
        // Add more space if it was re-tweeted
        if (tweet.origName)
            return height + 70;
        else
            return height + 50;
    } else
        return 100;
}

- (CGFloat)textViewHeightForAttributedText: (NSAttributedString*)text andWidth: (CGFloat)width {
    UITextView *calculationView = [[UITextView alloc] init];
    [calculationView setAttributedText:text];
    CGSize size = [calculationView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TweetCell";
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Tweet *tweet = self.tweets[indexPath.row];
    
    cell.tweet = tweet;
    cell.tweetLabel.text = tweet.text;
    [cell.profilePic setImageWithURL:[NSURL URLWithString:tweet.picURL]];
    cell.timeLabel.text = [tweet formattedDate];
    
    NSString *origName = tweet.origName;
    if (origName) {
        cell.retweetLabel.text = [NSString stringWithFormat:@"@%@ retweeted", tweet.screen_name];
        cell.nameLabel.text = tweet.origName;
        cell.handleLabel.text = [NSString stringWithFormat:@"@%@", tweet.origHandle];
    }
    else {
        cell.retweetLabel.text = @"";
        cell.nameLabel.text = tweet.name;
        cell.handleLabel.text = [NSString stringWithFormat:@"@%@", tweet.screen_name];
    }
    
    // These are not in the User Stories, so do later
    // cell.replyButton.hidden = YES;
    cell.replyButton.tag = indexPath.row;
    [cell.replyButton addTarget:self action:@selector(onReplyButton:) forControlEvents:UIControlEventTouchUpInside];
    
    // cell.favoriteButton.hidden = YES;
    if (tweet.isFavorite)
        cell.favoriteButton.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    else
        cell.favoriteButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    
    // cell.retweetButton.hidden = YES;
    if (tweet.isRetweet)
        cell.retweetButton.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    else
        cell.retweetButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    
    // Infinite loading
    /*TwitterClient *client
    if (indexPath.row > (self.tweets.count - 5)) {
	}*/
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TweetVC *tweetVC = [[TweetVC alloc] initWithNibName:@"TweetVC" bundle:nil];
    tweetVC.tweet = [self.tweets objectAtIndex:indexPath.row];
    tweetVC.delegate = self;
    [self.navigationController pushViewController:tweetVC animated:YES];
    
}

#pragma mark - TweetVCDelegate
- (void)reloadTwitterData {
    [self reload];
}

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

#pragma mark - Private methods

- (void)onSignOutButton {
    [User setCurrentUser:nil];
}

- (void)onNewButton {
    NewVC *newVC = [[NewVC alloc] init];
    [self.navigationController pushViewController:newVC animated:YES];
}

- (void)onReplyButton:(UIButton *) sender
{
    NewVC *replyVC = [[NewVC alloc] init];
    Tweet *tweet = self.tweets[sender.tag];
    replyVC.replyText = [NSString stringWithFormat:@"@%@ ", tweet.screen_name];
    replyVC.replyID = [NSString stringWithFormat:@"%@", tweet.numID];
    [self.navigationController pushViewController:replyVC animated:YES];
}

- (void)reload {
    [[TwitterClient instance] homeTimelineWithCount:20 sinceId:0 maxId:0 success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"%@", response);
        self.tweets = [Tweet tweetsWithArray:response];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Do nothing
        NSLog(@"ERROR: %@", error);
    }];
}

- (void) refreshMe: (UIRefreshControl *)refresh;{
    [self reload];
    
    [refresh endRefreshing];
}


@end
