//
//  NYSConversationListViewController.m
//  BaseIOS
//
//  Created by 倪永胜 on 2020/7/11.
//  Copyright © 2020 niyongsheng. All rights reserved.
//

#import "NYSConversationListViewController.h"
#import "NYSConversationViewController.h"

@interface NYSConversationListViewController ()

@end

@implementation NYSConversationListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [NYSTKAlert showColorfulToastWithMessage:@"NYSKit Welcome !" type:NYSTKColorfulToastTypeYellowCat direction:NYSTKComeInDirectionUp onView:self.conversationListTableView themeModel:NYSTKThemeModelLight];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configTheme];
    [self initNavItem];
    self.conversationListTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.conversationListTableView setTableFooterView:[UIView new]];
    
    // 设置需要显示哪些类型的会话
    [self setDisplayConversationTypes:@[
                                        @(ConversationType_PRIVATE),
                                        @(ConversationType_DISCUSSION),
                                        @(ConversationType_CHATROOM),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_APPSERVICE),
                                        @(ConversationType_SYSTEM)
                                        ]];
    
    // 设置需要将哪些类型的会话在会话列表中聚合显示
    [self setCollectionConversationType:@[
                                          @(ConversationType_DISCUSSION),
                                          @(ConversationType_GROUP)
                                          ]];
    // 连接状态
    self.showConnectingStatusOnNavigatorBar = YES;
    // 会话列表头像 圆形显示
    [self setConversationAvatarStyle:RC_USER_AVATAR_CYCLE];
    // 移除群助手
    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION)]];
}

/// 点击cell回调
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    [self.conversationListTableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NYSConversationViewController *conversationVC = [[NYSConversationViewController alloc] init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.title = model.conversationTitle;
    [self.navigationController pushViewController:conversationVC animated:YES];
}

- (void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.lee_theme.LeeConfigBackgroundColor(@"common_bg_color_2")
    
    .LeeAddCustomConfig(DAY, ^(id  _Nonnull item) {
        LEEThemeIdentifier *ident = [LEEThemeIdentifier ident:@"common_bg_color_2"];
        RCConversationModel *model = [(RCConversationBaseCell *)item model];
        model.topCellBackgroundColor = [UIColor leeTheme_ColorWithHexString:ident];
        model.cellBackgroundColor = [UIColor leeTheme_ColorWithHexString:ident];
    })
    .LeeAddCustomConfig(NIGHT, ^(id  _Nonnull item) {
        LEEThemeIdentifier *ident = [LEEThemeIdentifier ident:@"common_bg_color_2"];
        RCConversationModel *model = [(RCConversationBaseCell *)item model];
        model.topCellBackgroundColor = [UIColor leeTheme_ColorWithHexString:ident];
        model.cellBackgroundColor = [UIColor leeTheme_ColorWithHexString:ident];
    });
}

- (void)initNavItem {
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"notification_icon"] imageWithRenderingMode:UIImageRenderingModeAutomatic] style:UIBarButtonItemStyleDone target:self action:nil];
    WS(weakSelf);
    [rightItem setActionBlock:^(id _Nonnull sender) {
        NYSConversationViewController *conversationVC = [[NYSConversationViewController alloc] init];
        conversationVC.conversationType = ConversationType_PRIVATE;
        conversationVC.targetId = @"ACC_19068";
        conversationVC.title = @"NYS";
        [weakSelf.navigationController pushViewController:conversationVC animated:YES];
    }];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - 设置主题
- (void)configTheme {
    
    if (CurrentSystemVersion < 13.0) {
        self.view.lee_theme.LeeConfigBackgroundColor(@"common_bg_color_1");
    }
        
    self.conversationListTableView.lee_theme.LeeConfigBackgroundColor(@"common_bg_color_1");;
    
    self.conversationListTableView.lee_theme
    .LeeConfigSeparatorColor(@"common_separator_color_1");
}

/// 屏幕旋转后重新布局
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    CGFloat duration = [coordinator transitionDuration];
    WS(weakSelf);
    [UIView animateWithDuration:duration animations:^{
        [weakSelf.conversationListTableView setFrame:(CGRect){{0, 0}, size}];
    }];
}

@end
