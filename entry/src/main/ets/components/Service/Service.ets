import { getServiceData } from '../../apis/ServiceApi';
import { BasicConstants } from '../../common/constants/BasicConstants';
import { handelTopBar } from '../../common/utils/handleTopBar';
import { rvp } from '../../common/utils/responsiveUtil';
import { homeService, IServiceData, vipService } from '../../models/ServiceDataModels';
import ServiceTabs from './ServiceTabs';

@Extend(Text)
function titleText() {
  .fontColor($r('app.color.black'))
  .fontSize(rvp(16))
  .fontWeight(700)
}

@Component
export default struct Service {
  @StorageProp('safeTop') safeTop: number = 0;
  @State serviceData: IServiceData | null = null
  @State monthList: number[] = []
  @State dataCurrentMonth: number = 0
  @State bgColor: string = 'rgba(255,255,255,0)'
  @State fontColor: string = 'rgba(255,255,255,1)'
  private handleTopBar: handelTopBar = new handelTopBar()
  getServiceData = async () => {
    this.serviceData = await getServiceData<IServiceData>()
    this.dataCurrentMonth = parseInt(this.serviceData.serviceActivity.name.split(".")[0])
    this.getRecentMonths(this.dataCurrentMonth)
  }
  getRecentMonths = (currentMonth: number) => {
    this.monthList = [this.getPreMonths(currentMonth, 2), this.getPreMonths(currentMonth, 1), currentMonth,
      this.getNextMonths(currentMonth, 1), this.getNextMonths(currentMonth, 2), this.getNextMonths(currentMonth, 3)]
    // .map(val => this.addZero(val))
  }
  getPreMonths = (currentMonth: number, num: number) => {
    const val = currentMonth - num
    return val < 1 ? 12 + val : val
  }
  getNextMonths = (currentMonth: number, num: number) => {
    const val = currentMonth + num
    return val > 12 ? val - 12 : val
  }
  addZero = (val: number): string => {
    return val < 10 ? '0' + val : val + ''
  }

  aboutToAppear(): void {
    this.getServiceData()
  }

  @Builder
  topBarBuilder() {
    Row() {
      Row({ space: rvp(5) }) {
        Text('请选择地址')
          .fontColor(this.fontColor)
          .fontSize(rvp(14))
        Image($r('app.media.ic_arrow_down'))
          .width(rvp(6))
          .height(rvp(6))
      }

      Row({ space: rvp(30) }) {
        Column() {
          Image($r('app.media.ic_message'))
            .width(rvp(20))
            .height(rvp(20))
            .fillColor(this.fontColor)
          Text('消息')
            .fontColor(this.fontColor)
            .fontSize(rvp(10))
        }

        Column() {
          Image($r('app.media.ic_service'))
            .width(rvp(20))
            .height(rvp(20))
            .fillColor(this.fontColor)
          Text('客服')
            .fontColor(this.fontColor)
            .fontSize(rvp(10))
        }
      }
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
    .height(rvp(38) + this.safeTop)
    .width(BasicConstants.FULL_WIDTH)
    .backgroundColor(this.bgColor)
    .padding({
      left: rvp(BasicConstants.PADDING),
      right: rvp(BasicConstants.PADDING),
      top: rvp(4) + this.safeTop,
      bottom: rvp(4)
    })
  }

  @Builder
  titleBuilder(title: string, subTitle: string = '全部服务') {
    Row() {
      Text(title).titleText()
      Text(subTitle)
        .fontColor($r('app.color.gray'))
        .fontSize(rvp(12))
    }
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
    .width(BasicConstants.FULL_WIDTH)
  }

  @Builder
  VIPCardBuilder() {
    Stack({ alignContent: Alignment.Bottom }) {
      Column() {
        Row() {
          Row({ space: rvp(1) }) {
            Image($r('app.media.ic_service_vipcard_crown')).width(rvp(18)).height(rvp(18))
            Text('开通谷粒卡享特权').fontColor($r('app.color.white')).fontSize(rvp(16))
          }

          Text('VIP').fontColor($r('app.color.white')).fontSize(rvp(16)).fontStyle(FontStyle.Italic).fontWeight(700)
        }
        .padding({ left: rvp(40), right: rvp(40), top: rvp(12) })
        .width(BasicConstants.FULL_WIDTH)
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Center)

        Row() {
          ForEach(this.serviceData?.vipServiceList, (item: vipService, index: number) => {
            Column({ space: rvp(6) }) {
              Text(item.name).fontColor($r('app.color.white')).fontSize(rvp(12)).fontWeight(700)
              Text() {
                Span(item.content.toString()).fontColor($r('app.color.white')).fontSize(rvp(16)).fontWeight(700)
                if (index === 0) {
                  Span('元').fontColor($r('app.color.white')).fontSize(rvp(10))
                } else if (index === 1) {
                  Span('张').fontColor($r('app.color.white')).fontSize(rvp(10))
                } else if (index === 2) {
                  Span('项').fontColor($r('app.color.white')).fontSize(rvp(10))
                } else {
                  Span('个').fontColor($r('app.color.white')).fontSize(rvp(10))
                }
              }
            }
          }, (item: vipService) => item.name)
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Center)
        .padding({ left: rvp(36), right: rvp(40) })
        .margin({ top: rvp(BasicConstants.PADDING) })
        .width(BasicConstants.FULL_WIDTH)
      }
      .backgroundImage($r('app.media.service_vipcard_bg'))
      .backgroundImageSize(ImageSize.FILL)
      .width(rvp(328))
      .height(rvp(100))
      .margin({
        top: rvp(12),
        bottom: rvp(36),
        left: rvp(16),
        right: rvp(16)
      })

      Image($r('app.media.ic_servicebg_arrow_down'))
        .width(rvp(10))
        .height(rvp(4))
        .margin({ bottom: rvp(10) })
    }
    .backgroundImage($r('app.media.service_topbg'))
    .backgroundImageSize(ImageSize.FILL)
    .width(BasicConstants.FULL_WIDTH)
    .height(rvp(220))
  }

  @Builder
  familyServiceBuilder() {
    Column({ space: rvp(20) }) {
      this.titleBuilder('家庭服务')

      Grid() {
        ForEach(this.serviceData?.homeServiceList, (item: homeService) => {
          GridItem() {
            Column({ space: 8 }) {
              Image(item.icon)
                .width(rvp(24))
                .height(rvp(24))
              Text(item.title)
                .fontColor($r('app.color.black'))
                .fontSize(rvp(12))
            }
          }
        }, (item: homeService) => item.title)
      }
      .width(BasicConstants.FULL_WIDTH)
      .columnsTemplate('1fr 1fr 1fr 1fr 1fr')
      .rowsGap(rvp(22))
    }
    .margin({ bottom: rvp(34) })
    .width(BasicConstants.FULL_WIDTH)
  }

  @Builder
  serviceCalender() {
    Column() {
      this.titleBuilder('服务日历')

      // 日历列表
      Row() {
        ForEach(this.monthList, (item: number) => {
          Text() {
            Span(this.addZero(item))
              .fontColor($r('app.color.black'))
              .fontSize(rvp(16))
              .fontWeight(700)
            Span('月')
              .fontColor($r('app.color.gray'))
              .fontSize(rvp(12))
          }
          .backgroundColor(item === this.dataCurrentMonth ? '#CDFFD9' : Color.Transparent)
          .width(item === this.dataCurrentMonth ? rvp(46) : 'auto')
          .height(item === this.dataCurrentMonth ? rvp(32) : 'auto')
          .borderRadius(item === this.dataCurrentMonth ? rvp(4) : 0)
          .textAlign(TextAlign.Center)
        }, (item: string) => item)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
      .margin({ top: rvp(10), bottom: rvp(18) })
      .width(BasicConstants.FULL_WIDTH)

      Stack({ alignContent: Alignment.Top }) {
        Image($r('app.media.service_serviceCalender_card'))
          .width(BasicConstants.FULL_WIDTH)
          .height(BasicConstants.FULL_HEIGHT)
        Column({ space: rvp(8) }) {
          Row() {
            Text(this.serviceData?.serviceActivity.name)
              .fontColor($r('app.color.black'))
              .fontSize(rvp(14))
              .fontWeight(700)
          }
          .width(BasicConstants.FULL_WIDTH)

          Row({ space: rvp(10) }) {
            Image($r('app.media.service_serviceCalender_img'))
              .width(rvp(100))
              .height(BasicConstants.FULL_HEIGHT)
              .objectFit(ImageFit.Fill)
            Column() {
              Text(this.serviceData?.serviceActivity.title)
                .fontColor($r('app.color.black'))
                .fontSize(rvp(14))
                .width(BasicConstants.FULL_WIDTH)
                .margin({ bottom: rvp(8) })
              Text(this.serviceData?.serviceActivity.subTitle)
                .fontColor($r('app.color.black'))
                .fontSize(rvp(12))
                .width(BasicConstants.FULL_WIDTH)
                .margin({ bottom: rvp(24) })
              Row() {
                Button('立即参与', { type: ButtonType.Normal })
                  .width(rvp(70))
                  .height(rvp(24))
                  .borderRadius(rvp(4))
                  .backgroundColor('#CDFFD9')
                  .fontColor('#1F632F')
              }
              .justifyContent(FlexAlign.End)
              .width(BasicConstants.FULL_WIDTH)
            }
            .layoutWeight(1)
            .padding({ top: rvp(8) })
            .width(BasicConstants.FULL_WIDTH)
            .height(BasicConstants.FULL_HEIGHT)
          }
          .height(rvp(100))
          .width(BasicConstants.FULL_WIDTH)
        }
        .padding({
          left: rvp(8),
          top: rvp(8),
          right: rvp(16),
          bottom: rvp(8)
        })
        .width(BasicConstants.FULL_WIDTH)
      }
      .height(140)
      .width(BasicConstants.FULL_WIDTH)
    }
    .width(BasicConstants.FULL_WIDTH)
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      Scroll() {
        Column() {
          this.VIPCardBuilder()
          Column() {
            this.familyServiceBuilder()
            this.serviceCalender()
            ServiceTabs({
              newcomerZone: this.serviceData?.newcomerZone,
              cleaningServiceInfo: this.serviceData?.cleaningServiceInfo
            })
          }
          .padding({ left: rvp(BasicConstants.PADDING), right: rvp(BasicConstants.PADDING) })
          .width(BasicConstants.FULL_WIDTH)
        }
        .width(BasicConstants.FULL_WIDTH)
      }
      .onDidScroll((xOffset: number, yOffset: number) => {
        this.bgColor = this.handleTopBar.handleScroll(xOffset, yOffset).bgColor
        this.fontColor = this.handleTopBar.handleScroll(xOffset, yOffset).fontColor
      })
      .scrollBar(BarState.Off)
      .width(BasicConstants.FULL_WIDTH)

      this.topBarBuilder()
    }
    .width(BasicConstants.FULL_WIDTH)
    .height(BasicConstants.FULL_HEIGHT)
  }
}