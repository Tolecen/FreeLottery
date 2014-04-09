//
//  ComboBoxViewUtils.m
//  Boyacai
//
//  Created by qiushi on 13-4-24.
//
//

#import "ComboBoxViewUtils.h"

@implementation ComboBoxViewUtils

@synthesize comboBoxDatasource;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self initVariables];
        [self initCompentWithFrame:frame];
    }
    return self;
}

#pragma mark -
#pragma mark custom methods

- (void)initVariables {
    showComboBox = NO;
}

- (void)initCompentWithFrame:(CGRect)frame {
    selectContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, frame.size.width - 45, 25)];
    selectContentLabel.font = [UIFont systemFontOfSize:14.0f];
    selectContentLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:selectContentLabel];
    [selectContentLabel release];
    
    pulldownButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [pulldownButton setFrame:CGRectMake(frame.size.width - 25, 0, 25, 25)];
    [pulldownButton setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"down_icon" ofType:@"png"]]
                              forState:UIControlStateNormal];
    [pulldownButton addTarget:self action:@selector(pulldownButtonWasClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:pulldownButton];
    
    hiddenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [hiddenButton setFrame:CGRectMake(0, 0, frame.size.width - 25, 25)];
    hiddenButton.backgroundColor = [UIColor clearColor];
    [hiddenButton addTarget:self action:@selector(pulldownButtonWasClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:hiddenButton];
    
    comboBoxTableView = [[UITableView alloc] initWithFrame:CGRectMake(1, 26, frame.size.width -2, frame.size.height - 27)];
    comboBoxTableView.dataSource = self;
    comboBoxTableView.delegate = self;
    comboBoxTableView.backgroundColor = [UIColor clearColor];
    comboBoxTableView.separatorColor = [UIColor blackColor];
    comboBoxTableView.hidden = YES;
    [self addSubview:comboBoxTableView];
    [comboBoxTableView release];
}

- (void)setContent:(NSString *)content {
    selectContentLabel.text = content;
}

- (void)show {
    comboBoxTableView.hidden = NO;
    showComboBox = YES;
    [self setNeedsDisplay];
}

- (void)hidden {
    comboBoxTableView.hidden = YES;
    showComboBox = NO;
    [self setNeedsDisplay];
}

#pragma mark -
#pragma mark custom event methods

- (void)pulldownButtonWasClicked:(id)sender {
    if (showComboBox == YES) {
        [self hidden];
    }else {
        [self show];
    }
}

#pragma mark -
#pragma mark UITableViewDelegate and UITableViewDatasource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [comboBoxDatasource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ListCellIdentifier";
    UITableViewCell *cell = [comboBoxTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.textLabel.text = (NSString *)[comboBoxDatasource objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:13.0f];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 25.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hidden];
    selectContentLabel.text = (NSString *)[comboBoxDatasource objectAtIndex:indexPath.row];
}

- (void)drawListFrameWithFrame:(CGRect)frame withContext:(CGContextRef)context {
    CGContextSetLineWidth(context, 2.0f);
    CGContextSetRGBStrokeColor(context, 0.0f, 0.0f, 0.0f, 1.0f);
    if (showComboBox == YES) {
        CGContextAddRect(context, CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height));
    } else {
        CGContextAddRect(context, CGRectMake(0.0f, 0.0f, frame.size.width, 25.0f));
    }
    CGContextDrawPath(context, kCGPathStroke);
    CGContextMoveToPoint(context, 0.0f, 25.0f);
    CGContextAddLineToPoint(context, frame.size.width, 25.0f);
    CGContextMoveToPoint(context, frame.size.width - 25, 0);
    CGContextAddLineToPoint(context, frame.size.width - 25, 25.0f);
    
    CGContextStrokePath(context);
}

#pragma mark -
#pragma mark drawRect methods

- (void)drawRect:(CGRect)rect {
    [self drawListFrameWithFrame:self.frame withContext:UIGraphicsGetCurrentContext()];
}
@end
