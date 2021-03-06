//
//  FeedTableViewController.m
//  ArticlesFeed
//
//  Created by Rafael Scarduelli on 13/03/16.
//  Copyright © 2016 rafascar. All rights reserved.
//

#import "FeedTableViewController.h"

@interface FeedTableViewController () <UINavigationControllerDelegate, MGSwipeTableCellDelegate>

// Array of articles
@property (strong, nonatomic) NSArray *articles;

@end

@implementation FeedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set navigation bar title
    self.title = @"FEED";
    
    // Set Navigation Controller Delegate to self
    self.navigationController.delegate = self;
    
    // Add sort button to the navigation bar
    UIBarButtonItem *sortButton = [[UIBarButtonItem alloc] initWithTitle:@"Sort" style:UIBarButtonItemStylePlain target:self action:@selector(didPressSortButton:)];
    self.navigationItem.rightBarButtonItem = sortButton;
    
    // Initialize the refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.refreshControl addTarget:self action:@selector(fetchArticlesFromJSON) forControlEvents:UIControlEventValueChanged];
    
    [self fetchArticlesFromJSON];
    
}

- (void)fetchArticlesFromJSON
{
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
        
        // Show alert indicating failure
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        // Show controller
        [self presentViewController:alertController animated:YES completion:nil];
    }];

    [self.refreshControl endRefreshing];
}

- (void)didPressSortButton:(id)sender
{
    // Create AlertController with sort options
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sort by:"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    // Create sort options (date:0, title:1, author:2, website:3) and cancel
    UIAlertAction* sortDateAction = [UIAlertAction actionWithTitle:@"Date" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) { [self sortArticlesBy:0]; }];
    UIAlertAction *sortTitleAction = [UIAlertAction actionWithTitle:@"Title" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) { [self sortArticlesBy:1]; }];
    UIAlertAction *sortAuthorAction = [UIAlertAction actionWithTitle:@"Author" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) { [self sortArticlesBy:2]; }];
    UIAlertAction *sortWebsiteAction = [UIAlertAction actionWithTitle:@"Website" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) { [self sortArticlesBy:3]; }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) { }];
    
    // Add sort options and cancel to the AlertController
    [alert addAction:sortDateAction];
    [alert addAction:sortTitleAction];
    [alert addAction:sortAuthorAction];
    [alert addAction:sortWebsiteAction];
    [alert addAction:cancelAction];
    
    // Present AlertController
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)sortArticlesBy:(SortType)sortType
{
    // Copy of the array of unsorted articles for the animation
    NSArray *unsortedArticles = [self.articles copy];
    
    // Sort the articles based on users choice (date, title, author, website)
    NSString *key;
    switch (sortType) {
        case SortTypeDate:
            key = @"date";
            break;
        case SortTypeTitle:
            key = @"title";
            break;
        case SortTypeAuthor:
            key = @"authors";
            break;
        case SortTypeWebsite:
            key = @"website";
            break;
    }
    // Create SortDescriptor with selected key
    NSSortDescriptor *sortDescriptor = sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    // Sort articles
    self.articles = [self.articles sortedArrayUsingDescriptors:sortDescriptors];
    
    // Prepare table for the animation batch
    [self.tableView beginUpdates];
    
    // Move the cells around
    NSInteger sourceRow = 0;
    for(NSString *article in unsortedArticles)
    {
        NSInteger destRow = [self.articles indexOfObject:article];
        
        if (destRow != sourceRow)
        {
            // Move the rows within the table view
            NSIndexPath *sourceIndexPath = [NSIndexPath indexPathForItem:sourceRow inSection:0];
            NSIndexPath *destIndexPath = [NSIndexPath indexPathForItem:destRow inSection:0];
            [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:destIndexPath];
        }
        sourceRow++;
    }
    
    // Commit animations
    [self.tableView endUpdates];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Check if articles were fetched
    if(self.articles)
    {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
        // Remove refresh control
        [self.refreshControl removeFromSuperview];
        // Remove background view
        self.tableView.backgroundView = nil;
        return 1;
    }
    else
    {
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        // Set label content and style
        messageLabel.text = @"No data is currently available. Please pull down to refresh.";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
        [messageLabel sizeToFit];
        
        // Add label to background view
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return number of articles in the list of articles
    return self.articles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
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
    
    // Set selection style
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
        [cell.imageImageView sd_setImageWithURL:[NSURL URLWithString:article.image] placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
    }
    
    // Delete swift buttons
    cell.leftButtons = nil;
    cell.rightButtons = nil;
    // Check if article is marked/unmarked as read
    if(article.read)
    {
        // Show marked as read image
        cell.readImageView.alpha = 1;
        // Add button to unmark as read
        MGSwipeButton *rightButton = [MGSwipeButton buttonWithTitle:@"Unmark \ras Read"
                                                    backgroundColor:[UIColor colorWithRed:1 green:0.455 blue:0.369 alpha:1] /*#ff745e*/
                                                           callback:^BOOL(MGSwipeTableCell *sender) {
                                                               return [self onSwipeButtonPressed:(ArticleTableViewCell *)sender]; }];
        cell.rightButtons = @[rightButton];
    }
    else
    {
        // Hide marked as read image
        cell.readImageView.alpha = 0;
        // Add button to mark as read
        MGSwipeButton *leftButton = [MGSwipeButton buttonWithTitle:@"Mark \ras Read"
                                                   backgroundColor:[UIColor colorWithRed:0.137 green:0.757 blue:1 alpha:1] /*#23c1ff*/
                                                          callback:^BOOL(MGSwipeTableCell *sender) {
                                                              return [self onSwipeButtonPressed:(ArticleTableViewCell *)sender]; }];
        cell.leftButtons = @[leftButton];
    }

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Descekect row before navigation
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Article to be passed to ArticleViewController
    ArticleViewController *articleVC = [[ArticleViewController alloc] init];
    articleVC.article = self.articles[indexPath.row];
    // Show/hide mark as read image
    Article *article = [self.articles objectAtIndex:indexPath.row];
    article.read = YES;
    articleVC.markAsRead = article.read;
    
    // Navigate to ArticleViewController
    [self.navigationController pushViewController:articleVC animated:YES];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if(viewController == self)
        // Reload data to update mark/unmark as read icons and buttons
        [self.tableView reloadData];
}

- (BOOL)onSwipeButtonPressed:(ArticleTableViewCell *)cell
{
    // Get index of selected cell
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    // Get article selected
    Article *article = [self.articles objectAtIndex:indexPath.row];

    // Mark/Unmark as read
    article.read = !article.read;
    
    // Reload data to update mark/unmark as read icons and buttons
    [self.tableView reloadData];
    
    return YES;
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
