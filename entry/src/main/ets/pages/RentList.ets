import log from '@open/log';
import { searchHouses } from '../apis/SearchHouseApi';
import { BasicConstants } from '../common/constants/BasicConstants';
import { rvp } from '../common/utils/responsiveUtil';
import NavBar from '../components/common/NavBar';
import SearchFilter from '../components/common/SearchFilter';
import { IHouseModel, IHouseTag, ISearchHouseParams, ISearchHouseResponse } from '../models/HouseModels';
import { MyLazyDataSource } from '../models/MyLazyDataSource';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct RentList {
  @StorageProp('safeTop') safeTop: number = 0;
  @State houseListLazyData: MyLazyDataSource<IHouseModel> = new MyLazyDataSource()
  @State totalHouses: number = 0
  @State hasMore: boolean = true
  @State noData: boolean = false
  @State searchParams: ISearchHouseParams = {
    page: 1,
    limit: 10
  }
  searchHouses = async () => {
    const res = await searchHouses<ISearchHouseResponse>(this.searchParams)
    if (this.searchParams.page === 1) { // page唯一代表改变搜索条件了
      this.houseListLazyData.dataArray = []
    }
    if (res.records.length > 0) {
      this.houseListLazyData.pushAllData(res.records)
      this.totalHouses = parseInt(res.total)
      if (this.totalHouses > this.houseListLazyData.totalCount()) {
        this.hasMore = true
      } else {
        this.hasMore = false
      }
      this.noData = false
    } else {
      this.noData = true
    }
  }
  loadMore = () => {
    if (this.houseListLazyData.totalCount() >= this.totalHouses) {
      this.hasMore = false
      return
    }
    this.searchParams.page++
    this.searchHouses()
  }
  onSearch = (searchParams: ISearchHouseParams) => {
    Object.keys(searchParams).forEach(key => {
      Reflect.set(this.searchParams, key, Reflect.get(searchParams, key))
    })
    this.searchParams.page = 1
    this.searchHouses()
  }

  aboutToAppear(): void {
    this.searchHouses()
  }

  @Builder
  waterFlowFooterBuilder() {
    Row() {
      if (this.hasMore) {
        LoadingProgress()
          .color($r('app.color.primary'))
          .width(28)
          .height(28)
        Text('努力加载中...')
          .fontColor($r('app.color.primary'))
      } else {
        Text('没有更多数据了')
          .fontColor($r('app.color.primary'))
      }
    }
    .width(BasicConstants.FULL_WIDTH)
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      if (this.noData) {
        Column() {
          Text('抱歉，暂无符合条件的房源').fontSize(rvp(16)).fontColor($r('app.color.gray'))
        }.width(BasicConstants.FULL_WIDTH).height(BasicConstants.FULL_HEIGHT).justifyContent(FlexAlign.Center)
      } else {
        WaterFlow({ footer: this.waterFlowFooterBuilder }) {
          LazyForEach(this.houseListLazyData, (house: IHouseModel) => {
            FlowItem() {
              Column() {
                if (house.activity) {
                  Row({ space: rvp(4) }) {
                    Image(house.activity.icon).width(rvp(26)).height(rvp(26)).objectFit(ImageFit.Fill)
                    Text(house.activity.title).fontColor($r('app.color.black')).fontSize(rvp(14)).fontWeight(700)
                  }.width(BasicConstants.FULL_WIDTH)
                  .justifyContent(FlexAlign.Start)

                  Text(Reflect.get(house.activity, '#text'))
                    .padding({
                      left: rvp(8),
                      top: rvp(4),
                      right: rvp(8),
                      bottom: rvp(4)
                    })
                    .alignSelf(ItemAlign.Start)
                    .backgroundColor(house.activity.textBackGroundColor)
                    .fontColor(house.activity.textColor)
                    .fontSize(rvp(10))
                    .fontWeight(700)
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .constraintSize({ maxWidth: BasicConstants.FULL_WIDTH })
                    .margin({ top: rvp(4), bottom: rvp(4) })
                }

                Stack({ alignContent: Alignment.BottomStart }) {
                  Image(house.housePicture)
                    .width(BasicConstants.FULL_WIDTH)
                    .height(BasicConstants.FULL_HEIGHT)
                    .objectFit(ImageFit.Fill).borderRadius(house.activity ? rvp(8) : 0)
                  if (!house.activity) {
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
                }
                .width(BasicConstants.FULL_WIDTH)
                .height(house.activity ? rvp(164) : rvp(120))

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
              .width(BasicConstants.FULL_WIDTH)
              .borderRadius({ topLeft: rvp(BasicConstants.BORDER_RADIUS), topRight: rvp(BasicConstants.BORDER_RADIUS) })
              .clip(true)
              .backgroundColor($r('app.color.white'))
              .height(BasicConstants.FULL_HEIGHT)
            }.width(rvp(160)).height(house.activity ? rvp(320) : rvp(210))
            .onClick(() => {
              router.pushUrl({
                url: 'pages/HouseDetail',
                params: {
                  id: house.id
                }
              })
            })
          }, (house: IHouseModel) => house.id)
        }
        .height(BasicConstants.FULL_HEIGHT)
        .backgroundColor($r('app.color.bg_gray'))
        .width(BasicConstants.FULL_WIDTH)
        .columnsTemplate('1fr 1fr')
        .columnsGap(rvp(8))
        .padding({
          top: rvp(88),
          left: rvp(BasicConstants.PADDING),
          right: rvp(BasicConstants.PADDING),
          bottom: rvp(BasicConstants.PADDING)
        })
        .onReachEnd(this.loadMore)
      }

      SearchFilter({ onSearch: this.onSearch })
      NavBar({ title: '房源列表' })
    }
    .padding({ top: this.safeTop })
    .height(BasicConstants.FULL_HEIGHT)
    .width(BasicConstants.FULL_WIDTH)
  }
}