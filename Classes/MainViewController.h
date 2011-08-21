//
//  MainViewController.h
//  fit-checker
//
//  Created by Dominik Veselý on 12/30/10.
//  Copyright 2010 CTU. All rights reserved.
//



@interface MainViewController : UITableViewController  <UITableViewDelegate, UITableViewDataSource>{
	
	NSMutableData *urlData;
	NSMutableArray *courses;
	IBOutlet UIView* spinView;
	IBOutlet UIActivityIndicatorView* spinner;
	BOOL _reload;
}

@property (nonatomic,retain) UIActivityIndicatorView *spinner;
@property (nonatomic,retain) UIView* spinView;
@property (nonatomic,retain) NSMutableData *urlData;
@property (nonatomic,retain) NSMutableArray *courses;
@property (nonatomic,assign) BOOL _reload;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
- (void)createConnection;

@end
