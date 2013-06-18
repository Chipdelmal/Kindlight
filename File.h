//
//  File.h
//  Kindlight
//
//  Created by Hector Sanchez on 11/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface File : NSObject
{
    NSMutableString *fileName;
    NSMutableString *fileContents;
    NSString        *bookTitle;
    NSString        *authorName;
}
@property (strong) NSMutableString *fileName;
@property (strong) NSMutableString *fileContents;
@property (strong) NSString *bookTitle;
@property (strong) NSString *authorName;

@end
