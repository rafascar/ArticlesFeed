//
//  Article.m
//  ArticlesFeed
//
//  Created by Rafael Scarduelli on 13/03/16.
//  Copyright © 2016 rafascar. All rights reserved.
//


#import "Article.h"

@implementation Article

// Initialize with the convenience initializer using default values
- (id)init
{
    self = [self initWithTitle:@"Title"
                       website:@"Website"
                       authors:@"Authors"
                          date:@"Date"
                       content:@"Content"
                         image:@"Image"];
    
    return self;
}

// Convenience initializer
- (id)initWithTitle:(NSString *)aTitle
            website:(NSString *)aWebsite
            authors:(NSString *)anAuthor
               date:(NSString *)aDate
            content:(NSString *)aContent
              image:(NSString *)anImage
{
    self = [super init];
    
    self.title = aTitle;
    self.website = aWebsite;
    self.authors = anAuthor;
    self.date = aDate;
    self.content = aContent;
    self.image = anImage;
    self.read = NO;
    
    return self;
}

@end
