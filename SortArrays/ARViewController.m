//
//  ARViewController.m
//  SortArrays
//
//  Created by Ariel Rodriguez on 11/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ARViewController.h"
#include <mach/mach_time.h>
#include <stdint.h>

@implementation ARViewController
@synthesize blockTimeLabel; 
@synthesize sortDescriptorTimeLabel; 

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *countriesURL = [[NSBundle mainBundle] URLForResource:@"countries" withExtension:@"plist"]; 
    NSArray *countries = [NSArray arrayWithContentsOfURL:countriesURL]; 
    
    NSTimeInterval blockTally = 0.0; 
    for ( int n = 0; n < 50; n++ ) {
        @autoreleasepool {
            NSDate *blockStartDate = [NSDate date]; 
            [countries sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return [(NSString *)[obj1 objectForKey:@"Name"] compare:[obj2 objectForKey:@"Name"]]; 
            }]; 
            NSDate *blockFinishDate = [NSDate date]; 
            blockTally += [blockFinishDate timeIntervalSinceDate:blockStartDate];
        }
    }
    NSLog(@"%f", blockTally/50.0); 
    
    NSString *blockString = [[NSString alloc] initWithFormat:@"it takes %.2e seconds to sort the array with blocks", blockTally/50.0]; 
    [[self blockTimeLabel] setText:blockString]; 
    
    NSTimeInterval sortDescriptorTally = 0.0; 
    for (int m = 0; m < 50; m++ ) {
        @autoreleasepool {
            NSDate *sortDescriptorStartDate = [NSDate date];
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Name"
                                                                           ascending:YES]; 
            NSArray *descriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil]; 
            [countries sortedArrayUsingDescriptors:descriptors];
            NSDate *sortDescriptorBlockFinishDate = [NSDate date];
            sortDescriptorTally += [sortDescriptorBlockFinishDate timeIntervalSinceDate:sortDescriptorStartDate];
        }
    }
    
    NSString *sortDescriptorString = [[NSString alloc] initWithFormat:@"it takes %.2e seconds to sort the array with sort descriptors", (sortDescriptorTally/50.0)]; 
    [[self sortDescriptorTimeLabel] setText:sortDescriptorString]; 
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.blockTimeLabel = nil; 
    self.sortDescriptorTimeLabel = nil; 
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
