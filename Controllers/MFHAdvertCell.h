//
//  MFHAdvertCell.h
//  MyFutureHome
//
//  Created by Jeronim Morina on 20.02.15.
//  Copyright (c) 2015 SI2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MFHAdvertCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *advertLabel;
@property (weak, nonatomic) IBOutlet UIImageView *advertPicture;
- (id)initWithFrame:(CGRect)frame;

@end
