//
//  NewVC.h
//  twitter
//
//  Created by Jenny Kwan on 2/3/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+AFNetworking.h>

@interface NewVC : UIViewController <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *handle;
@property (weak, nonatomic) IBOutlet UITextView *tweet;
@property (weak, nonatomic) IBOutlet UILabel *charLeftCount;

@property (nonatomic, strong) NSString *replyText;
@property (nonatomic, strong) NSString *replyID;

@end
