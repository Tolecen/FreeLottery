//
//  TopUserCell.m
//  Boyacai
//
//  Created by qiushi on 13-4-16.
//
//

#import "TopUserCell.h"
#import "RuYiCaiCommon.h"
#import "RuYiCaiNetworkManager.h"

@implementation TopUserCell
@synthesize headTopImageView = m_headTopImageView;
@synthesize headTitleLable = m_headTitleLable;

@synthesize subTitleLable =m_subTitleLable;
@synthesize sectionButton = m_sectionButton;

- (void)dealloc
{
    [super dealloc];
    [m_headTopImageView release];
    [m_headTitleLable release];
    [m_subTitleLable release];
    [m_sectionButton release];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
     
        self.bounds =CGRectMake(0, 0, 320, 60);
        self.backgroundColor = [UIColor clearColor];
        m_headTopImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
        [self addSubview:m_headTopImageView];

        
        m_headTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 100, 30)];
        m_headTitleLable.backgroundColor = [UIColor clearColor];
        [self addSubview:m_headTitleLable];
        
        if([appStoreORnormal isEqualToString:@"appStore"]&&
           [appTestPhone isEqualToString:[RuYiCaiNetworkManager sharedManager].phonenum])
        {
            m_subTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(60, 25, 280, 40)];
        }else
        {
            m_subTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(60, 35, 280, 20)];
        }
        
        m_subTitleLable.backgroundColor = [UIColor clearColor];
        [self addSubview:m_subTitleLable];

        
        UIImageView *secionLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 58, 320, 2)];
        secionLineImageView.image = [UIImage imageNamed:@"secion_c_Line.png"];
        [self addSubview:secionLineImageView];
        [secionLineImageView release];
        
        //    UIImageView *secionSubLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 58, 320, 2)];
        //    secionSubLineImageView.image = [UIImage imageNamed:@"secion_c_Line.png"];
        //    [headView addSubview:secionSubLineImageView];
        //    [secionSubLineImageView release];
       
            m_sectionButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
//            sectionButton.tag =900+section;
            m_sectionButton.backgroundColor = [UIColor clearColor];
            
            [self addSubview:m_sectionButton];


        
               
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
