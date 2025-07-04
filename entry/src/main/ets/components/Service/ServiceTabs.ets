import { BasicConstants } from '../../common/constants/BasicConstants'
import { rvp } from '../../common/utils/responsiveUtil'
import { cleaningServiceInfo, newcomerZone } from '../../models/ServiceDataModels'

@Component
export default struct ServiceTabs {
  @Prop newcomerZone: newcomerZone
  @Prop cleaningServiceInfo: Array<cleaningServiceInfo>
  @State currentTabIndex: number = 0

  @Builder
  tabBarBuilder(title: string, subTitle: string, index: number) {
    Column() {
      Text(title)
        .fontColor($r('app.color.black'))
        .fontSize(this.currentTabIndex === index ? rvp(18) : rvp(14))
        .fontWeight(700)
      Text(subTitle)
        .fontColor($r('app.color.gray'))
        .fontSize(rvp(12))
      if (this.currentTabIndex === index) {
        Row() {

        }
        .width(rvp(20))
        .height(rvp(4))
        .backgroundColor('#51BB9E')
        .borderRadius(rvp(8))
        .margin({ top: rvp(2) })
      }
    }
    .justifyContent(FlexAlign.Center)
    .height(BasicConstants.FULL_HEIGHT)
  }

  @Builder
  tabContentBuilder() {
    Column() {
      Text() {
        Span('新人').fontColor($r('app.color.primary'))
        Span('专区').fontColor($r('app.color.black'))
      }
      .fontWeight(700)
      .width(BasicConstants.FULL_WIDTH)
      .fontSize(rvp(16))
      .margin({ bottom: rvp(8) })

      Image($r('app.media.service_tabContent1')).width(rvp(312)).height(rvp(90)).objectFit(ImageFit.Fill)
        .margin({ bottom: rvp(24) })
      Text('洁净家')
        .fontSize(rvp(16))
        .fontColor($r('app.color.black'))
        .width(BasicConstants.FULL_WIDTH)
        .fontWeight(700)
        .margin({ bottom: rvp(8) })
      Row({ space: rvp(8) }) {
        ForEach(this.cleaningServiceInfo, (item: cleaningServiceInfo) => {
          Column({ space: rvp(8) }) {
            Image(item.img)
              .width(BasicConstants.FULL_WIDTH)
            Text(item.title).fontWeight(700).fontSize(rvp(14)).fontColor($r('app.color.black'))
            Text(item.subTitle).fontSize(rvp(10)).fontColor($r('app.color.gray_second'))
            Text() {
              Span('到手价 ').fontSize(rvp(10)).fontColor($r('app.color.gray_second'))
              Span(`￥${item.priceAfterDiscounts}`).fontSize(rvp(16)).fontColor('#D9351A')
              Span(`￥${item.originalPrice}`)
                .fontSize(rvp(10))
                .fontColor($r('app.color.gray_second'))
                .decoration({ type: TextDecorationType.LineThrough })
            }
          }
          .alignItems(HorizontalAlign.Start)
          .width(rvp(152))
        }, (item: cleaningServiceInfo) => item.title)
      }
      .width(BasicConstants.FULL_WIDTH)
    }
    .padding(rvp(8))
    .justifyContent(FlexAlign.Start)
    .width(BasicConstants.FULL_WIDTH)
  }

  build() {
    Tabs({ barPosition: BarPosition.Start }) {
      TabContent() {
        this.tabContentBuilder()
      }.tabBar(this.tabBarBuilder('会员精选', '专业服务', 0))

      TabContent() {
        this.tabContentBuilder()
      }.tabBar(this.tabBarBuilder('居家保洁', '解放双手', 1))

      TabContent() {
        this.tabContentBuilder()
      }.tabBar(this.tabBarBuilder('深层清洗', '高温蒸洗', 2))

      TabContent() {
        this.tabContentBuilder()
      }.tabBar(this.tabBarBuilder('新居乔迁', '一站搬家', 3))
    }
    .onChange((index: number) => {
      this.currentTabIndex = index
    })
    .margin({ top: rvp(18) })
    .barHeight(rvp(42))
    .width(BasicConstants.FULL_WIDTH)
    .height(rvp(480))
  }
}