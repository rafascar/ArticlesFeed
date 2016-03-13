//
//  Article.h
//  ArticlesFeed
//
//  Created by Rafael Scarduelli on 13/03/16.
//  Copyright © 2016 rafascar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Article : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *website;
@property (strong, nonatomic) NSString *authors;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *image;

- (id)initWithTitle:(NSString *)aTitle
            website:(NSString *)aWebsite
            authors:(NSString *)anAuthor
               date:(NSString *)aDate
            content:(NSString *)aContent
              image:(NSString *)anImage;

@end
