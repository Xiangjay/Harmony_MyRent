import { getRecommendHouse } from '../../apis/HomeApis'
import { BasicConstants } from '../../common/constants/BasicConstants'
import { rvp } from '../../common/utils/responsiveUtil'
// import { IRecommendHouse, RecommendHouseTag } from '../../models/HomeDataModels'
import { MyLazyDataSource } from '../../models/MyLazyDataSource'
import { router } from '@kit.ArkUI'
import { IHouseModel, IHouseTag } from '../../models/HouseModels'

@Component
export default struct RecommendHouse {
  @State recommendHouseLazyData: MyLazyDataSource<IHouseModel> = new MyLazyDataSource()
  getRecommendHouse = async () => {
    const res = await getRecommendHouse<Array<IHouseModel>>()
    this.recommendHouseLazyData.pushAllData(res)
  }

  aboutToAppear(): void {
    this.getRecommendHouse()
  }

  build() {
    Column({ space: BasicConstants.PADDING_S }) {
      Row() {
        Text() {
          Span('周边房源')
          Span('推荐')
            .fontColor($r('app.color.primary'))
        }
        .fontSize(rvp(16))
        .fontWeight(700)
        .fontColor($r('app.color.black'))

        Row({ space: rvp(6) }) {
          Text('更多推荐')
            .fontSize(rvp(10))
            .fontColor($r('app.color.gray_second'))
          Image($r('app.media.ic_arrow_right'))
            .width(rvp(4))
            .height(rvp(8))
        }
        .onClick(() => {
          router.pushUrl({
            url: 'pages/RentList'
          })
        })
      }
      .padding({ left: BasicConstants.PADDING, right: BasicConstants.PADDING })
      .width(BasicConstants.FULL_WIDTH)
      .justifyContent(FlexAlign.SpaceBetween)

      Grid() {
        LazyForEach(this.recommendHouseLazyData, (house: IHouseModel) => {
          GridItem() {
            Column() {
              Stack({ alignContent: Alignment.BottomStart }) {
                Image(house.housePicture)
                  .width(BasicConstants.FULL_WIDTH)
                  .height(BasicConstants.FULL_HEIGHT)
                  .objectFit(ImageFit.Fill)
                Image($r('app.media.recommend_house_bg'))
                  .width(BasicConstants.FULL_WIDTH)
                  .height(BasicConstants.FULL_HEIGHT)
                  .objectFit(ImageFit.Fill)
                Row({ space: rvp(6) }) {
                  Image($r('app.media.ic_location'))
                    .width(rvp(12))
                    .height(rvp(14))
                  Text(house.address)
                    .fontColor($r('app.color.white'))
                    .fontSize(rvp(10))
                }
                .margin({ left: rvp(8), bottom: rvp(6) })
              }
              .width(BasicConstants.FULL_WIDTH)
              .height(rvp(120))

              Column() {
                Row() {
                  Text(house.rentPriceListing + house.rentPriceUnit)
                    .fontSize(rvp(14))
                    .fontColor($r('app.color.price'))
                  Text(house.rentArea + '㎡')
                    .fontSize(rvp(10))
                    .fontColor($r('app.color.gray'))
                }
                .margin({ top: rvp(10) })
                .width(BasicConstants.FULL_WIDTH)
                .justifyContent(FlexAlign.SpaceBetween)

                Text(house.houseTitle)
                  .fontSize(rvp(12))
                  .fontColor($r('app.color.black'))
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .width(BasicConstants.FULL_WIDTH)
                  .margin({ top: 6 })
                Row({ space: 6 }) {
                  ForEach(house.tags.slice(0, 2), (tag: IHouseTag, index: number) => {
                    Text(tag.name)
                      .fontSize(rvp(10))
                      .fontColor(index === 1 ? '#B3B3B3' : $r('app.color.white'))
                      .backgroundColor(index === 1 ? $r('app.color.bg_gray') : $r('app.color.primary'))
                      .padding({ left: rvp(6), right: rvp(6) })
                      .height(rvp(16))
                      .borderRadius(rvp(2))
                  }, (tag: IHouseTag) => tag.name)
                }
                .margin({ top: rvp(10) })
                .width(BasicConstants.FULL_WIDTH)
              }
              .width(BasicConstants.FULL_WIDTH)
              .padding({ left: rvp(BasicConstants.PADDING_S), right: rvp(BasicConstants.PADDING_S), bottom: rvp(12) })
            }
            .width(rvp(160))
            .borderRadius({ topLeft: rvp(BasicConstants.BORDER_RADIUS), topRight: rvp(BasicConstants.BORDER_RADIUS) })
            .clip(true)
            .backgroundColor($r('app.color.white'))
            .onClick(() => {
              router.pushUrl({
                url: 'pages/HouseDetail',
                params: {
                  id: house.id
                }
              })
            })
          }
        }, (house: IHouseModel) => house.id)
      }
      .width(BasicConstants.FULL_WIDTH)
      .backgroundColor($r('app.color.bg_gray'))
      .columnsTemplate('1fr 1fr')
      .rowsGap(rvp(8))
    }
    .width(BasicConstants.FULL_WIDTH)
    .margin({ top: rvp(32) })
  }
}