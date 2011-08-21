//
//  DetailCell.h
//  fit-checker
//
//  Created by Dominik Veselý on 12/30/10.
//  Copyright 2010 CTU. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DetailCell : UITableViewCell {
	
	BOOL useDarkBackground;
	
	 NSString* column;
	 NSString* value;
	
	IBOutlet UILabel *columnLabel;
    IBOutlet UILabel *valueLabel;

	

}

@property BOOL useDarkBackground;
@property(retain) NSString *column;
@property(retain) NSString *value;
@property(assign) UILabel *valueLabel;
@property(assign) UILabel *columnLabel;


@end
