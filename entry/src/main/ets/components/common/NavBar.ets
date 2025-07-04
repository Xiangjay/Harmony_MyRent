import { BasicConstants } from '../../common/constants/BasicConstants'
import { rvp } from '../../common/utils/responsiveUtil'
import { router } from '@kit.ArkUI'

@Component
export default struct NavBar {
  @Prop title: string

  build() {
    Stack({ alignContent: Alignment.Start }) {
      Text(this.title)
        .fontColor($r('app.color.black'))
        .fontSize(rvp(16))
        .width(BasicConstants.FULL_WIDTH)
        .textAlign(TextAlign.Center)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
      // .constraintSize({ maxWidth: rvp(260) })
      Image($r('app.media.ic_back')).width(rvp(24)).height(rvp(24))
        .onClick(() => {
          router.back()
        })
    }
    .padding({
      top: rvp(10),
      bottom: rvp(10),
      left: rvp(BasicConstants.PADDING),
      right: rvp(BasicConstants.PADDING)
    })
    .height(rvp(44))
    .backgroundColor($r('app.color.white'))
    .width(BasicConstants.FULL_WIDTH)
  }
}