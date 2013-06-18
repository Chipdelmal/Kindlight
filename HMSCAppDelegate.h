//
//  HMSCAppDelegate.h
//  Kindlight
//
//  Created by Hector Sanchez on 10/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Highlight.h"
#import "File.h"

@interface HMSCAppDelegate : NSObject <NSApplicationDelegate>
{
    NSArray         *highlightsStrings;         //Highlight Blocks unprocessed
    NSMutableArray  *highlightsProcessed;       //Highlight Blocks separated (Highlight Objects Array)
    NSMutableArray  *filesArray;
}
-(void)createFiles;
-(void)writeFileWithName:(NSString *)name andWithContents:(NSString *)contents;
-(void)getContentsFromFile;
-(void)extractData:(NSString *)rawHighlight;
-(NSDate *)extractDate:(NSArray *)dateArray withIndex:(int)objectIndex;
-(NSString *)convertMonth:(NSString *)monthString;
-(int)extractPageOrLocation:(NSArray *)arrayToExtract withIndex:(int)objectIndex andPlace:(int)place;
-(NSString *)authorExtract:(NSArray *)authorAndBookArray;
-(NSString *)bookExtract:(NSArray *)authorAndBookArray;
-(void)pageLocationDateExtract:(NSString *)spaceTimeString withHighlight:(Highlight *)processingHighlight;
-(NSString *)reverseString:(NSString*)string;

-(IBAction)startProcessing:(id)sender;

@property (strong) NSArray *highlightsStrings;
@property (strong) NSMutableArray *highlightsProcessed;
@property (strong) NSMutableArray *filesArray;
@property (assign) IBOutlet NSWindow *window;
@end
