//
//  FirstPageTopCell.m
//  Boyacai
//
//  Created by Tolecen on 14-3-13.
//
//

#import "FirstPageTopCell.h"

@implementation FirstPageTopCell
@synthesize caidouYuELabel;
@synthesize tishiLabel;
@synthesize moreTimesLabel;
-(void)dealloc
{
    [self.moreTimesLabel release];
    [self.tishiLabel release];
    [self.caidouYuELabel release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImageView *lineImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, 320, 1)];
        [lineImgView setImage:[UIImage imageNamed:@"gou_cai_da_ting_cell_separator.png"]];
        [self.contentView addSubview:lineImgView];
        [lineImgView release];
        
        UILabel * caidouTL = [[UILabel alloc] initWithFrame:CGRectMake(20, 11, 40, 20)];
        [caidouTL setBackgroundColor:[UIColor clearColor]];
        [caidouTL setFont:[UIFont systemFontOfSize:17]];
        [caidouTL setText:@"彩豆:"];
        [self.contentView addSubview:caidouTL];
        [caidouTL release];
        
        self.backgroundColor = [UIColor whiteColor];
        self.caidouYuELabel = [[UILabel alloc] initWithFrame:CGRectMake(63, 5, 240, 30)];
        [self.caidouYuELabel setAdjustsFontSizeToFitWidth:YES];
        [self.caidouYuELabel setFont:[UIFont boldSystemFontOfSize:19]];
        [self.caidouYuELabel setBackgroundColor:[UIColor clearColor]];
        [self.caidouYuELabel setTextColor:[UIColor redColor]];
        [self.contentView addSubview:self.caidouYuELabel];
        [self.caidouYuELabel setText:@"12123232"];
        
        self.tishiLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 300, 30)];
        self.tishiLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.tishiLabel.numberOfLines = 0;
        [self.tishiLabel setFont:[UIFont systemFontOfSize:12]];
        [self.tishiLabel setBackgroundColor:[UIColor clearColor]];
        [self.tishiLabel setTextColor:[UIColor darkGrayColor]];
//        [self.tishiLabel setTextColor:[UIColor redColor]];
        [self.contentView addSubview:self.tishiLabel];
        [self.tishiLabel setText:@"理性博彩,今日还有10次购彩机会"];
        
        self.moreTimesLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 34, 100, 20)];
        [self.moreTimesLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [self.moreTimesLabel setBackgroundColor:[UIColor clearColor]];
        [self.moreTimesLabel setTextAlignment:NSTextAlignmentRight];
        [self.moreTimesLabel setTextColor:[UIColor purpleColor]];
        //        [self.tishiLabel setTextColor:[UIColor redColor]];
        [self.contentView addSubview:self.moreTimesLabel];
        [self.moreTimesLabel setText:@"16+"];
        
        for (int i = 0; i<5; i++) {
            UIImageView * heartImgV = [[UIImageView alloc] initWithFrame:CGRectMake(300-90+15*i+5*i, 24.5, 15, 13)];
            [heartImgV setImage:[UIImage imageNamed:@"heart-full.png"]];
            heartImgV.tag = i+1;
            [self.contentView addSubview:heartImgV];
            [heartImgV release];
            
        }
        
        
    }
    return self;
}

-(void)updateLogInStatus
{
    if ([[RuYiCaiNetworkManager sharedManager] hasLogin])
    {
        if (([appStoreORnormal isEqualToString:@"appStore"] &&
             [TestUNum isEqualToString:[RuYiCaiNetworkManager sharedManager].userno])||([appStoreORnormal isEqualToString:@"appStore"]&&[RuYiCaiNetworkManager sharedManager].shouldCheat)) {
            NSString * yy = [[RuYiCaiNetworkManager sharedManager] userLotPea];
            //                yy = [yy substringToIndex:(yy.length-1)];
            NSString * jiaMoney = [[NSUserDefaults standardUserDefaults] objectForKey:@"jiaMoney"];
            if (!jiaMoney) {
                jiaMoney = @"0";
            }
            self.caidouYuELabel.text = [NSString stringWithFormat:@"%.0f",[yy floatValue]+ [jiaMoney floatValue]];
        }
        else
        {
            self.caidouYuELabel.text = [RuYiCaiNetworkManager sharedManager].userLotPea;
        }
        
    }
    else
    {
        self.caidouYuELabel.text = @"点击登录查看";
    }
}

-(void)setRemainingBuyTimes:(int)theTime
{
    [self.tishiLabel setText:[NSString stringWithFormat:@"理性博彩,今日还有%d次购彩机会",theTime]];
    if (theTime<=5) {
        for (int i = 0; i<5; i++) {
            UIImageView * tempimgV = (UIImageView *)[self.contentView viewWithTag:i+1];
            [tempimgV setFrame:CGRectMake(tempimgV.frame.origin.x, 24.5, 15, 13)];
            if (i+1<=5-theTime) {
                [tempimgV setImage:[UIImage imageNamed:@"heart-null.png"]];
            }
            else
            {
                [tempimgV setImage:[UIImage imageNamed:@"heart-full.png"]];
            }
            
        }
        self.moreTimesLabel.text = @" ";
    }
    else
    {
        for (int i = 0; i<5; i++) {
            
            UIImageView * tempimgV = (UIImageView *)[self.contentView viewWithTag:i+1];
            [tempimgV setFrame:CGRectMake(tempimgV.frame.origin.x, 18, 15, 13)];
            [tempimgV setImage:[UIImage imageNamed:@"heart-full.png"]];
            
        }
        self.moreTimesLabel.text = [NSString stringWithFormat:@"%d+",theTime];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
