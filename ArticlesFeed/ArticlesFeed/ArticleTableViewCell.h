//
//  ArticleTableViewCell.h
//  ArticlesFeed
//
//  Created by Rafael Scarduelli on 13/03/16.
//  Copyright © 2016 rafascar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MGSwipeTableCell.h>

@interface ArticleTableViewCell : MGSwipeTableCell

@property (weak, nonatomic) IBOutlet UIImageView *imageImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorsLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *websiteLabel;
@property (weak, nonatomic) IBOutlet UIImageView *readImageView;
@property (weak, nonatomic) IBOutlet UIView *view;

@property BOOL markAsRead;

@end
