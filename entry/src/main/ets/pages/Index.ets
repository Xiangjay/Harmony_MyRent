import Home from '../components/Home/Home'
import WantToSee from '../components/WantToSee'
import Discover from '../components/Discover'
import Service from '../components/Service/Service'
import My from '../components/My'
import { rvp } from '../common/utils/responsiveUtil'
import { window } from '@kit.ArkUI'
import { preferences } from '@kit.ArkData'
import { preferencesUtil } from '../common/utils/PreferencesUtils'

@Entry
@Component
struct Index {
  @State currentTabIndex: number = 0
  windowClass: window.Window = AppStorage.get("windowClass") as window.Window;

  onPageShow(): void {
    // 因为从登录页返回不会走aboutTpAppear，所以写在这里
    const token: preferences.ValueType = preferencesUtil.getData('token')
    if (token) {
      // 这里要保存一份到AppStorage给Http用
      AppStorage.setOrCreate('token', token)
    }
  }

  @Builder
  TabBarBuilder(title: string, image: Resource, activeImage: Resource, index: number) {
    Column() {
      Image(this.currentTabIndex === index ? activeImage : image)
        .width(rvp(28))
        .height(rvp(28))
      Text(title)
        .fontSize(rvp(10))
        .fontColor(this.currentTabIndex === index ? $r('app.color.black') : $r('app.color.tab_text_default'))
    }
  }

  build() {
    Tabs({ barPosition: BarPosition.End, index: this.currentTabIndex }) {
      TabContent() {
        Home()
      }.tabBar(this.TabBarBuilder('首页', $r('app.media.ic_tabbar_home'), $r('app.media.ic_tabbar_home_active'), 0))

      TabContent() {
        WantToSee()
      }
      .tabBar(this.TabBarBuilder('想看', $r('app.media.ic_tabbar_wanttosee'),
        $r('app.media.ic_tabbar_wanttosee_active'), 1))

      TabContent() {
        Service()
      }
      .tabBar(this.TabBarBuilder('服务', $r('app.media.ic_tabbar_service'), $r('app.media.ic_tabbar_service_active'),
        2))

      TabContent() {
        Discover()
      }
      .tabBar(this.TabBarBuilder('发现', $r('app.media.ic_tabbar_discover'), $r('app.media.ic_tabbar_discover_active'),
        3))

      TabContent() {
        My()
      }.tabBar(this.TabBarBuilder('我的', $r('app.media.ic_tabbar_my'), $r('app.media.ic_tabbar_my_active'), 4))
    }
    .barHeight(rvp(50))
    .scrollable(false)
    .onChange((index: number) => {
      this.currentTabIndex = index
      switch (index) {
        case 1:
          this.windowClass.setWindowSystemBarProperties({
            statusBarContentColor: '#000000'
          });
          break;
        case 3:
          this.windowClass.setWindowSystemBarProperties({
            statusBarContentColor: '#000000'
          });

        default:
          this.windowClass.setWindowSystemBarProperties({
            statusBarContentColor: '#ffffff'
          });
          break;
      }
    })
  }
}