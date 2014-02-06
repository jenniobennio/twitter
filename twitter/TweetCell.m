//
//  TweetCell.m
//  twitter
//
//  Created by Timothy Lee on 8/6/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import "TweetCell.h"
#import "Tweet.h"
#import "NewVC.h"

@implementation TweetCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onReplyButton:(id)sender {
    NSLog(@"Reply");
}

- (IBAction)onRetweetButton:(id)sender {
    [self.tweet onRetweet];
    if (!self.tweet.isRetweet) {  //self.retweetButton.titleLabel.font == [UIFont boldSystemFontOfSize:12.0f]) {
        self.retweetButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    else {
        self.retweetButton.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    }
    
}

- (IBAction)onFavoriteButton:(id)sender {
    [self.tweet onFavorite];
    if (!self.tweet.isFavorite) { //self.favoriteButton.titleLabel.font == [UIFont boldSystemFontOfSize:12.0f]) {
        self.favoriteButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    else {
        self.favoriteButton.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    }
}
@end
