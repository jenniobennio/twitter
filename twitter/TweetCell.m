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
#import "UIImage+mask.h"

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
    if (!self.tweet.isRetweet) {
        [self.retweetButton setImage:[UIImage imageNamed:@"02-redo.png"] forState:UIControlStateNormal];
    }
    else {
        [self.retweetButton setImage:[self.retweetButton.imageView.image maskWithColor:[UIColor blueColor]] forState:UIControlStateNormal];
    }
    
}

- (IBAction)onFavoriteButton:(id)sender {
    [self.tweet onFavorite];
    if (!self.tweet.isFavorite) {
        [self.favoriteButton setImage:[UIImage imageNamed:@"28-star.png"] forState:UIControlStateNormal];
    }
    else {
        [self.favoriteButton setImage:[self.favoriteButton.imageView.image maskWithColor:[UIColor yellowColor]] forState:UIControlStateNormal];
    }
}
@end
