import {
  IHouseDetailModel,
  IHouseDetailRouterParams,
  IHouseDetailDiscounts,
  IHouseDetailMetaInfo,
  IHouseDetailTag,
  IHouseDetailRentInfo,
  IHouseDetailHouseHold,
  IHouseDetailHouseHoldItemList,
  IHouseSupport,
  IReservation,
  IReservedHouse
} from '../models/HouseModels'
import { PromptAction, router, window } from '@kit.ArkUI'
import log from '@open/log'
import { bookReservation, getHouseDetailById, getReservationByToken } from '../apis/HouseDetailApis'
import NavBar from '../components/common/NavBar'
import { BasicConstants } from '../common/constants/BasicConstants'
import { rvp } from '../common/utils/responsiveUtil'
import { dateFormat, IFormatDate } from '../common/utils/dateFormatUtils'

//因为图片地址有重复的，为了处理滚动联动定义下页面需要的类型
interface housePicture {
  spaceName: string,
  picList: housePictureList[]
}

interface housePictureList {
  id: string
  url: string
}

@Entry
@Component
struct HouseDetail {
  windowClass: window.Window = AppStorage.get("windowClass") as window.Window;
  @StorageProp('safeTop') safeTop: number = 0;
  @StorageProp('token') token: string = ''
  @State house: IHouseDetailModel | null = null
  @State housePicture: housePicture[] = [] // 用于展示
  @State housePictureList: housePictureList[] = [] // 用于展示
  @State currentHousePictureNameIndex: number = 0
  private pictureListScroller: ListScroller = new ListScroller();
  @State isScrolling: boolean = false // 用于控制list联动
  // 下面是预约看房相关的
  @State showBook: boolean = false //显示弹窗
  @State dateList: Array<IFormatDate> = [] // 日期列表
  @State selectedDate: IFormatDate | null = null
  @State showDateList: boolean = true
  @State reservation: IReservation | null = null
  @State alreadyReserved: boolean = false // 已经预约过
  @State reserved: boolean = false // 预约成功
  private uiContext: UIContext = this.getUIContext();
  private promptAction: PromptAction = this.uiContext.getPromptAction(); //提示弹窗
  getHouseDetail = async (id: string) => {
    this.house = await getHouseDetailById<IHouseDetailModel>(id)
    this.house.housePicture.forEach((item, i) => {
      const picture: housePicture = { spaceName: item.spaceName, picList: [] }
      item.picList.forEach((pic, index) => {
        const pictureItem: housePictureList = { id: '', url: '' }
        pictureItem.id = i + '' + index
        pictureItem.url = pic
        picture.picList.push(pictureItem)
        this.housePictureList.push(pictureItem)
      })
      this.housePicture.push(picture)
    })
  }
  checkReservation = async () => {
    if (this.reservation?.name === '') {
      this.promptAction.showToast({
        message: '请输入姓名',
        duration: 1000,
        textColor: Color.Red
      })
      return
    }
    const reg = /^[1][3-9][0-9]{9}$/;
    if (this.reservation?.phone === '' || !reg.test(this.reservation!.phone)) {
      this.promptAction.showToast({
        message: '请输入正确的手机号',
        duration: 1000,
        textColor: Color.Red
      })
      return
    }
    //同一个房子好像只能预约一次
    try {
      const res = await bookReservation<null>(this.reservation!)
      this.promptAction.showToast({
        message: '预约成功！',
        duration: 1000,
      })
      this.reserved = true
      this.showBook = false
    } catch (e) {
      this.promptAction.showToast({
        message: '已预约过该房，请勿重复预约！',
        duration: 1000,
      })
    }
  }
  getReservations = async () => {
    const res = await getReservationByToken<IReservedHouse[]>()
    this.alreadyReserved = res.some(item => item.houseId === this.house!.id)
  }

  aboutToAppear(): void {
    this.windowClass.setWindowSystemBarProperties({
      statusBarContentColor: '#000000'
    });
    const routerParams: IHouseDetailRouterParams = router.getParams() as IHouseDetailRouterParams
    this.getHouseDetail(routerParams.id)
    if (this.token) {
      this.getReservations()
    }
  }

  @Styles
  paddingStyle(){
    .padding({ left: rvp(BasicConstants.PADDING), right: rvp(BasicConstants.PADDING) })
  }

  @Builder
  pictureScrollBuilder() {
    List({ space: rvp(16) }) {
      ForEach(this.housePicture, (item: housePicture, index: number) => {
        ListItem() {
          Column({ space: rvp(4) }) {
            Text(`${item.spaceName}(${item.picList.length})`)
              .fontSize(rvp(14))
              .fontColor(this.currentHousePictureNameIndex === index ? $r('app.color.black') :
              $r('app.color.gray_second'))
            if (this.currentHousePictureNameIndex === index) {
              Row() {
              }.width(rvp(16)).height(rvp(2)).backgroundColor($r('app.color.primary'))
            }
          }
        }.margin({ right: index === this.house!.housePicture.length - 1 ? rvp(BasicConstants.PADDING) : 0 })
        .onClick(() => {
          this.currentHousePictureNameIndex = index
          const pictureId = item.picList[0].id // 找到当前第一张图
          const pictureIndex =
            this.housePictureList.findIndex(item => item.id === pictureId) //因为housePictureList是push进去的，所以可以直接找下标
          this.pictureListScroller.scrollToIndex(pictureIndex, true)
          this.isScrolling = true
        })
      }, (item: housePicture) => item.spaceName)
    }
    .height(rvp(58))
    .width(BasicConstants.FULL_WIDTH)
    .listDirection(Axis.Horizontal)
    .padding({
      left: rvp(BasicConstants.PADDING),
      top: rvp(BasicConstants.PADDING),
      bottom: rvp(BasicConstants.PADDING),
    })
    .edgeEffect(EdgeEffect.None)
    .scrollBar(BarState.Off)

    List({ scroller: this.pictureListScroller }) {
      ForEach(this.housePictureList, (item: housePictureList) => {
        ListItem() {
          Image(item.url).width(rvp(318)).height(rvp(192)).objectFit(ImageFit.Fill)
        }
        .margin({ left: rvp(16) })
      }, (item: housePictureList) => item.id)
      ListItem() {
      }.width(rvp(16))
    }
    .height(rvp(208))
    .width(BasicConstants.FULL_WIDTH)
    .listDirection(Axis.Horizontal)
    .padding({ bottom: rvp(BasicConstants.PADDING) })
    .edgeEffect(EdgeEffect.None)
    .scrollBar(BarState.Off)
    .onScrollIndex((startIndex: number) => {
      if (this.isScrolling) {
        return
      }
      if (this.house) {
        let pictureNum = 0
        this.currentHousePictureNameIndex = this.house.housePicture.findIndex((item) => {
          pictureNum += item.picList.length
          return startIndex < pictureNum
        })
      }
    })
    .onScrollStop(() => {
      this.isScrolling = false
    })
  }

  @Builder
  bottomBuilder() {
    Row({ space: rvp(20) }) {
      Row({ space: 26 }) {
        Column() {
          Image($r('app.media.ic_detail_like')).width(18).height(rvp(18))
          Text('99+').textStyles(10, $r('app.color.gray'))
        }

        Column() {
          Image($r('app.media.ic_detail_consult')).width(18).height(rvp(18))
          Text('咨询').textStyles(10, $r('app.color.gray'))
        }
      }

      Row({ space: rvp(14) }) {
        Button(this.alreadyReserved ? '已预约' : '立即预定')
          .type(ButtonType.Normal)
          .fontColor($r('app.color.white'))
          .fontSize(rvp(14))
          .backgroundColor($r('app.color.primary'))
          .borderRadius(rvp(2))
          .width(BasicConstants.FULL_WIDTH)
          .enabled(!this.reserved && !this.alreadyReserved)
          .onClick(() => {
            if (this.token) {
              this.showBook = true
            } else {
              router.pushUrl({
                url: 'pages/Login'
              })
            }
          })
      }
      .layoutWeight(1)
    }
    .padding({
      top: rvp(8),
      bottom: rvp(8),
      left: rvp(16),
      right: rvp(16)
    })
    .backgroundColor($r('app.color.white'))
    .width(BasicConstants.FULL_WIDTH)
    .height(rvp(50))
  }

  @Builder
  bookBuilder() {
    Column() {
      Column({ space: rvp(16) }) {
        Row({ space: rvp(16) }) {
          Text('姓名').width(rvp(56)).textStyles()
          TextInput({ placeholder: '请输入姓名' }).textInputStyles()
            .onChange((val: string) => {
              this.reservation!.name = val
            })
        }

        Row({ space: rvp(16) }) {
          Text('手机号').width(rvp(56)).textStyles()
          TextInput({ placeholder: '请输入手机号' }).textInputStyles()
            .type(InputType.Number)
            .maxLength(11)
            .onChange((val: string) => {
              this.reservation!.phone = val
            })
        }

        Row() {
          Row({ space: rvp(16) }) {
            Text('预约日期').width(rvp(56)).textStyles()
            Text(`${this.selectedDate?.date} （${this.selectedDate?.day}）`)
              .fontSize(rvp(14))
              .fontColor($r('app.color.gray'))
          }

          Image(this.showDateList ? $r('app.media.ic_detail_book_arrow_up') : $r('app.media.ic_detail_book_arrow_down'))
            .width(rvp(24))
            .height(rvp(24))
            .onClick(() => {
              this.showDateList = !this.showDateList
            })
        }
        .width(BasicConstants.FULL_WIDTH)
        .justifyContent(FlexAlign.SpaceBetween)

        if (this.showDateList) {
          Grid() {
            ForEach(this.dateList, (item: IFormatDate) => {
              GridItem() {
                Column() {
                  Text(item.day)
                    .fontSize(10)
                    .fontColor(this.selectedDate?.date === item.date ? $r('app.color.primary') : $r('app.color.gray'))
                  Text(item.date)
                    .fontSize(10)
                    .fontColor(this.selectedDate?.date === item.date ? $r('app.color.primary') : $r('app.color.gray'))
                }
                .padding({
                  left: rvp(8),
                  top: rvp(4),
                  right: rvp(8),
                  bottom: rvp(4)
                })
                .borderWidth(rvp(1))
                .borderColor(this.selectedDate?.date === item.date ? $r('app.color.primary') : '##E4E4E4')
                .borderRadius(rvp(4))
                .height(rvp(32))
                .onClick(() => {
                  this.selectedDate = item
                  this.reservation!.date = item.date
                })
              }
            })
          }
          .columnsTemplate('1fr 1fr 1fr')
          .columnsGap(rvp(6))
          .rowsGap(rvp(8))
          .margin({ left: rvp(72) })
        }

        Row({ space: rvp(16) }) {
          Text('备注信息').width(rvp(56)).textStyles()
          TextArea({ placeholder: '请输入备注信息' })
            .backgroundColor('#F6F6F6')
            .layoutWeight(1)
            .borderRadius(0)
            .height(rvp(60))
            .onChange((val: string) => {
              this.reservation!.comment = val
            })
        }
        .alignItems(VerticalAlign.Top)
      }
      .borderRadius(rvp(4))
      .padding(rvp(16))
      .width(BasicConstants.FULL_WIDTH)
      .backgroundColor($r('app.color.white'))

      Button('预约看房')
        .type(ButtonType.Normal)
        .width(BasicConstants.FULL_WIDTH)
        .backgroundColor('#24A17B')
        .onClick(this.checkReservation)
    }
    .padding({ left: rvp(16), right: rvp(16) })
    .width(BasicConstants.FULL_WIDTH)
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      Stack({ alignContent: Alignment.Bottom }) {
        Scroll() {
          Column() {
            this.pictureScrollBuilder()
            Column() {
              Row() {
                Row() {
                  Text('￥').textStyles()
                  Text(this.house?.rentPriceUnitListing).textStyles(26)
                  Text(this.house?.rentPriceUnit).textStyles()
                }.alignItems(VerticalAlign.Bottom)

                Row({ space: rvp(8) }) {
                  Text('租金试算').textStyles(12, $r('app.color.gray'))
                  Image($r('app.media.ic_arrow_right')).width(rvp(4)).height(rvp(8))
                }
              }
              .margin({ bottom: rvp(8) })
              .justifyContent(FlexAlign.SpaceBetween)
              .width(BasicConstants.FULL_WIDTH)

              ForEach(this.house?.discounts, (discount: IHouseDetailDiscounts) => {
                Row() {
                  Row({ space: rvp(8) }) {
                    Image(discount.image).height(rvp(20))
                    Text(discount.txt).textStyles(12, $r('app.color.gray'))
                  }.alignItems(VerticalAlign.Bottom)

                  Image($r('app.media.ic_arrow_right')).width(rvp(4)).height(rvp(8)).fillColor($r('app.color.primary'))
                }
                .margin({ bottom: rvp(16) })
                .justifyContent(FlexAlign.SpaceBetween)
                .width(BasicConstants.FULL_WIDTH)
              })
              Row({ space: rvp(4) }) {
                Grid() {
                  ForEach(this.house?.metaInfo, (metaInfo: IHouseDetailMetaInfo) => {
                    GridItem() {
                      Column({ space: rvp(6) }) {
                        Text(metaInfo.name).textStyles(12, $r('app.color.gray'))
                        Text(metaInfo.desc).textStyles()
                      }
                      .alignItems(HorizontalAlign.Start)
                      .width(BasicConstants.FULL_WIDTH)
                    }
                  })
                }
                .backgroundColor('#F8F9FC')
                .borderRadius(4)
                .padding(rvp(10))
                .height(BasicConstants.FULL_HEIGHT)
                .rowsTemplate('1fr 1fr')
                .columnsTemplate('1fr 1fr')
                .columnsGap(rvp(10))
                .rowsGap(rvp(8))
                .width(rvp(162))

                Column({ space: rvp(4) }) {
                  Column() {
                    if (this.house?.distanceInfo && this.house.distanceInfo.line) {
                      Row() {
                        // 暂时没找到有地铁信息的房源
                      }
                    } else {
                      Column() {
                        Text('该房源附近没有地铁').textStyles(12)
                      }
                      .width(BasicConstants.FULL_WIDTH)
                      .height(BasicConstants.FULL_WIDTH)
                      .justifyContent(FlexAlign.Center)
                    }
                  }
                  .backgroundColor('#F8F8FB')
                  .height(rvp(50))
                  .width(BasicConstants.FULL_WIDTH)

                  Column({ space: rvp(4) }) {
                    Row() {
                      Row() {
                        Image($r('app.media.ic_detail_bag')).width(rvp(16)).height(rvp(16))
                        Text('设置公司').textStyles(12)
                      }

                      Image($r('app.media.ic_arrow_right')).width(rvp(4)).height(rvp(8))
                    }
                    .justifyContent(FlexAlign.SpaceBetween)
                    .width(BasicConstants.FULL_WIDTH)

                    Text('这里查看到公司需要多久').textStyles(12, $r('app.color.gray'))
                  }
                  .alignItems(HorizontalAlign.Start)
                  .justifyContent(FlexAlign.Center)
                  .padding({ left: rvp(8), right: rvp(8) })
                  .height(rvp(50))
                  .backgroundColor('#F8F8FB')
                  .width(BasicConstants.FULL_WIDTH)
                }
                .width(rvp(162))
              }
              .height(rvp(104))
              .width(BasicConstants.FULL_WIDTH)

              Row({ space: rvp(14) }) {
                ForEach(this.house?.tags, (tag: IHouseDetailTag) => {
                  Text(tag.name)
                    .textStyles(10)
                    .padding({
                      left: rvp(8),
                      top: rvp(4),
                      right: rvp(8),
                      bottom: rvp(4)
                    })
                    .backgroundColor('#F7F7F7')
                    .borderRadius(rvp(2))
                })
              }
              .margin({ top: rvp(8), bottom: rvp(8) })
              .width(BasicConstants.FULL_WIDTH)

              Column({ space: rvp(16) }) {
                Row({ space: rvp(16) }) {
                  Text('入住').fontColor($r('app.color.gray'))
                  Text(this.house?.rentTerm.term).textStyles()
                }

                Row({ space: rvp(16) }) {
                  Text('租期').fontColor($r('app.color.gray'))
                  Text(this.house?.rentTerm.checkInTime).textStyles()
                }

                Row() {
                  Row({ space: rvp(16) }) {
                    Text('厨房').fontColor($r('app.color.gray'))
                    Text(this.house?.rentTerm.kitchen).textStyles()
                  }
                  .width('50%')

                  Row({ space: rvp(16) }) {
                    Text('电梯').fontColor($r('app.color.gray'))
                    Text(this.house?.rentTerm.lift).textStyles()
                  }
                  .width('50%')
                }
                .width(BasicConstants.FULL_WIDTH)

                Row() {
                  Row({ space: rvp(16) }) {
                    Text('年代').fontColor($r('app.color.gray'))
                    Text(this.house?.rentTerm.year).textStyles()
                  }
                  .width('50%')

                  Row({ space: rvp(16) }) {
                    Text('装修').fontColor($r('app.color.gray'))
                    Text(this.house?.rentTerm.renovation).textStyles()
                  }
                  .width('50%')
                }
                .width(BasicConstants.FULL_WIDTH)

                Row() {
                  Row({ space: rvp(16) }) {
                    Text('上架').fontColor($r('app.color.gray'))
                    Text(this.house?.rentTerm.grounding).textStyles()
                  }
                  .width('50%')

                  Row({ space: rvp(16) }) {
                    Text('供暖').fontColor($r('app.color.gray'))
                    Text(this.house?.rentTerm.heating).textStyles()
                  }
                  .width('50%')
                }
                .width(BasicConstants.FULL_WIDTH)

                Row({ space: rvp(16) }) {
                  Text('绿化').fontColor($r('app.color.gray'))
                  Text(this.house?.rentTerm.green).textStyles()
                }

                Row({ space: rvp(16) }) {
                  Text('环保').fontColor($r('app.color.gray'))
                  Row() {
                    Text(this.house?.rentTerm.protection).textStyles()
                    Text('查看报告').margin({ left: rvp(10) }).textStyles(12, $r('app.color.gray'))
                    Image($r('app.media.ic_arrow_right')).width(rvp(4)).height(rvp(8)).margin({ left: rvp(6) })
                  }
                }

                Row({ space: rvp(16) }) {
                  Text('小区').fontColor($r('app.color.gray'))
                  Row() {
                    Text(this.house?.rentTerm.house).textStyles().fontColor('#FF4141')
                    Image($r('app.media.ic_arrow_right'))
                      .width(rvp(4))
                      .height(rvp(8))
                      .fillColor('#FF4141')
                      .margin({ left: rvp(6) })
                  }
                }
              }
              .alignItems(HorizontalAlign.Start)
              .margin({ top: rvp(8), bottom: rvp(8) })
              .width(BasicConstants.FULL_WIDTH)

              Row() {
                Text('*部分房源信息详见底部详解').textStyles(10, $r('app.color.gray'))
                Row({ space: rvp(4) }) {
                  Text('*房屋状况说明书').textStyles(10, $r('app.color.gray'))
                  Image($r('app.media.ic_arrow_right')).width(rvp(4)).height(rvp(8))
                }
              }
              .justifyContent(FlexAlign.SpaceBetween)
              .margin({ top: rvp(8), bottom: rvp(8) })
              .width(BasicConstants.FULL_WIDTH)

              Column() {
                Text('房屋信息').textStyles(rvp(18)).margin({ bottom: rvp(16) }).fontWeight(700)
                Column({ space: rvp(8) }) {
                  ForEach(this.house?.rentInfo, (rentInfo: IHouseDetailRentInfo) => {
                    Row() {
                      Row({ space: rvp(8) }) {
                        Image(rentInfo.image).width(rvp(34)).height(rvp(34))
                        Text(rentInfo.title).textStyles(12)
                      }

                      Text(rentInfo.userTag).textStyles(12, $r('app.color.gray'))
                    }
                    .justifyContent(FlexAlign.SpaceBetween)
                    .alignItems(VerticalAlign.Center)
                    .padding({ left: rvp(10), right: rvp(10) })
                    .backgroundColor('#FAF8FB')
                    .width(BasicConstants.FULL_WIDTH)
                    .borderRadius(rvp(4))
                  })
                }
                .width(BasicConstants.FULL_WIDTH)

                Text('*已出租房屋为您展示房屋签约人信息').textStyles(10, $r('app.color.gray'))
                  .margin({ top: rvp(8) })
              }
              .alignItems(HorizontalAlign.Start)
              .margin({ top: rvp(24), bottom: rvp(8) })
              .width(BasicConstants.FULL_WIDTH)

              Column() {
                Text('物品配置').textStyles(rvp(18)).margin({ bottom: rvp(16) }).fontWeight(700)
                Column({ space: rvp(24) }) {
                  ForEach(this.house?.householdItem, (household: IHouseDetailHouseHold) => {
                    Column({ space: rvp(16) }) {
                      Row({ space: rvp(10) }) {
                        Text(household.name).textStyles()
                        Text(`${household.itemList.length}件物品`).textStyles(10, $r('app.color.gray'))
                      }

                      Grid() {
                        ForEach(household.itemList, (item: IHouseDetailHouseHoldItemList) => {
                          GridItem() {
                            Row({ space: rvp(4) }) {
                              Image(item.icon).width(rvp(16)).height(rvp(16))
                              Text(item.value).fontColor($r('app.color.gray_second'))
                            }
                            .width(BasicConstants.FULL_WIDTH)
                            .justifyContent(FlexAlign.Start)
                          }
                        })
                      }
                      .columnsTemplate('1fr 1fr 1fr')
                      .rowsGap(rvp(16))
                      .width(BasicConstants.FULL_WIDTH)
                    }
                    .alignItems(HorizontalAlign.Start)
                    .width(BasicConstants.FULL_WIDTH)
                  })
                }
                .width(BasicConstants.FULL_WIDTH)
              }
              .alignItems(HorizontalAlign.Start)
              .margin({ top: rvp(24), bottom: rvp(8) })
              .width(BasicConstants.FULL_WIDTH)

              Column() {
                Text('租住服务与保障').textStyles(rvp(18)).margin({ bottom: rvp(8) }).fontWeight(700)
                Text('谷粒专享').textStyles(rvp(12), $r('app.color.gray_second'))
                Grid() {
                  ForEach(this.house?.support, (support: IHouseSupport) => {
                    GridItem() {
                      Row({ space: rvp(10) }) {
                        Image(support.image).width(rvp(28)).height(rvp(28)).objectFit(ImageFit.Fill)
                        Column({ space: rvp(2) }) {
                          Text(support.title).textStyles()
                          Text(support.subTitle).textStyles(10, $r('app.color.gray_second'))
                        }
                        .alignItems(HorizontalAlign.Start)
                        .layoutWeight(1)
                      }
                      .width(BasicConstants.FULL_WIDTH)
                    }
                  })
                }
                .columnsTemplate('1fr 1fr')
                .columnsGap(rvp(50))
                .rowsGap(rvp(18))
                .width(BasicConstants.FULL_WIDTH)
                .margin({ top: rvp(14) })
              }
              .alignItems(HorizontalAlign.Start)
              .margin({ top: rvp(24), bottom: rvp(8) })
              .width(BasicConstants.FULL_WIDTH)
            }
            .width(BasicConstants.FULL_WIDTH)
            .paddingStyle()
          }
          .width(BasicConstants.FULL_WIDTH)
        }
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.None)
        .margin({ top: rvp(44), bottom: rvp(50) })

        this.bottomBuilder()
      }
      .height(BasicConstants.FULL_HEIGHT)
      .width(BasicConstants.FULL_WIDTH)
      .bindSheet($$this.showBook, this.bookBuilder(), {
        height: 500,
        title: { title: '预约看房' },
        showClose: false,
        maskColor: 'rgba(0,0,0,0.7)',
        backgroundColor: '#F6F6F6',
        onWillAppear: () => {
          this.dateList = dateFormat()
          this.selectedDate = this.dateList[0]
          this.reservation = {
            name: '',
            date: this.selectedDate.date,
            houseId: this.house!.id,
            phone: '',
            comment: ''
          }
        }
      })

      NavBar({ title: this.house?.houseTitle })
    }
    .padding({ top: this.safeTop })
    .height(BasicConstants.FULL_HEIGHT)
    .width(BasicConstants.FULL_WIDTH)
  }
}

@Extend(Text)
function textStyles(size: number = 14, color: ResourceStr = $r('app.color.black')) {
  .fontSize(rvp(size))
  .fontColor(color)
}

@Extend(TextInput)
function textInputStyles(bgColor: ResourceStr = $r('app.color.white')) {
  .backgroundColor(bgColor)
  .layoutWeight(1)
  .padding(0)
  .borderRadius(0)
}