//
//  Tweet.h
//  twitter
//
//  Created by Timothy Lee on 8/5/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : RestObject {
    BOOL _isRetweet;
    BOOL _isFavorite;
    int _numRetweets;
    int _numFavorites;
}

@property (nonatomic, strong, readonly) NSString *text;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *screen_name;
@property (nonatomic, strong, readonly) NSString *picURL;
@property (nonatomic, strong, readonly) NSString *createdDate;
@property (nonatomic, strong, readonly) NSString *numID;
@property (nonatomic, strong) NSString *retweetID;
@property (nonatomic, strong) NSString *origName;
@property (nonatomic, strong) NSString *origHandle;

+ (NSMutableArray *)tweetsWithArray:(NSArray *)array;
- (NSString *)formattedDate;
- (NSString *)longDate;

- (void)onRetweet;
- (void)onFavorite;

- (BOOL) isRetweet;
- (void)setIsRetweet:(BOOL)isRetweet;
- (BOOL) isFavorite;
- (void)setIsFavorite:(BOOL)isFavorite;

- (int) numRetweets;
- (void)setNumRetweets:(int)numRetweets;
- (int) numFavorites;
- (void)setNumFavorites:(int)numFavorites;
@end
