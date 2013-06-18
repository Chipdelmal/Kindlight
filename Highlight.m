//
//  Highlight.m
//  Kindlight
//
//  Created by Hector Sanchez on 10/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Highlight.h"

@implementation Highlight
@synthesize textHighlight, date, author, book, type, startLocation, stopLocation, page, highlightSections;

- (NSString *)description
{
    return [NSString stringWithFormat:@"<Author: %@, Book: %@, Highlight: %@, Page: %d, Location: %d, Date: %@>",
            [self author],
            [self book],
            [self textHighlight],
            [self page],
            [self startLocation],
            [self date]];
}


@end
