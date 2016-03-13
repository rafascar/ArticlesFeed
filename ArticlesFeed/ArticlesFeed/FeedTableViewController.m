//
//  FeedTableViewController.m
//  ArticlesFeed
//
//  Created by Rafael Scarduelli on 13/03/16.
//  Copyright © 2016 rafascar. All rights reserved.
//

#import "FeedTableViewController.h"

@interface FeedTableViewController ()

// Array of articles
@property (strong, nonatomic) NSArray *articles;

@end

@implementation FeedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set navigation bar title
    self.title = @"Feed";
    
    // URL with JSON list of articles
    NSURL *URL = [NSURL URLWithString:@"https://www.ckl.io/challenge/"];
    // Fetch and parse JSON list of articles
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject){
        
        // Create temporary mutable array of articles
        NSMutableArray *articlesTemp = [[NSMutableArray alloc] init];
        // Create a new article for each article parsed from the JSON file
        for (NSDictionary *article in responseObject)
        {
            Article *newArticle = [[Article alloc] initWithTitle:article[@"title"]
                                                         website:article[@"website"]
                                                         authors:article[@"authors"]
                                                            date:article[@"date"]
                                                         content:article[@"content"]
                                                           image:article[@"image"]];
            // Add article to the temporary mutable array of articles
            [articlesTemp addObject:newArticle];
        }
        // Copy temporary mutable array of articles to the real array
        self.articles = [[NSArray alloc] initWithArray:articlesTemp];
        // Reload the TableView data
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"JSON: %@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return number of articles in the list of articles
    return self.articles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
#warning Height hardcoded, find a way to parametrize!
    // Return the height of each cell
    return 180;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Dequeue custom ArticleTableViewCell cell
    ArticleTableViewCell *cell = (ArticleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ArticleCell"];
    
    // Check if cell was successfully dequeuable
    if (cell == nil)
    {
        // Create a new custom ArticleTableViewCell cell
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"ArticleTableViewCell" owner:self options:nil];
        cell = [nibArray objectAtIndex:0];
    }
    
    // Create article that will populate the cell
    Article *article = [self.articles objectAtIndex:indexPath.row];
    
    // Populate the cell with article informations
    cell.titleLabel.text = article.title;
    cell.dateLabel.text = article.date;
    cell.authorsLabel.text = article.authors;
    cell.websiteLabel.text = article.website;
    
    // Check if article's image was specified in the JSON file
    if([article.image isKindOfClass:[NSNull class]])
    {
        cell.imageImageView.image = [UIImage imageNamed:@"image-placeholder"];
    }
    else
    {
        [cell.imageImageView setImageWithURL:[NSURL URLWithString:article.image] placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
    }
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
