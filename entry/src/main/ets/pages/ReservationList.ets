import { BasicConstants } from '../common/constants/BasicConstants';
import { rvp } from '../common/utils/responsiveUtil';
import NavBar from '../components/common/NavBar';
import { IHouseTag, IReservationRouterParams, IReservedHouse } from '../models/HouseModels';
import { router } from '@kit.ArkUI';
import log from '@open/log';
import { MyLazyDataSource } from '../models/MyLazyDataSource';

@Entry
@Component
struct ReservationList {
  @StorageProp('safeTop') safeTop: number = 0;
  @State reservationLazyData: MyLazyDataSource<IReservedHouse> = new MyLazyDataSource()

  aboutToAppear(): void {
    const routerParams: IReservationRouterParams = router.getParams() as IReservationRouterParams
    log.info(routerParams.list)
    if (routerParams.list.length > 0) {
      this.reservationLazyData.pushAllData(routerParams.list)
    }
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      Column() {
        List({ space: rvp(16) }) {
          LazyForEach(this.reservationLazyData, (item: IReservedHouse) => {
            ListItem() {
              Column() {
                Row({ space: rvp(4) }) {
                  Image($r('app.media.ic_clock')).width(rvp(12)).height(rvp(12))
                  Text(`${item.date} 全天 随时可看`)
                    .fontColor($r('app.color.gray'))
                    .fontSize(10)
                }.width(BasicConstants.FULL_WIDTH)

                Row({ space: rvp(8) }) {
                  Image(item.img).width(rvp(120)).height(rvp(120)).objectFit(ImageFit.Fill).borderRadius(rvp(10))
                  Column({ space: rvp(22) }) {
                    Column({ space: rvp(8) }) {
                      Text(item.title)
                        .fontColor($r('app.color.black'))
                        .fontSize(16)
                        .maxLines(1)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                        .width(BasicConstants.FULL_WIDTH)
                      Text(item.subTitle).fontColor($r('app.color.gray')).fontSize(10)
                      Row({ space: 6 }) {
                        ForEach(item.tags, (tag: IHouseTag) => {
                          Text(tag.name)
                            .fontSize(rvp(10))
                            .fontColor('#B3B3B3')
                            .backgroundColor($r('app.color.bg_gray'))
                            .height(rvp(16))
                            .borderRadius(rvp(2))
                        }, (tag: IHouseTag) => tag.name)
                      }
                    }
                    .alignItems(HorizontalAlign.Start)
                    .width(BasicConstants.FULL_WIDTH)

                    Row() {
                      Text(item.rentPrice).fontSize(rvp(16)).fontColor('#E03810')
                      Text('去咨询').fontSize(rvp(12)).fontColor($r('app.color.primary'))
                    }
                    .justifyContent(FlexAlign.SpaceBetween)
                    .width(BasicConstants.FULL_WIDTH)
                  }
                  .padding({ top: rvp(10), bottom: rvp(10) })
                  .layoutWeight(1)
                }
                .width(BasicConstants.FULL_WIDTH)
              }
              .backgroundColor($r('app.color.white'))
              .width(BasicConstants.FULL_WIDTH)
            }
          }, (item: IReservedHouse) => item.id)
        }
        .scrollBar(BarState.Off)
      }
      .width(BasicConstants.FULL_WIDTH)
      .backgroundColor('#F7F7F7')
      .padding({ left: rvp(16), right: rvp(16), top: rvp(20) })
      .margin({ top: rvp(44) })

      NavBar({ title: '我的预约' })
    }
    .padding({ top: this.safeTop })
    .height(BasicConstants.FULL_HEIGHT)
    .width(BasicConstants.FULL_WIDTH)
  }
}