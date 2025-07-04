import log from '@open/log';
import { getAllAreasByCityId, getAllCitiesByProvinceId, getAllProvinces } from '../../apis/SearchHouseApi';
import { BasicConstants } from '../../common/constants/BasicConstants';
import { rvp } from '../../common/utils/responsiveUtil';
import {
  IAreaModel,
  ICityModel,
  IPriceModel,
  IProvinceModel,
  ISearchHouseParams,
  ISortModel
} from '../../models/HouseModels';

@Component
export default struct SearchFilter {
  @State isShow: boolean = false
  @State searchCondition: string[] = ['位置', '支付方式', '租金', '排序']
  @Watch('handleSearchCondition') @State currentSearchCondition: string = ''
  @State provinceList: Array<IProvinceModel> = []
  @State provinceCode: string = ''
  @State cityList: Array<ICityModel> = []
  @State cityCode: string = ''
  @State areaList: Array<IAreaModel> = []
  @State areaCode: string = ''
  @State submitAreaName: string = '' //下拉列表title
  @State paymentList: string[] = ['月付', '季付', '半年付', '年付']
  @State submitPayment: string = '' //下拉列表title
  @State currentPayment: string = ''
  @State priceList: IPriceModel[] = [
    {
      id: 1,
      minRent: '0',
      maxRent: '0',
      text: '不限'
    },
    {
      id: 2,
      minRent: '0',
      maxRent: '1500',
      text: '1500元以下'
    },
    {
      id: 3,
      minRent: '1500',
      maxRent: '2500',
      text: '1500-2500元'
    },
    {
      id: 4,
      minRent: '2500',
      maxRent: '3500',
      text: '2500-3500元'
    },
    {
      id: 5,
      minRent: '3500',
      maxRent: '4500',
      text: '3500-4500元'
    },
    {
      id: 6,
      minRent: '4500',
      maxRent: '6000',
      text: '4500-6000元'
    },
    {
      id: 7,
      minRent: '6000',
      maxRent: '8000',
      text: '6000-8000元'
    },
    {
      id: 8,
      minRent: '8000',
      maxRent: '10000',
      text: '8000-10000元'
    },
    {
      id: 9,
      minRent: '10000',
      maxRent: '0',
      text: '10000元以上'
    }
  ]
  @State currentPrice: string = ''
  @State submitPrice: string = '' //下拉列表title
  @State sortList: ISortModel[] = [
    {
      id: '1',
      text: '综合排序',
      orderBy: '',
      orderType: '',
      img: $r('app.media.ic_houseSearch_default')
    },
    {
      id: '2',
      text: '价格从低到高',
      orderBy: 'price',
      orderType: 'asc',
      img: $r('app.media.ic_houseSearch_price')
    },
    {
      id: '3',
      text: '价格从高到低',
      orderBy: 'price',
      orderType: 'desc',
      img: $r('app.media.ic_houseSearch_price')
    },
    {
      id: '4',
      text: '面积从低到高',
      orderBy: 'area',
      orderType: 'asc',
      img: $r('app.media.ic_houseSearch_area')
    },
    {
      id: '5',
      text: '面积从高到低',
      orderBy: 'area',
      orderType: 'desc',
      img: $r('app.media.ic_houseSearch_area')
    }
  ]
  @State currentSort: string = ''
  private onSearch = (searchParams: Partial<ISearchHouseParams>) => {
  }
  showWholeCondition = (text: string) => {
    if (this.currentSearchCondition === text) {
      this.isShow = !this.isShow
      return
    }
    this.isShow = true
    this.currentSearchCondition = text
  }

  handleSearchCondition() {
    switch (this.currentSearchCondition) {
      case this.searchCondition[0]:
        this.getAllProvinces()
        break;
      case this.searchCondition[1]:
        this.currentPayment = this.submitPayment
        break;
      case this.searchCondition[2]:
        this.currentPrice = this.submitPrice
        break;
      default:
        break;
    }
  }

  getAllProvinces = async () => {
    this.provinceList = await getAllProvinces<Array<IProvinceModel>>()
    this.provinceCode = this.provinceList[0].code
    this.getAllCities()
  }
  getAllCities = async () => {
    this.cityList = await getAllCitiesByProvinceId<Array<ICityModel>>(this.provinceCode)
    this.cityCode = this.cityList[0].code
    this.getAllAreas()
  }
  getAllAreas = async () => {
    this.areaList = await getAllAreasByCityId<Array<IAreaModel>>(this.cityCode)
    this.areaCode = this.areaList[0].code
  }
  //点击搜索的时候要显示的文字
  getSearchTest = (text: string): string => {
    switch (text) {
      case this.searchCondition[0]:
        text = this.submitAreaName || text
        break;
      case this.searchCondition[1]:
        text = this.submitPayment || text
        break;
      case this.searchCondition[2]:
        text = this.submitPrice || text
        break;
      case this.searchCondition[3]:
        text = this.currentSort || text
        break;
      default:
        break;
    }
    return text
  }
  //点击搜索的时候要显示的文字颜色
  getSearchTestColor = (text: string): ResourceStr => {
    let textColor: ResourceStr = ''
    switch (text) {
      case this.searchCondition[0]:
        textColor = this.submitAreaName ? $r('app.color.primary') : '#333333'
        break;
      case this.searchCondition[1]:
        textColor = this.submitPayment ? $r('app.color.primary') : '#333333'
        break;
      case this.searchCondition[2]:
        textColor = this.submitPrice ? $r('app.color.primary') : '#333333'
        break;
      case this.searchCondition[3]:
        textColor = this.currentSort ? $r('app.color.primary') : '#333333'
        break;
      default:
        textColor = '#333333'
        break;
    }
    return textColor
  }
  resetPosition = () => {
    this.provinceCode = ''
    this.cityCode = ''
    this.areaCode = ''
    this.provinceList = []
    this.getAllProvinces()
  }
  searchPosition = () => {
    this.submitAreaName = this.areaList.find(area => area.code === this.areaCode)!.name
    const searchParams: Partial<ISearchHouseParams> = {
      provinceCode: this.provinceCode,
      cityCode: this.cityCode,
      districtCode: this.areaCode
    }
    this.onSearch(searchParams)
    this.isShow = false
  }
  resetPayment = () => {
    this.currentPayment = ''
  }
  searchPayment = () => {
    this.submitPayment = this.currentPayment
    const searchParams: Partial<ISearchHouseParams> = {
      paymentType: this.currentPayment
    }
    this.onSearch(searchParams)
    this.isShow = false
  }
  resetPrice = () => {
    this.currentPrice = ''
  }
  searchPrice = () => {
    this.submitPrice = this.currentPrice
    const price = this.priceList.find(item => item.text === this.currentPrice)
    const searchParams: Partial<ISearchHouseParams> = {
      minRent: price?.minRent,
      maxRent: price?.maxRent
    }
    this.onSearch(searchParams)
    this.isShow = false
  }

  @Builder
  bottomButtonsBuilder(reset = () => {
  }, search = () => {
  }) {
    Row({ space: rvp(22) }) {
      Button('重置')
        .type(ButtonType.Normal)
        .fontSize(rvp(12))
        .fontColor($r('app.color.gray_second'))
        .width(rvp(96))
        .height(rvp(26))
        .backgroundColor('#F0F0F0')
        .borderRadius(rvp(4))
        .onClick(reset)
      Button('查看房源')
        .type(ButtonType.Normal)
        .fontSize(rvp(12))
        .fontColor($r('app.color.white'))
        .width(rvp(210))
        .height(rvp(26))
        .backgroundColor('#67C0A8')
        .borderRadius(rvp(4))
        .onClick(search)
    }
    .height(rvp(58))
    .width(BasicConstants.FULL_WIDTH)
    .justifyContent(FlexAlign.Center)
    .padding(rvp(16))
  }

  @Builder
  positionBuilder() {
    Row() {
      List() {
        ForEach(this.provinceList, (province: IProvinceModel) => {
          ListItem() {
            Text(province.name)
              .fontColor(this.provinceCode === province.code ? $r('app.color.primary') : $r('app.color.black'))
              .fontSize(rvp(12))
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
          .height(rvp(30))
          .width(BasicConstants.FULL_WIDTH)
          .align(Alignment.Start)
          .padding({ left: rvp(BasicConstants.PADDING), right: rvp(BasicConstants.PADDING) })
          .onClick(() => {
            this.provinceCode = province.code
            this.getAllCities()
          })
        }, (province: IProvinceModel) => province.code)
      }
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.None)
      .backgroundColor($r('app.color.bg_gray'))
      .width(rvp(120))
      .height(BasicConstants.FULL_HEIGHT)

      List() {
        ForEach(this.cityList, (city: ICityModel) => {
          ListItem() {
            Text(city.name)
              .fontColor(this.cityCode === city.code ? $r('app.color.primary') : $r('app.color.black'))
              .fontSize(rvp(12))
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
          .height(rvp(30))
          .width(BasicConstants.FULL_WIDTH)
          .align(Alignment.Start)
          .padding({ left: rvp(BasicConstants.PADDING), right: rvp(BasicConstants.PADDING) })
          .onClick(() => {
            this.cityCode = city.code
            this.getAllAreas()
          })
        }, (city: ICityModel) => city.code)
      }
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.None)
      .backgroundColor('#EBEBEB')
      .width(rvp(120))
      .height(BasicConstants.FULL_HEIGHT)

      List() {
        ForEach(this.areaList, (area: IAreaModel) => {
          ListItem() {
            Text(area.name)
              .fontColor(this.areaCode === area.code ? $r('app.color.primary') : $r('app.color.black'))
              .fontSize(rvp(12))
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
          .height(rvp(30))
          .width(BasicConstants.FULL_WIDTH)
          .align(Alignment.Start)
          .padding({ left: rvp(BasicConstants.PADDING), right: rvp(BasicConstants.PADDING) })
          .onClick(() => {
            this.areaCode = area.code
          })
        }, (area: IAreaModel) => area.code)
      }
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.None)
      .backgroundColor('#E6E6E6')
      .width(rvp(120))
      .height(BasicConstants.FULL_HEIGHT)
    }
    .height(rvp(240))
    .width(BasicConstants.FULL_WIDTH)

    this.bottomButtonsBuilder(this.resetPosition, this.searchPosition)
  }

  @Builder
  paymentBuilder() {
    Row() {
      ForEach(this.paymentList, (payment: string) => {
        Text(payment)
          .textExtends(this.currentPayment === payment, 70)
          .onClick(() => {
            this.currentPayment = payment
          })
      }, (payment: string) => payment)
    }
    .padding(rvp(BasicConstants.PADDING))
    .justifyContent(FlexAlign.SpaceBetween)
    .width(BasicConstants.FULL_WIDTH)

    this.bottomButtonsBuilder(this.resetPayment, this.searchPayment)
  }

  @Builder
  rentBuilder() {
    Grid() {
      ForEach(this.priceList, (price: IPriceModel) => {
        GridItem() {
          Text(price.text)
            .textExtends(this.currentPrice === price.text, 94)
        }
        .onClick(() => {
          this.currentPrice = price.text
        })
      }, (price: IPriceModel) => price.id.toString())
    }
    .padding(rvp(BasicConstants.PADDING))
    .width(BasicConstants.FULL_WIDTH)
    .columnsTemplate('1fr 1fr 1fr')
    .rowsGap(rvp(8))
    .height(rvp(120))

    this.bottomButtonsBuilder(this.resetPrice, this.searchPrice)
  }

  @Builder
  orderBuilder() {
    Column() {
      ForEach(this.sortList, (sort: ISortModel) => {
        Row({ space: rvp(8) }) {
          Image(sort.img)
            .width(rvp(16))
            .height(rvp(16))
            .fillColor(this.currentSort === sort.text ? '#67C0A8' : '#666666')
          Text(sort.text)
            .fontSize(rvp(12))
            .fontColor(this.currentSort === sort.text ? '#67C0A8' : $r('app.color.gray_second'))
        }
        .padding({ top: rvp(8), bottom: rvp(8) })
        .onClick(() => {
          this.currentSort = sort.text
          const searchParams: Partial<ISearchHouseParams> = {
            orderBy: sort.orderBy,
            orderType: sort.orderType
          }
          this.onSearch(searchParams)
          this.isShow = false
        })
      }, (sort: ISortModel) => sort.id)
    }
    .width(BasicConstants.FULL_WIDTH)
    .padding({ left: rvp(32), bottom: rvp(BasicConstants.PADDING) })
    .alignItems(HorizontalAlign.Start)
  }

  build() {
    Column() {
      Row() {
        ForEach(this.searchCondition, (text: string) => {
          Row({ space: rvp(6) }) {
            Text(this.getSearchTest(text))
              .fontColor(this.getSearchTestColor(text))
              .fontSize(rvp(14))
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .constraintSize({ maxWidth: rvp(56) })
            Image(this.currentSearchCondition === text && this.isShow ? $r('app.media.ic_searchFilter_arrow_up') :
            $r('app.media.ic_searchFilter_arrow_down')).width(rvp(12)).height(rvp(12))
          }
          .onClick(() => {
            this.showWholeCondition(text)
          })
        }, (text: string) => text)
      }
      .width(BasicConstants.FULL_WIDTH)
      .height(rvp(44))
      .padding({ left: rvp(BasicConstants.PADDING), right: rvp(BasicConstants.PADDING) })
      .justifyContent(FlexAlign.SpaceBetween)
      .backgroundColor($r('app.color.white'))

      if (this.isShow) {
        // 具体筛选条件
        Column() {
          if (this.currentSearchCondition === this.searchCondition[0]) {
            this.positionBuilder()
          } else if (this.currentSearchCondition === this.searchCondition[1]) {
            this.paymentBuilder()
          } else if (this.currentSearchCondition === this.searchCondition[2]) {
            this.rentBuilder()
          } else if (this.currentSearchCondition === this.searchCondition[3]) {
            this.orderBuilder()
          }
        }
        .width(BasicConstants.FULL_WIDTH)
        .backgroundColor($r('app.color.white'))

        // 遮罩层
        Column() {

        }
        .width(BasicConstants.FULL_WIDTH)
        .layoutWeight(1)
        .backgroundColor('rgba(0,0,0,0.7)')
        .onClick(() => {
          this.isShow = false
        })
      }
    }
    .width(BasicConstants.FULL_WIDTH)
    .height(this.isShow ? BasicConstants.FULL_HEIGHT : rvp(44))
    .margin({ top: rvp(44) })
  }
}

@Extend(Text)
function textExtends(active: boolean, width: number) {
  .width(rvp(width))
  .height(rvp(26))
  .borderRadius(rvp(4))
  .backgroundColor(active ? '#67C0A8' : $r('app.color.bg_gray'))
  .fontSize(rvp(12))
  .fontColor(active ? $r('app.color.white') : $r('app.color.gray_second'))
  .textAlign(TextAlign.Center)
}