import { BasicConstants } from "../common/constants/BasicConstants";
import { rvp } from "../common/utils/responsiveUtil";
import { router } from "@kit.ArkUI";
import log from "@open/log";
import { preferencesUtil } from "../common/utils/PreferencesUtils";
import { IUserInfo } from "../models/UserInfoModel";
import { getUserInfo } from "../apis/LoginApis";
import { getReservationByToken } from "../apis/HouseDetailApis";
import { IReservedHouse } from "../models/HouseModels";

interface imgStr {
  icon: ResourceStr
  text: string
}

@Component
export default struct My {
  @StorageProp('safeTop') safeTop: number = 0;
  @Watch('onTokenChange') @StorageProp('token') token: string = ''
  @State userInfo: IUserInfo | null = null
  @State reservationList: Array<IReservedHouse> = []
  private imgStrList1: imgStr[] = [
    {
      text: '想看',
      icon: $r('app.media.ic_my_imgstr1')
    },
    {
      text: '足迹',
      icon: $r('app.media.ic_my_imgstr2')
    },
    {
      text: '约看',
      icon: $r('app.media.ic_my_imgstr3')
    },
    {
      text: '拼租',
      icon: $r('app.media.ic_my_imgstr4')
    }]
  private imgStrList2: imgStr[] = [
    {
      text: '合同',
      icon: $r('app.media.ic_my_imgstr5')
    },
    {
      text: '账单',
      icon: $r('app.media.ic_my_imgstr6')
    },
    {
      text: '订单',
      icon: $r('app.media.ic_my_imgstr7')
    },
    {
      text: '评价',
      icon: $r('app.media.ic_my_imgstr8')
    },
    {
      text: '钱包',
      icon: $r('app.media.ic_my_imgstr9')
    }
  ]

  aboutToAppear(): void {
    if (this.token) {
      this.getUserInfo()
      this.getUserReservation()
    }
  }

  async onTokenChange() {
    if (this.token) {
      this.getUserInfo()
    } else {
      this.userInfo = null
    }
  }

  getUserInfo = async () => {
    this.userInfo = await getUserInfo<IUserInfo>()
  }
  getUserReservation = async () => {
    this.reservationList = await getReservationByToken<IReservedHouse[]>()
  }

  build() {
    Scroll() {
      Stack({ alignContent: Alignment.Top }) {
        //背景色
        Column() {

        }
        .linearGradient({
          angle: 180,
          colors: [
            ['#6DC782', 0],
            ['#8FE1A2', 0.43],
            ['#8FE1A2', 1],
          ]
        })
        .height(rvp(210))
        .width(BasicConstants.FULL_WIDTH)

        Column() {
          Row() {
            Row() {
              Image($r('app.media.ic_my_switch')).width(rvp(16)).height(rvp(16))
              Text('业主版').fontSize(rvp(12))
            }
            .justifyContent(FlexAlign.Center)
            .alignItems(VerticalAlign.Center)
            .borderRadius(rvp(30))
            .backgroundColor('rgba(255, 255, 255, 0.65)')
            .width(rvp(80))
            .height(rvp(26))

            Row({ space: rvp(16) }) {
              Image($r('app.media.ic_my_customer_service')).width(rvp(20)).height(rvp(20))
              Image($r('app.media.ic_my_message')).width(rvp(20)).height(rvp(20))
              Image($r('app.media.ic_my_setting')).width(rvp(20)).height(rvp(20))
            }
          }
          .padding({ top: rvp(9), bottom: rvp(9) })
          .justifyContent(FlexAlign.SpaceBetween)
          .width(BasicConstants.FULL_WIDTH)

          Row() {
            Row({ space: rvp(10) }) {
              Image(this.userInfo?.avatar || $r('app.media.avatar_default')).width(rvp(60)).height(rvp(60))
              Column({ space: rvp(4) }) {
                Text(this.userInfo?.nickname || '请登录')
                  .fontSize(rvp(16))
                  .fontColor($r('app.color.white'))
                  .fontWeight(700)
                if (this.token) {
                  Text('谷粒点15').fontSize(rvp(12)).fontColor($r('app.color.white'))
                }
              }
              .alignItems(HorizontalAlign.Start)
            }
            .alignItems(VerticalAlign.Center)
            .margin({ top: rvp(11) })
            .onClick(() => {
              if (!this.token) {
                router.pushUrl({
                  url: 'pages/Login'
                })
              }
            })

            Row({ space: rvp(8) }) {
              Button('我的预约')
                .type(ButtonType.Normal)
                .fontColor($r('app.color.white'))
                .fontSize(rvp(14))
                .backgroundColor($r('app.color.primary'))
                .borderRadius(rvp(8))
                .enabled(this.reservationList.length > 0)
                .onClick(() => {
                  router.pushUrl({
                    url: 'pages/ReservationList',
                    params: {
                      list: this.reservationList
                    }
                  })
                })
              Button('退出登录')
                .type(ButtonType.Normal)
                .fontColor($r('app.color.white'))
                .fontSize(rvp(14))
                .borderRadius(rvp(8))
                .backgroundColor(Color.Red)
                .enabled(this.token !== '')
                .onClick(() => {
                  AppStorage.setOrCreate('token', '')
                  preferencesUtil.deleteData('token')
                })
            }
            .justifyContent(FlexAlign.End)
            .layoutWeight(1)
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .width(BasicConstants.FULL_WIDTH)

          Column({ space: rvp(10) }) {
            Column({ space: rvp(11) }) {
              Row() {
                Text('小谷粒时光计划').fontSize(rvp(16)).fontColor('#2C5B37').fontWeight(700)
                Image($r('app.media.ic_my_arrow_right')).width(rvp(6)).height(rvp(12))
              }
              .justifyContent(FlexAlign.SpaceBetween)
              .width(BasicConstants.FULL_WIDTH)

              Text('签约后可解锁会员权益').fontSize(rvp(12)).fontColor('#2C5B37')
            }
            .padding({
              left: rvp(22),
              top: rvp(18),
              bottom: rvp(18),
              right: rvp(20)
            })
            .alignItems(HorizontalAlign.Start)
            .borderRadius(rvp(8))
            .linearGradient({
              angle: 116,
              colors: [
                ['#FFF1CD', 0],
                ['#FFEBB5', 1],
              ]
            })
            .width(BasicConstants.FULL_WIDTH)

            Column() {
              Row() {
                ForEach(this.imgStrList1, (item: imgStr) => {
                  Row({ space: rvp(4) }) {
                    Image(item.icon).width(rvp(16)).height(rvp(16))
                    Text(item.text).fontSize(12).fontColor($r('app.color.black'))
                  }
                })
              }
              .justifyContent(FlexAlign.SpaceBetween)
              .width(BasicConstants.FULL_WIDTH)

              Divider().margin({ top: rvp(16) })
              Row() {
                ForEach(this.imgStrList2, (item: imgStr) => {
                  Column({ space: rvp(8) }) {
                    Image(item.icon).width(rvp(18)).height(rvp(20))
                    Text(item.text).fontSize(12).fontColor($r('app.color.black'))
                  }
                })
              }.margin({ top: rvp(12) })
              .justifyContent(FlexAlign.SpaceBetween)
              .width(BasicConstants.FULL_WIDTH)
            }
            .padding({
              left: rvp(20),
              top: rvp(16),
              bottom: rvp(16),
              right: rvp(20)
            })
            .borderRadius(rvp(8))
            .backgroundColor($r('app.color.white'))
            .width(BasicConstants.FULL_WIDTH)

            Column() {
              Stack({ alignContent: Alignment.TopEnd }) {
                Column() {
                  Row({ space: rvp(12) }) {
                    Text('我的家').fontSize(rvp(16)).fontColor($r('app.color.black')).fontWeight(700)
                    Row() {

                    }
                    .height(rvp(12))
                    .backgroundColor($r('app.color.gray'))
                    .width(rvp(1))

                    Text('感谢你选择谷粒').fontSize(rvp(12)).fontColor($r('app.color.gray'))
                  }

                  Column({ space: rvp(10) }) {
                    Text('选择谷粒，我们能为你提供').fontSize(rvp(14)).fontColor($r('app.color.black'))
                    Row({ space: rvp(16) }) {
                      Image($r('app.media.my_shenfen')).width(rvp(38)).height(rvp(28))
                      Column({ space: rvp(2) }) {
                        Text('代办').fontSize(rvp(14))
                        Text('你还未进行实名认证').fontSize(rvp(12)).fontColor($r('app.color.gray'))
                      }.alignItems(HorizontalAlign.Start)
                    }
                    .borderRadius(rvp(4))
                    .padding({
                      left: rvp(18),
                      top: rvp(21),
                      right: rvp(20),
                      bottom: rvp(21)
                    })
                    .backgroundColor($r('app.color.bg_gray'))
                    .width(BasicConstants.FULL_WIDTH)

                    Column() {
                      Row({ space: rvp(10) }) {
                        Text('专属谷粒计划').fontSize(rvp(14)).fontColor($r('app.color.black'))
                        Text('你在谷粒的每一天都很珍贵').fontSize(rvp(10)).fontColor($r('app.color.gray'))
                      }
                      .alignItems(VerticalAlign.Bottom)
                      .width(BasicConstants.FULL_WIDTH)

                      Column({ space: rvp(6) }) {
                        Text('服务折扣').fontSize(rvp(12)).fontColor($r('app.color.black'))
                        Text('每住100天，折扣多一点').fontSize(rvp(10)).fontColor($r('app.color.gray'))
                      }
                      .alignItems(HorizontalAlign.Start)
                      .margin({ top: rvp(30) })
                      .width(BasicConstants.FULL_WIDTH)

                      Column({ space: rvp(6) }) {
                        Text('免费换租').fontSize(rvp(12)).fontColor($r('app.color.black'))
                        Text('城市那么大，你不必讲究').fontSize(rvp(10)).fontColor($r('app.color.gray'))
                      }
                      .alignItems(HorizontalAlign.Start)
                      .margin({ top: rvp(16) })
                      .width(BasicConstants.FULL_WIDTH)
                    }
                    .borderRadius(rvp(8))
                    .padding(rvp(16))
                    .backgroundColor('#FFF8E4')
                    .width(BasicConstants.FULL_WIDTH)

                    Column() {
                      Row({ space: rvp(10) }) {
                        Text('专属谷粒计划').fontSize(rvp(14)).fontColor($r('app.color.black'))
                        Text('你在谷粒的每一天都很珍贵').fontSize(rvp(10)).fontColor($r('app.color.gray'))
                      }
                      .alignItems(VerticalAlign.Bottom)
                      .width(BasicConstants.FULL_WIDTH)

                      Column({ space: rvp(6) }) {
                        Text('服务折扣').fontSize(rvp(12)).fontColor($r('app.color.black'))
                        Text('每住100天，折扣多一点').fontSize(rvp(10)).fontColor($r('app.color.gray'))
                      }
                      .alignItems(HorizontalAlign.Start)
                      .margin({ top: rvp(30) })
                      .width(BasicConstants.FULL_WIDTH)

                      Column({ space: rvp(6) }) {
                        Text('免费换租').fontSize(rvp(12)).fontColor($r('app.color.black'))
                        Text('城市那么大，你不必讲究').fontSize(rvp(10)).fontColor($r('app.color.gray'))
                      }
                      .alignItems(HorizontalAlign.Start)
                      .margin({ top: rvp(16) })
                      .width(BasicConstants.FULL_WIDTH)
                    }
                    .borderRadius(rvp(8))
                    .padding(rvp(16))
                    .backgroundColor('#DBFFF0')
                    .width(BasicConstants.FULL_WIDTH)
                  }
                  .borderRadius(rvp(8))
                  .margin({ top: rvp(28) })
                  .alignItems(HorizontalAlign.Start)
                  .width(BasicConstants.FULL_WIDTH)
                }
                .alignItems(HorizontalAlign.Start)
                .width(BasicConstants.FULL_WIDTH)

                Image($r('app.media.my_person')).width(rvp(45)).height(rvp(82))
                  .margin({ top: rvp(8), right: rvp(18) })
              }
            }
            .padding(rvp(20))
            .borderRadius(rvp(8))
            .backgroundColor($r('app.color.white'))
            .width(BasicConstants.FULL_WIDTH)
          }
          .margin({ top: rvp(15) })
          .width(BasicConstants.FULL_WIDTH)
        }
        .margin({ top: this.safeTop })
        .padding({ left: rvp(16), right: rvp(16) })
        .width(BasicConstants.FULL_WIDTH)
        .layoutWeight(1)
      }
      .width(BasicConstants.FULL_WIDTH)
    }
    .scrollBar(BarState.Off)
    .backgroundColor($r('app.color.bg_gray'))
    .width(BasicConstants.FULL_WIDTH)
    .height(BasicConstants.FULL_HEIGHT)
  }
}