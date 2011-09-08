//
//  DetailCell.m
//  fit-checker
//
//  Created by Dominik Veselý on 12/30/10.
//  Copyright 2010 CTU. All rights reserved.
//

#import "DetailCell.h"


@implementation DetailCell

@synthesize useDarkBackground, column, value, columnLabel, valueLabel;

- (void)setUseDarkBackground:(BOOL)flag
{
    if (flag != useDarkBackground || !self.backgroundView)
    {
        useDarkBackground = flag;
		
        NSString *backgroundImagePath = [[NSBundle mainBundle] pathForResource:useDarkBackground ? @"DarkBackground" : @"LightBackground" ofType:@"png"];
        UIImage *backgroundImage = [[UIImage imageWithContentsOfFile:backgroundImagePath] stretchableImageWithLeftCapWidth:0.0 topCapHeight:1.0];
        self.backgroundView = [[[UIImageView alloc] initWithImage:backgroundImage] autorelease];
        self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundView.frame = self.bounds;
    }
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [super dealloc];
}


@end
