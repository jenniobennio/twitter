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

- (NSString *)createdDate {
    return [self.data valueOrNilForKeyPath:@"created_at"];
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
                /* etc, etc */
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
    _numRetweets = [[self.data valueOrNilForKeyPath:@"retweet_count"] intValue];
    return _numRetweets;
}
- (void)setNumRetweets:(int)numRetweets {
    _numRetweets = numRetweets;
}

- (BOOL)isRetweet {
    _isRetweet = [[self.data valueOrNilForKeyPath:@"retweeted"] boolValue];
    return _isRetweet;
}
- (void)setIsRetweet:(BOOL)value {
    _isRetweet = value;
}

- (int)numFavorites {
    _numFavorites = [[self.data valueOrNilForKeyPath:@"favorite_count"] intValue];
    return _numFavorites;
}
- (void)setNumFavorites:(int)numFavorites {
    _numFavorites = numFavorites;
}

- (BOOL)isFavorite {
    _isFavorite = [[self.data valueOrNilForKeyPath:@"favorited"] boolValue];
    return _isFavorite;
}
- (void)setIsFavorite:(BOOL)value {
    _isFavorite = value;
}

- (void)onRetweet:(BOOL)retweet {
    TwitterClient *client = [TwitterClient instance];

    if (retweet) {
        _isRetweet = NO;
        _numRetweets--;
        
        [client postPath:[NSString stringWithFormat:@"1.1/statuses/destroy/%@.json", self.retweetID] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Un-Retweet");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@ %@", error, operation);
            _isRetweet = YES;
            _numRetweets++;
        }];
    } else {
        _isRetweet = YES;
        _numRetweets++;
        
        [client postPath:[NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", self.numID] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.retweetID = [NSString stringWithFormat:@"%@", [responseObject valueOrNilForKeyPath:@"id_str"]];
            NSLog(@"Retweet");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@ %@", error, operation);
            _isRetweet = NO;
            _numRetweets--;
        }];
        
    }
}

- (void)onFavorite:(BOOL)favorite {
    TwitterClient *client = [TwitterClient instance];
    id params = @{ @"id": self.numID };
    
    if (favorite) {
        _isFavorite = NO;
        _numFavorites--;

        [client postPath:@"1.1/favorites/destroy.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Un-Favorite");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@ %@", error, operation);
            _isFavorite = YES;
            _numFavorites++;
        }];
    } else {
        _isFavorite = YES;
        _numFavorites++;

        [client postPath:@"1.1/favorites/create.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Favorite");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@ %@", error, operation);
            _isFavorite = NO;
            _numFavorites--;
        }];
        
    }

}

- (NSNumber *)numID {
    return [self.data valueOrNilForKeyPath:@"id_str"];
}

+ (NSMutableArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (NSDictionary *params in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:params]];
    }
    return tweets;
}

@end
