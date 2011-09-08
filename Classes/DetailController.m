//
//  DetailController.m
//  fit-checker
//
//  Created by Dominik Veselý on 12/30/10.
//  Copyright 2010 CTU. All rights reserved.
//

#import "DetailController.h"

#define DARK_BACKGROUND  [UIColor colorWithRed:151.0/255.0 green:152.0/255.0 blue:155.0/255.0 alpha:1.0]
#define LIGHT_BACKGROUND [UIColor colorWithRed:172.0/255.0 green:173.0/255.0 blue:175.0/255.0 alpha:1.0]



@implementation DetailController
@synthesize urlData;
@synthesize tableData, table,tmpCell, titleString,mainController;


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}

- (void) refresh {
	[self createConnection];
}


- (void) loadView {
	inTable = NO;
	inBody = NO;
	inRow = NO;	
	count = 0;
	UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
	self.navigationItem.rightBarButtonItem = refreshButton;
	[super loadView];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	//INIT Table
	self.table.rowHeight = 52.0;
    self.table.backgroundColor = DARK_BACKGROUND;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.table.hidden = YES;
	
	[self setTitle:self.titleString];	
	
	//Data for Table
	tableData = [[NSMutableArray alloc] initWithCapacity:10];
		
	[self createConnection];
}

- (void) createConnection {
	
	[tableData removeAllObjects];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];		

	UIApplication *application = [UIApplication sharedApplication];
    application.networkActivityIndicatorVisible = YES;

	NSString *firstString2 = @"https://edux.fit.cvut.cz/courses/XX/classification/student/YY/start";
	NSMutableString *firstString = [firstString2 mutableCopy];
	
	[firstString replaceOccurrencesOfString:@"XX" withString:self.titleString options:NSLiteralSearch range:NSMakeRange(0, [firstString length])];
	[firstString replaceOccurrencesOfString:@"YY" withString:[defaults objectForKey:@"username"] options:NSLiteralSearch range:NSMakeRange(0, [firstString length])];

	
	NSURLRequest *req = [NSURLRequest requestWithURL:
						 [NSURL URLWithString:firstString]];
	
	
	[[NSHTTPCookieStorage sharedHTTPCookieStorage]
	 setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
	
	[[[NSURLConnection alloc] initWithRequest:req delegate:self] autorelease];
	self.urlData = [NSMutableData dataWithLength:0];
	[firstString release];
	
}



#pragma mark URL



- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	UIApplication *application = [UIApplication sharedApplication];
    application.networkActivityIndicatorVisible = NO;
	self.table.hidden = NO;
	
	
	NSMutableString *myString = [[NSMutableString alloc] initWithData:self.urlData encoding:NSUTF8StringEncoding];	
	NSRange range2 = [myString rangeOfString:@"Nepovolená akce" options:NSCaseInsensitiveSearch];
	NSRange range = [myString rangeOfString:@"Object not found!" options:NSCaseInsensitiveSearch];
	BOOL match = (range.location != NSNotFound || range2.location != NSNotFound);
	if (match) {
		UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Chyba"
								   message: @"Pravděpodobně špatné jméno předmětu. Zkontrolujte seznam předmětů a neexistující předmět smažte a přidejte nový."
								  delegate: self
						 cancelButtonTitle: @"Zkontrolovat"		 
						 otherButtonTitles: nil];
		[alert show];
		[alert release];	
	}
    
    
    
	
	NSData *stringData = [myString dataUsingEncoding: NSASCIIStringEncoding allowLossyConversion: YES];	
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:stringData];
    
	
    // Tell NSXMLParser that this class is its delegate
    [parser setDelegate:self];
	
    // Kick off file parsing
   [parser parse];
	
    // Clean up
	
    [parser setDelegate:nil];
    [parser release];
	[myString release];
	
    [self checkData:self.tableData];

	
	[self.table reloadData];
	
	if([self.tableData count] == 0 && !match) {
		UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Chyba Předmětu"
								   message: @"Předmět existuje, ale nejsou v něm zadaná žádná klasifikační data"
								  delegate: nil
						 cancelButtonTitle: @"Ok"
						 otherButtonTitles: nil];
		[alert show];
		[alert release];	
	}	
	
}

-(void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse*)response
{
    [urlData setLength:0];
    UIApplication *application = [UIApplication sharedApplication];
    application.networkActivityIndicatorVisible = YES;
}

-(void)connection:(NSURLConnection *)connection
   didReceiveData:(NSData*)incrementalData
{
    [self.urlData appendData:incrementalData];
	
	
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
}


#pragma mark -
#pragma mark SameValuesLogic

- (void) checkData:(NSMutableArray*) data {
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray* oldData = [defaults objectForKey:self.titleString];
    
    if(oldData != nil) {
        if([data isEqualToArray:oldData]) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Žádná změna" 
                                                      message:@"V tomto předmětu nenastaly žádné změny od poslední aktualizace" 
                                                      delegate:nil 
                                                      cancelButtonTitle:@"OK" 
                                                      otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
    }
    
    [defaults setObject:data forKey:self.titleString];
    [defaults synchronize];
    
}


#pragma mark AlertDelegate

- (void) alertView: (UIAlertView *) alertView
clickedButtonAtIndex: (NSInteger) buttonIndex {
	[self.tabBarController setSelectedIndex:1];
	[[[[self tabBarController] viewControllers] objectAtIndex:0] popToRootViewControllerAnimated:NO];

} 
#pragma mark XML

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	if([elementName isEqualToString:@"div"] && [[attributeDict objectForKey:@"class"] isEqualToString:@"overTable"]) {
		inTable = YES;
	}
	if (inTable) {
		if([elementName isEqualToString:@"tbody"]) {
		inBody = YES;
		}
		if ([elementName isEqualToString:@"tr"]) {
			inRow = YES;
		}
	}
		
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if(inTable){
		if (!([string isEqualToString:@"sloupec"] || [string isEqualToString:@"hodnota"])) {
			[tableData addObject:string];
			count ++;
		}
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if (inTable && [elementName isEqualToString:@"table"]) {
		inTable = NO;
		inBody = NO;
	}
	if ([elementName isEqualToString:@"tr"] && (count%2 == 1)) {
		[tableData addObject:@"-"];
		count++;
	}
}




#pragma mark tableData


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"DetailCell";
	
	DetailCell *cell = (DetailCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"DetailCell" owner:self options:nil];
        cell = tmpCell;
        self.tmpCell = nil;
		
    }
    
	// Display dark and light background in alternate rows -- see tableView:willDisplayCell:forRowAtIndexPath:.
    cell.useDarkBackground = (indexPath.row % 2 == 0);
	
	cell.columnLabel.text = [tableData objectAtIndex:(indexPath.row *2)];
	cell.valueLabel.text = [tableData objectAtIndex:((indexPath.row) *2)+1];
	
	
	
	return cell;
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int rows = [tableData count]/2;
	return rows ;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	 mainController._reload = 0;
}




#pragma mark Memory

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[urlData release];
	[mainController release];
	[tableData release];
    [super dealloc];
}


@end
