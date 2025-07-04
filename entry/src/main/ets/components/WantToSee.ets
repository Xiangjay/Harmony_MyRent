import { BasicConstants } from '../common/constants/BasicConstants';
import { rvp } from '../common/utils/responsiveUtil';

@Component
export default struct WantToSee {
  @StorageProp('safeTop') safeTop: number = 0;

  @Builder
  topBuilder() {

    Row() {
      Row({ space: rvp(6) }) {
        Image($r('app.media.ic_bag'))
          .width(rvp(16))
          .height(rvp(16))
        Text('填写通勤地址')
          .fontColor($r('app.color.black'))
          .fontSize(rvp(12))
      }

      Row({ space: rvp(28) }) {
        Column() {
          Image($r('app.media.ic_message'))
            .width(rvp(20))
            .height(rvp(20))
            .fillColor($r('app.color.black'))
          Text('消息')
            .fontColor($r('app.color.black'))
            .fontSize(rvp(10))
        }

        Column() {
          Image($r('app.media.ic_journey'))
            .width(rvp(20))
            .height(rvp(20))
            .fillColor($r('app.color.black'))
          Text('形成')
            .fontColor($r('app.color.black'))
            .fontSize(rvp(10))
        }
      }
    }
    .margin({ top: this.safeTop, bottom: rvp(50) })
    .padding({
      top: rvp(6),
      bottom: rvp(6)
    })
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
    .width(BasicConstants.FULL_WIDTH)
  }

  build() {
    Column() {
      this.topBuilder()
      Column() {
        Row() {
          Image($r('app.media.wanttosee_find')).width(rvp(29)).height(rvp(23))
          Image($r('app.media.wanttosee_room')).width(rvp(29)).height(rvp(23))
        }
        .width(BasicConstants.FULL_WIDTH)

        Text('发现你想看的房子')
          .fontColor($r('app.color.black'))
          .fontSize(rvp(12))
          .margin({ top: rvp(20), bottom: rvp(8) })
          .width(BasicConstants.FULL_WIDTH)
          .textAlign(TextAlign.Start)

        Column() {
          Image($r('app.media.wanttosee_img1'))
            .width(rvp(234))
            .height(rvp(222))
            .objectFit(ImageFit.Fill)
          Text('暂无想看房源，试试如下找房方式')
            .fontColor($r('app.color.black'))
            .fontSize(rvp(16))
            .margin({ top: rvp(10) })
        }
        .margin({ bottom: rvp(20) })
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .width(BasicConstants.FULL_WIDTH)
      }
      .width(BasicConstants.FULL_WIDTH)

      Image($r('app.media.wanttosee_img2'))
        .width(BasicConstants.FULL_WIDTH)
        .height(rvp(80))
        .objectFit(ImageFit.Fill)
    }
    .padding({
      left: rvp(BasicConstants.PADDING),
      right: rvp(BasicConstants.PADDING),
    })
    .width(BasicConstants.FULL_WIDTH)
    .height(BasicConstants.FULL_HEIGHT)
    .linearGradient({
      direction: GradientDirection.Bottom,
      colors: [['#DEFBE5', 0], ['#FFFFFF', 0.3]]
    })
  }
}