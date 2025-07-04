import { getHomeData } from '../../apis/HomeApis'
import { BasicConstants } from '../../common/constants/BasicConstants'
import { MyLazyDataSource } from '../../models/MyLazyDataSource'
import { HomeBanner, HomeNav, HomePlan, HomeTitle, IHomeData } from '../../models/HomeDataModels'
import RecommendHouse from './RecommendHouse'
import { rvp } from '../../common/utils/responsiveUtil'
import { handelTopBar } from '../../common/utils/handleTopBar'
import { router } from '@kit.ArkUI'

@Component
export default struct Home {
  @StorageProp('safeTop') safeTop: number = 0;
  @State homeData: IHomeData | null = null
  @State bannerLazyData: MyLazyDataSource<HomeBanner> = new MyLazyDataSource()
  @State bgColor: string = 'rgba(255,255,255,0)'
  @State fontColor: string = 'rgba(255,255,255,1)'
  private handleTopBar: handelTopBar = new handelTopBar()
  getHomeData = async () => {
    this.homeData = await getHomeData<IHomeData>()
    this.bannerLazyData.pushAllData(this.homeData.bannerList)
  }

  @Builder
  topBarBuilder() {
    Row({ space: rvp(BasicConstants.SHADOW_RADIUS) }) {
      Text('呼和浩特')
        .fontSize(rvp(14))
        .fontColor(this.fontColor)
      Stack() {
        TextInput()
          .width(BasicConstants.FULL_HEIGHT)
          .height(BasicConstants.FULL_HEIGHT)
          .backgroundColor($r('app.color.white'))
          .border({ width: 1, color: $r('app.color.gray') })
        Row() {
          Image($r('app.media.ic_search'))
            .width(rvp(18))
            .height(rvp(18))
          Text('公司/地铁/小区')
            .fontSize(rvp(10))
            .fontColor($r('app.color.gray'))
            .layoutWeight(1)
            .margin({ left: BasicConstants.PADDING_S, right: BasicConstants.PADDING_S })
          Divider()
            .vertical(true)
            .color($r('app.color.divider'))
            .width(1)
            .height(rvp(18))
            .margin({ right: BasicConstants.PADDING })
          Image($r("app.media.ic_search_located"))
            .width(rvp(18))
            .height(rvp(18))
        }
        .width(BasicConstants.FULL_WIDTH)
        .padding({ left: BasicConstants.PADDING, right: BasicConstants.PADDING })
      }
      .onClick(() => {
        router.pushUrl({
          url: 'pages/RentList'
        })
      })
      .layoutWeight(1)

      Image($r('app.media.ic_message'))
        .width(rvp(24))
        .height(rvp(24))
        .fillColor(this.fontColor)
    }
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
  swiperBuilder() {
    Swiper() {
      LazyForEach(this.bannerLazyData, (banner: HomeBanner) => {
        Row() {
          Image(banner.imageURL)
            .objectFit(ImageFit.Fill)
            .width(BasicConstants.FULL_WIDTH)
            .height(BasicConstants.FULL_HEIGHT)
        }
      }, (banner: HomeBanner) => banner.id.toString())
    }
    .autoPlay(true)
    .indicator(
      new DotIndicator()
        .color($r('app.color.swiper_indicator_default'))
        .selectedColor($r('app.color.swiper_indicator_active'))
    )
    .width(BasicConstants.FULL_WIDTH)
    .height(rvp(210))
  }

  @Builder
  navListBuilder() {
    Grid() {
      ForEach(this.homeData?.navList, (nav: HomeNav) => {
        GridItem() {
          Column({ space: rvp(8) }) {
            Image(nav.imageURL)
              .width(rvp(58))
              .height(rvp(56))
              .objectFit(ImageFit.Fill)
            Text(nav.title)
              .fontColor($r('app.color.black'))
              .fontSize(rvp(12))
          }
        }
      }, (nav: HomeNav) => nav.id.toString())
    }
    .rowsTemplate('1fr 1fr')
    .columnsTemplate('1fr 1fr 1fr 1fr')
    .rowsGap(rvp(14))
    .columnsGap(rvp(32))
    .margin({ top: rvp(24) })
    .height(rvp(170))
    .width(BasicConstants.FULL_WIDTH)
  }

  @Builder
  titleListBuilder() {
    Row({ space: rvp(32) }) {
      ForEach(this.homeData?.tileList, (title: HomeTitle) => {
        Column({ space: rvp(8) }) {
          Image(title.imageURL)
            .width(BasicConstants.FULL_WIDTH)
            .height(rvp(58))
            .objectFit(ImageFit.Fill)
          Row({ space: rvp(5) }) {
            Text(title.title)
              .fontColor($r('app.color.black'))
              .fontSize(rvp(12))
            Text(title.sub_title)
              .fontColor($r('app.color.gray'))
              .fontSize(rvp(10))
          }
          .width(BasicConstants.FULL_WIDTH)
        }
        .width(rvp(148))
      }, (title: HomeTitle) => title.id.toString())
    }
    .width(BasicConstants.FULL_WIDTH)
    .margin({ top: 12 })
  }

  @Builder
  planListBuilder() {
    Row({ space: 5 }) {
      ForEach(this.homeData?.planList, (plan: HomePlan) => {
        Image(plan.imageURL)
          .width(rvp(78))
          .height(rvp(60))
          .objectFit(ImageFit.Fill)
      }, (plan: HomePlan) => plan.id.toString())
    }
    .margin({ top: rvp(18) })
    .width(BasicConstants.FULL_WIDTH)
  }

  aboutToAppear(): void {
    this.getHomeData()
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      Scroll() {
        Column() {
          this.swiperBuilder()
          // 首页基本信息
          Column() {
            this.navListBuilder()
            this.titleListBuilder()
            this.planListBuilder()
            Image(this.homeData?.adPicture)
              .width(BasicConstants.FULL_WIDTH)
              .height(rvp(60))
              .objectFit(ImageFit.Fill)
              .margin({ top: rvp(10) })
              .shadow({
                radius: rvp(BasicConstants.SHADOW_RADIUS),
                offsetX: 0,
                offsetY: 0,
                color: 'rgba(0,0,0,0.14)'
              })
          }
          .padding({ left: rvp(BasicConstants.PADDING), right: rvp(BasicConstants.PADDING) })
          .width(BasicConstants.FULL_WIDTH)

          // 房源推荐，因为有背景色所以不和上面写在一个column里
          RecommendHouse()
        }
        .width(BasicConstants.FULL_WIDTH)
      }
      .onDidScroll((xOffset: number, yOffset: number) => {
        this.bgColor = this.handleTopBar.handleScroll(xOffset, yOffset).bgColor
        this.fontColor = this.handleTopBar.handleScroll(xOffset, yOffset).fontColor
      })
      .scrollBar(BarState.Off)
      .width(BasicConstants.FULL_WIDTH)
      .height(BasicConstants.FULL_HEIGHT)

      this.topBarBuilder()
    }
    .width(BasicConstants.FULL_WIDTH)
    .height(BasicConstants.FULL_HEIGHT)
  }
}