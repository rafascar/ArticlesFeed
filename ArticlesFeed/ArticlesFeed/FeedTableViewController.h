//
//  FeedTableViewController.h
//  ArticlesFeed
//
//  Created by Rafael Scarduelli on 13/03/16.
//  Copyright © 2016 rafascar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>

#import "Article.h"
#import "ArticleTableViewCell.h"
#import "ArticleViewController.h"

@interface FeedTableViewController : UITableViewController

// Enumeration with sort options (date, title, author, website)
typedef enum
{
    SortTypeDate = 0,
    SortTypeTitle = 1,
    SortTypeAuthor = 2,
    SortTypeWebsite = 3
} SortType;

- (void)didPressSortButton:(id)sender;
- (void)sortArticlesBy:(SortType)sortType;

@end
