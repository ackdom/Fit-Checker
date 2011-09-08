//
//  AboutController.h
//  fit-checker
//
//  Created by Dominik Veselý on 9/8/11.
//  Copyright 2011 CTU. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AboutController : UIViewController {
    
    IBOutlet UIImageView* imageView; 
    
}

- (void) imageTapped ;

@property (nonatomic,retain) IBOutlet UIImageView* imageView;

@end
