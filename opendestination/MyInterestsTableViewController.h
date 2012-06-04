//
//  MyInteretsTableViewController.h
//  opendestination
//
//  Created by David Hoyos on 04/08/11.
//  Copyright 2011 None. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TagsModel;

@interface MyInterestsTableViewController : UITableViewController <UISearchBarDelegate>
{
@private
  TagsModel * _tags;
  UISearchBar * _searchBar;
}

- (void) refresh;

@end
