//
//  DetailController.h
//  fit-checker
//
//  Created by Dominik Veselý on 12/30/10.
//  Copyright 2010 CTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailCell.h"
#import "MainViewController.h"


@interface DetailController : UIViewController <NSXMLParserDelegate, UITableViewDelegate, UITableViewDataSource> {
	NSMutableData*	urlData		;
	BOOL inTable;
	BOOL inBody;
	BOOL inRow;
	int count;
	NSMutableArray* tableData;
	DetailCell* tmpCell;
	UITableView* table;
	NSString *titleString;
	MainViewController *mainController;

}

-(void) createConnection;
-(void) checkData:(NSMutableArray*) data;


@property (readwrite,retain) MainViewController *mainController	;
@property (readwrite,retain) NSMutableData*	urlData	;
@property (readwrite,retain) NSMutableArray*	tableData;
@property (readwrite,retain) NSString*	titleString;

@property (nonatomic, assign) IBOutlet DetailCell *tmpCell;
@property (nonatomic, assign) IBOutlet UITableView* table;


@end
