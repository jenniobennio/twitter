//
//  Tweet.m
//  twitter
//
//  Created by Timothy Lee on 8/5/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (NSString *)text {
    return [self.data valueOrNilForKeyPath:@"text"];
}

- (NSString *)name {
    return [[self.data valueOrNilForKeyPath:@"user"] valueOrNilForKeyPath:@"name"];
}

- (NSString *)screen_name {
    return [[self.data valueOrNilForKeyPath:@"user"] valueOrNilForKeyPath:@"screen_name"];
}

- (NSString *)picURL {
    return [[self.data valueOrNilForKeyPath:@"user"] valueOrNilForKeyPath:@"profile_image_url"];
}

- (NSString *)numID {
    return [self.data valueOrNilForKeyPath:@"id_str"];
}

- (NSString *)createdDate {
    return [self.data valueOrNilForKeyPath:@"created_at"];
}

- (NSString *)origName {
    NSDictionary *retweeterInfo = [[self.data valueOrNilForKeyPath:@"retweeted_status"] valueOrNilForKeyPath:@"user"];
    return [retweeterInfo valueOrNilForKeyPath:@"name"];
}

- (NSString *)origHandle {
    NSDictionary *retweeterInfo = [[self.data valueOrNilForKeyPath:@"retweeted_status"] valueOrNilForKeyPath:@"user"];
    return [retweeterInfo valueOrNilForKeyPath:@"screen_name"];
}

- (NSString *)formattedDate {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [format setDateFormat:@"EEE MMM dd HH:mm:ss Z y"];
    NSDate *tweetCreateDate = [format dateFromString:self.createdDate];
    NSTimeInterval timeSinceDate = [[NSDate date] timeIntervalSinceDate:tweetCreateDate];
    
    // print up to 24 hours as a relative offset
    if(timeSinceDate < 24.0 * 60.0 * 60.0)
    {
        int hoursSinceDate = (int)(timeSinceDate / (60.0 * 60.0));
        
        switch(hoursSinceDate)
        {
            default: return [NSString stringWithFormat:@"%dh", hoursSinceDate];
            case 1: return @"1h";
            case 0: {
                int minutesSinceDate = (int)(timeSinceDate / 60.0);
                return [NSString stringWithFormat:@"%dm", minutesSinceDate];
                break;
            }
        }
    }
    else
    {
        /* normal NSDateFormatter stuff here */
        [format setDateFormat:@"M/d/yy"];
        return [format stringFromDate:tweetCreateDate];
    }
}

- (NSString *)longDate {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"EEE MMM dd HH:mm:ss Z y"];
    NSDate *tweetCreateDate = [format dateFromString:self.createdDate];
    
    [format setDateFormat:@"M/d/yy, hh:mm a"];
    return [format stringFromDate:tweetCreateDate];
}

- (int)numRetweets {
    if (!_numRetweets)
        _numRetweets = [[self.data valueOrNilForKeyPath:@"retweet_count"] intValue];
    return _numRetweets;
}
- (void)setNumRetweets:(int)numRetweets {
    _numRetweets = numRetweets;
}

- (BOOL)isRetweet {
    if (!_isRetweet)
        _isRetweet = [[self.data valueOrNilForKeyPath:@"retweeted"] boolValue];
    return _isRetweet;
}
- (void)setIsRetweet:(BOOL)isRetweet {
    _isRetweet = isRetweet;
}

- (int)numFavorites {
    if (!_numFavorites)
        _numFavorites = [[self.data valueOrNilForKeyPath:@"favorite_count"] intValue];
    return _numFavorites;
}
- (void)setNumFavorites:(int)numFavorites {
    _numFavorites = numFavorites;
}

- (BOOL)isFavorite {
    if (!_isFavorite)
        _isFavorite = [[self.data valueOrNilForKeyPath:@"favorited"] boolValue];
    return _isFavorite;
}
- (void)setIsFavorite:(BOOL)isFavorite {
    _isFavorite = isFavorite;
}

- (void)onRetweet {
    TwitterClient *client = [TwitterClient instance];

    if (self.isRetweet) {
        self.isRetweet = NO;
        self.numRetweets--;
        
        /*if (!self.retweetID)
            self.retweetID = self.numID;*/
        
        [client postPath:[NSString stringWithFormat:@"1.1/statuses/destroy/%@.json", self.retweetID] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Un-Retweet");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@ %@", error, operation);
            self.isRetweet = YES;
            self.numRetweets++;
        }];
    } else {
        self.isRetweet = YES;
        self.numRetweets++;
        
        [client postPath:[NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", self.numID] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.retweetID = [responseObject valueOrNilForKeyPath:@"id_str"];
            NSLog(@"Retweet");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@ %@", error, operation);
            self.isRetweet = NO;
            self.numRetweets--;
        }];
    }
    
    NSLog(@"Retweet details: %d %d", self.isRetweet, self.numRetweets);
}

- (void)onFavorite {
    TwitterClient *client = [TwitterClient instance];
    id params = @{ @"id": self.numID };
    
    if (self.isFavorite) {
        self.isFavorite = NO;
        self.numFavorites--;

        [client postPath:@"1.1/favorites/destroy.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Un-Favorite");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@ %@", error, operation);
            self.isFavorite = YES;
            self.numFavorites++;
        }];
    } else {
        self.isFavorite = YES;
        self.numFavorites++;

        [client postPath:@"1.1/favorites/create.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Favorite");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@ %@", error, operation);
            self.isFavorite = NO;
            self.numFavorites--;
        }];
    }
    
    NSLog(@"Favorite details: %d %d", self.isFavorite, self.numFavorites);
}


+ (NSMutableArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (NSDictionary *params in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:params]];
    }
    return tweets;
}

@end
