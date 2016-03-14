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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
