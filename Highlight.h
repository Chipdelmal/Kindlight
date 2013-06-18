//
//  Highlight.h
//  Kindlight
//
//  Created by Hector Sanchez on 10/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Highlight : NSObject
{
    NSString    *textHighlight;
    NSDate      *date;
    NSString    *author;
    NSString    *book;
    NSString    *type;
    int         startLocation;
    int         stopLocation;
    int         page;
} 

@property (strong) NSArray  *highlightSections;
@property (strong) NSString *textHighlight;
@property (strong) NSDate   *date;
@property (strong) NSString *author;
@property (strong) NSString *book;
@property (strong) NSString *type;
@property int startLocation;
@property int stopLocation;
@property int page;

@end
