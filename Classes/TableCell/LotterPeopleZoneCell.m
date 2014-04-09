//
//  LotterPeopleZoneCell.m
//  Boyacai
//
//  Created by 纳木 那咔 on 13-4-18.
//
//

#import "LotterPeopleZoneCell.h"
#import "ColorUtils.h"

@interface LotterPeopleZoneCell ()
{

    UIImageView *_iconImageView;
    UILabel *_titleLabel;
    UILabel *_contentLabel1,*_contentLabel2;
    
}


@property (nonatomic, retain)  UIImageView *iconImageView;
@property (nonatomic, retain)  UILabel *titleLabel;
@property (nonatomic, retain)  UILabel *contentLabel1 ,*contentLabel2;
@end

@implementation LotterPeopleZoneCell
@synthesize titleString = _titleString;
@synthesize iconImage = _iconImage;
@synthesize backGroundImageView = _backGroundImageView;
@synthesize iconImageView = _iconImageView;
@synthesize titleLabel = _titleLabel;
@synthesize contentLabel1 =_contentLabel1;
@synthesize contentLabel2 = _contentLabel2;
@synthesize contentString1 = _contentString1;
@synthesize contentString2 = _contentString2;

-(void)dealloc{
    
    [_backGroundImageView release];
    [_iconImageView release];
    [_titleLabel release];
    [_contentLabel1 release];
    [_contentLabel2 release];
    [_contentString1 release];
    [_contentString2 release];
    [_iconImage release];
    [_titleString release];
    [super dealloc];
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //背景
        self.backGroundImageView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lotter_people_zone_cell_back_ground_img_normal.png"]]autorelease];
        self.backGroundImageView.frame = CGRectMake(0, 0, 320,71);
        [self addSubview:_backGroundImageView];
        
        
        //icon
        self.iconImageView =[[[UIImageView alloc]initWithFrame:CGRectMake(18, 10, 50, 50)]autorelease];
        [self.iconImageView setImage:[UIImage imageNamed:@"zhan_nei_gong_gao.png"]];
        [self addSubview:_iconImageView];
        //标题
        self.titleLabel = [[[UILabel alloc]initWithFrame:CGRectMake(82, 10, 200, 21)]autorelease];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [ColorUtils parseColorFromRGB:@"#3c3c3c"];
        self.titleLabel.textAlignment = UITextAlignmentLeft;
        self.titleLabel.text = @"专家推荐";
        [self addSubview:_titleLabel];
        //文本1
        self.contentLabel1 = [[[UILabel alloc]initWithFrame:CGRectMake(82, 29, 200, 21)]autorelease];
        self.contentLabel1.font = [UIFont systemFontOfSize:9];
        self.contentLabel1.backgroundColor = [UIColor clearColor];
        self.contentLabel1.textColor = [ColorUtils parseColorFromRGB:@"#787878"];
        self.contentLabel1.textAlignment = UITextAlignmentLeft;
        self.contentLabel1.text = @"瞒妻子偷购彩票 中得头奖却不敢兑取";
        [self addSubview:_contentLabel1];
        
        //文本2
        self.contentLabel2 = [[[UILabel alloc]initWithFrame:CGRectMake(82, 43, 200, 21)]autorelease];
        self.contentLabel2.font = [UIFont systemFontOfSize:9];
        self.contentLabel2.backgroundColor = [UIColor clearColor];
        self.contentLabel2.textColor = [ColorUtils parseColorFromRGB:@"#787878"];
        self.contentLabel2.textAlignment = UITextAlignmentLeft;
        self.contentLabel2.text = @"瞒妻子偷购彩票 中得头奖却不敢兑取";
        [self addSubview:_contentLabel2];
        
        UIImageView *accessoryImageView = [[[UIImageView alloc]initWithFrame:CGRectMake(295, 31, 6, 8)]autorelease];
        [accessoryImageView setImage:[UIImage imageNamed:@"cell_accessory_style.png"]];
        [self addSubview:accessoryImageView];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshDate{
    [self.iconImageView setImage:self.iconImage];
    [self.titleLabel setText:self.titleString];
    [self.contentLabel1 setText:self.contentString1];
    [self.contentLabel2 setText:self.contentString2];
    
}
@end
