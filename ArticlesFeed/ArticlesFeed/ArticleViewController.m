//
//  ArticleViewController.m
//  ArticlesFeed
//
//  Created by Rafael Scarduelli on 13/03/16.
//  Copyright © 2016 rafascar. All rights reserved.
//

#import "ArticleViewController.h"

@interface ArticleViewController ()

@end

@implementation ArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Add mark/unmark as read button to navigation bar
    UIBarButtonItem *readButton = [[UIBarButtonItem alloc] initWithTitle:@"Unmark as Read" style:UIBarButtonItemStylePlain target:self action:@selector(didPressReadButton:)];
    NSArray *possibleTitles = @[@"Mark as Read", @"Unmark as Read"];
    readButton.possibleTitles = [NSSet setWithArray:possibleTitles];
    self.navigationItem.rightBarButtonItem = readButton;
}

- (void)viewWillAppear:(BOOL)animated
{
    // Populate views with article received
    self.titleLabel.text = self.article.title;
    self.dateLabel.text = self.article.date;
    self.authorsLabel.text = self.article.authors;
    self.websiteLabel.text = self.article.website;
    self.contentLabel.text = self.article.content;
    
    if([self.article.image isKindOfClass:[NSNull class]])
        self.imageImageView.image = [UIImage imageNamed:@"image-placeholder"];
    else
        [self.imageImageView sd_setImageWithURL:[NSURL URLWithString:self.article.image] placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
    
    // Animate readImageView movement
    [UIView animateWithDuration:0.5
                     animations:^{
                         // Show readImageView
                         self.readImageView.hidden = NO;
                         // Set constraint to go down
                         self.readImageViewBottomConstraint.constant = -123;
                         [self.view layoutIfNeeded];
                     }];
}

- (void)viewDidLayoutSubviews
{
    // Set ScrollView content size dynamically
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.authorsLabel.frame.origin.y + self.authorsLabel.frame.size.height + 20);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didPressReadButton:(id)sender
{
    [self.view layoutIfNeeded];
 
    // Disable button until animation is completed
    
    // Check if article is marked as read
    if(self.article.read)
    {
        // Change button title to Mark as read
        self.navigationItem.rightBarButtonItem.title = @"Mark as Read";
        // Animate readImageView movement
        [UIView animateWithDuration:0.5
                         animations:^{
                             // Set constraint to go up
                             self.readImageViewBottomConstraint.constant = 0;
                             [self.view layoutIfNeeded];
                         }
                         completion:^(BOOL finished) {
                             // Hide readImageView after animation
                             self.readImageView.hidden = YES;
                         }];
    }
    else
    {
        // Change button title to Mark as Unread
        self.navigationItem.rightBarButtonItem.title = @"Unmark as Read";
        // Animate readImageView movement
        [UIView animateWithDuration:0.5
                         animations:^{
                             // Show readImageView
                             self.readImageView.hidden = NO;
                             // Set constraint to go down
                             self.readImageViewBottomConstraint.constant = -123;
                             [self.view layoutIfNeeded];
                         }];
    }
    
    // Update constraints
    [self updateViewConstraints];
    
    // Mark/Unmark article as read
    self.article.read = !self.article.read;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
