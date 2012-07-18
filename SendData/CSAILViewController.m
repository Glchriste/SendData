//
//  CSAILViewController.m
//  SendData
//
//  Created by Grace Christenbery on 7/18/12.
//  Copyright (c) 2012 University of North Carolina at Charlotte. All rights reserved.
//

#import "CSAILViewController.h"

@interface CSAILViewController ()

@end

@implementation CSAILViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
