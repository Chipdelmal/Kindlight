//
//  HMSCAppDelegate.m
//  Kindlight
//
//  Created by Hector Sanchez on 10/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "HMSCAppDelegate.h"

@implementation HMSCAppDelegate
@synthesize window = _window;
@synthesize highlightsStrings, highlightsProcessed, filesArray;

//Main
-(IBAction)startProcessing:(id)sender
{
    NSLog(@"Started Processing");
    if (!highlightsProcessed) {
        highlightsProcessed = [[NSMutableArray alloc] init];
    }    
    [self getContentsFromFile];
    
    for (int i=0; i<[highlightsStrings count]-1; i++) {
        [self extractData:[highlightsStrings objectAtIndex:i]];
    }

    [self createFiles];
    for (int i=1; i<[filesArray count]; i++) {
        [self writeFileWithName:[[filesArray objectAtIndex:i] fileName] andWithContents:[[filesArray objectAtIndex:i] fileContents]];
    }
}

//Classify data from current highlightString and store in highlightsProcessed array
-(void)extractData:(NSString *)rawHighlight
{
    //Create two temporary variables required for batch processing
    Highlight *tempProcessedHighlight = [[Highlight alloc] init];
    NSArray *dividedBlock = [rawHighlight componentsSeparatedByString:@"\n"];
    
    //Initialize a string variable that will be used both by authorExtract and bookExtract
    NSMutableString *reversedString = [[NSMutableString alloc] initWithString:[self reverseString:[dividedBlock objectAtIndex:1]]];
    NSArray *authorAndBook = [reversedString componentsSeparatedByString:@"("];
    //Run algorithm required for page, location and date detection
    [self pageLocationDateExtract:[dividedBlock objectAtIndex:2] withHighlight:tempProcessedHighlight];
    
    //Set highlight values
    [tempProcessedHighlight setAuthor:[self authorExtract:authorAndBook]];
    [tempProcessedHighlight setBook:[self bookExtract:authorAndBook]];
    [tempProcessedHighlight setTextHighlight:[dividedBlock objectAtIndex:4]];
    //Add Object to highlightsProcessed Array
    [highlightsProcessed addObject:tempProcessedHighlight];
    //NSLog(@"%@",tempProcessedHighlight);
}

//Detects page, location and date data and returns an array of the strings to be assigned
-(void)pageLocationDateExtract:(NSString *)spaceTimeString withHighlight:(Highlight *)processingHighlight
{
    NSArray *tempDividingArray = [spaceTimeString componentsSeparatedByString:@"|"];
    switch ([[tempDividingArray objectAtIndex:0] characterAtIndex:2]) {
        case 'H':
            //Check first element of the array if existing
            if ([tempDividingArray count]>0) {
                if ([[tempDividingArray objectAtIndex:0] characterAtIndex:12]=='o') {//First Item is a Page Number
                    [processingHighlight setPage:[self extractPageOrLocation:tempDividingArray withIndex:0 andPlace:20]];
                }else if([[tempDividingArray objectAtIndex:0] characterAtIndex:12]=='L'){//First Item is a Location
                    [processingHighlight setStartLocation:[self extractPageOrLocation:tempDividingArray withIndex:0 andPlace:17]];
                }
            }
            //Check second element of the array if existing
            if ([tempDividingArray count]>=2) {//Second Item is a Location
                if ([[tempDividingArray objectAtIndex:1] characterAtIndex:1]=='L') {//Second Item is a Location
                    [processingHighlight setStartLocation:[self extractPageOrLocation:tempDividingArray withIndex:1 andPlace:5]];
                }else if([[tempDividingArray objectAtIndex:1] characterAtIndex:1]=='A') {//Second Item is a Date
                    [processingHighlight setDate:[self extractDate:tempDividingArray withIndex:1]];
                }
            }
            //Check third element of the array if existing
            if ([tempDividingArray count]>=3) {
                [processingHighlight setDate:[self extractDate:tempDividingArray withIndex:2]];
            }
            break;
        
        case 'B':
            //Check first element of the array if existing
            if ([tempDividingArray count]>0) {
                if ([[tempDividingArray objectAtIndex:0] characterAtIndex:14]=='P') {//First Item is a Page Number
                    [processingHighlight setPage:[self extractPageOrLocation:tempDividingArray withIndex:0 andPlace:15]];
                }else if([[tempDividingArray objectAtIndex:0] characterAtIndex:11]=='L'){//First Item is a Location
                    [processingHighlight setStartLocation:[self extractPageOrLocation:tempDividingArray withIndex:0 andPlace:12]];
                }
            }
            //Check second element of the array if existing
            if ([tempDividingArray count]>=2) {//Second Item is a Location
                if ([[tempDividingArray objectAtIndex:1] characterAtIndex:1]=='L') {//Second Item is a Location
                    [processingHighlight setStartLocation:[self extractPageOrLocation:tempDividingArray withIndex:1 andPlace:5]];
                }else if([[tempDividingArray objectAtIndex:1] characterAtIndex:1]=='A') {//Second Item is a Date
                    [processingHighlight setDate:[self extractDate:tempDividingArray withIndex:1]];
                }
            }
            //Check third element of the array if existing
            if ([tempDividingArray count]>=3) {
                [processingHighlight setDate:[self extractDate:tempDividingArray withIndex:2]];
            }
            break;
            
        case 'N':
            //Check first element of the array if existing
            if ([tempDividingArray count]>0) {
                if ([[tempDividingArray objectAtIndex:0] characterAtIndex:10]=='P') {//First Item is a Page Number
                    [processingHighlight setPage:[self extractPageOrLocation:tempDividingArray withIndex:0 andPlace:15]];
                }else if([[tempDividingArray objectAtIndex:0] characterAtIndex:7]=='L'){//First Item is a Location
                    [processingHighlight setStartLocation:[self extractPageOrLocation:tempDividingArray withIndex:0 andPlace:12]];
                }
            }
            //Check second element of the array if existing
            if ([tempDividingArray count]>=2) {//Second Item is a Location
                if ([[tempDividingArray objectAtIndex:1] characterAtIndex:1]=='L') {//Second Item is a Location
                    [processingHighlight setStartLocation:[self extractPageOrLocation:tempDividingArray withIndex:1 andPlace:5]];
                }else if([[tempDividingArray objectAtIndex:1] characterAtIndex:1]=='A') {//Second Item is a Date
                    [processingHighlight setDate:[self extractDate:tempDividingArray withIndex:1]];
                }
            }
            //Check third element of the array if existing
            if ([tempDividingArray count]>=3) {
                [processingHighlight setDate:[self extractDate:tempDividingArray withIndex:2]];
            }

            break;
        default:
            break;
    }
    

}

//Extracts Date
-(NSDate *)extractDate:(NSArray *)tempDividingArray withIndex:(int)objectIndex
{
    NSArray *tempDateArray = [[tempDividingArray objectAtIndex:objectIndex] componentsSeparatedByString:@","];
    NSString *day = [[tempDateArray objectAtIndex:1] substringWithRange:NSMakeRange([[tempDateArray objectAtIndex:1] length]-2, 2)];//Extracting Day
    NSString *month = [self convertMonth:[[tempDateArray objectAtIndex:1] substringWithRange:NSMakeRange(1,[[tempDateArray objectAtIndex:1] length]-4)]];//Extracting Month
    NSString *year = [tempDateArray objectAtIndex:2];//Extracting Year
    NSString *dateStr = [[year stringByAppendingString:month] stringByAppendingString:day];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMdd"];
    return [dateFormat dateFromString:dateStr];
}

//Converts the Month to an int
-(NSString *)convertMonth:(NSString *)monthString
{
    if ([monthString isEqualToString:@"January"]) {return @"01";}
    else if ([monthString isEqualToString:@"February"]) {return @"02";}
    else if ([monthString isEqualToString:@"March"]) {return @"03";}
    else if ([monthString isEqualToString:@"April"]) {return @"04";}
    else if ([monthString isEqualToString:@"May"]) {return @"05";}
    else if ([monthString isEqualToString:@"June"]) {return @"06";}
    else if ([monthString isEqualToString:@"July"]) {return @"07";}
    else if ([monthString isEqualToString:@"August"]) {return @"08";}
    else if ([monthString isEqualToString:@"September"]) {return @"09";}
    else if ([monthString isEqualToString:@"October"]) {return @"10";}
    else if ([monthString isEqualToString:@"November"]) {return @"11";}
    else{return @"12";}
}

//Extracts the Location of a Clip
-(int)extractPageOrLocation:(NSArray *)arrayToExtract withIndex:(int)objectIndex andPlace:(int)place
{
    NSArray *location = [[[arrayToExtract objectAtIndex:objectIndex] substringWithRange:NSMakeRange(place, [[arrayToExtract objectAtIndex:objectIndex] length]-place)] componentsSeparatedByString:@"-"];
    return (int)[[location objectAtIndex:0] integerValue];    
}

//Detects the author and returns the string to be assigned
-(NSString *)authorExtract:(NSArray *)authorAndBookArray
{
    //Initialize a string with the first vale of the array sent (author's name) and delete whitespaces
    NSMutableString *tempAuthor = [[NSMutableString alloc] initWithString:[authorAndBookArray objectAtIndex:0]];
    [tempAuthor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //Delete closing parentheses in name and return "Unknown" string if the name does not exist
    if ([tempAuthor length]>1) {
        [tempAuthor deleteCharactersInRange:NSMakeRange(1,1)];
    }else{
        [tempAuthor setString:@"nwonknU"];
    }    
    return [self reverseString:tempAuthor];
}

//Detects the book and returns the string to be assigned
-(NSString *)bookExtract:(NSArray *)authorAndBookArray
{
    //Initialize a "multiple parentheses flag" and an empty string
    BOOL parenteses = FALSE;
    NSMutableString *tempBook = [[NSMutableString alloc] initWithString:@""];
    
    for(int i=1; i<[authorAndBookArray count]; i++){
        //Append every remaining section of the authorAndBookArray (other than the author's name)
        [tempBook appendString:[authorAndBookArray objectAtIndex:i]];
        //If the book's title has parentheses close "(" in every append (as every "(" was cut to obtain author's name))
        if ([authorAndBookArray count]>2) {
            [tempBook appendString:@"("];
            parenteses = TRUE;
        }
    }
    //If the title had parentheses there's an additional opening "(" at the reversed end so delete it
    if (parenteses) {
        [tempBook deleteCharactersInRange:NSMakeRange([tempBook length]-1,1)];
    }
    //Delete whitespaces in the book's name
    [tempBook stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return [self reverseString:tempBook];
}


//Auxiliary method that reverses the order of a given string
-(NSMutableString*)reverseString:(NSString*)string 
{
    NSMutableString *reversedString;
    unsigned long length = [string length];
    reversedString = [NSMutableString stringWithCapacity:length];
    
    while (length--) {
        [reversedString appendFormat:@"%C", [string characterAtIndex:length]];
    }
    return reversedString;
}

//Open file and extract contents to highlightStrings array
-(void)getContentsFromFile
{
    //My Clippings path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *directory = [paths objectAtIndex:0];
    NSString *file = [NSString stringWithFormat:@"%@/My Clippings.txt", directory];
    NSError *error = nil;
    
    //Read file and separate strings
    NSString *fullContents = [[NSString alloc] initWithContentsOfFile:file encoding:NSUTF8StringEncoding error:&error];
    highlightsStrings = [[@"\n" stringByAppendingString:fullContents] componentsSeparatedByString:@"========="];
}

//Write file
-(void)writeFileWithName:(NSString *)name andWithContents:(NSString *)contents
{
    //Documents path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/Kindlight/%@.txt", documentsDirectory,name];
    
    //Declare NSError
    NSError *error = nil;        
    
    //Write file with NSError passed by reference
    BOOL success = [contents writeToFile:fileName atomically:YES encoding:NSUTF16StringEncoding error:&error];
    
    //Log
    if (success) {
        NSLog(@"File written to:  %@", documentsDirectory);
    }else{
        NSLog(@"File not written to: %@", documentsDirectory);
    }
}

-(void)createFiles
{
    if(!filesArray){filesArray = [[NSMutableArray alloc] init];}
    File *first = [[File alloc] init];
    [first setFileContents:(NSMutableString *)@"None"];
    [first setBookTitle:@"Test"];
    [first setAuthorName:@"Me"];
    [filesArray addObject:first];
    
    BOOL matchFlag=FALSE;
    for (int i=0; i<[highlightsProcessed count]; i++) 
    {
        matchFlag = FALSE;
        for (int j=0; j<[filesArray count]; j++)
        {
            if ([[[highlightsProcessed objectAtIndex:i] book] isEqualToString:[[filesArray objectAtIndex:j] bookTitle]]) 
            {                
                [[filesArray objectAtIndex:j] setFileContents:(NSMutableString *)[[[filesArray objectAtIndex:j] fileContents] stringByAppendingFormat:@"\n\n -%@",[[highlightsProcessed objectAtIndex:i] textHighlight]]];
                matchFlag=TRUE;
            }
        }
        if (!matchFlag) 
        {
            File *tempFile = [[File alloc] init];
            [tempFile setBookTitle:[[highlightsProcessed objectAtIndex:i] book]];
            [tempFile setAuthorName:[[highlightsProcessed objectAtIndex:i] author]];
            [tempFile setFileContents:(NSMutableString *)[@" -" stringByAppendingString:[[highlightsProcessed objectAtIndex:i] textHighlight]]];
            [tempFile setFileName:(NSMutableString *)[[tempFile bookTitle] stringByAppendingString:[tempFile authorName]]];
            [filesArray addObject:tempFile];
        }
    }
}

//Run when the application is opened
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

@end
