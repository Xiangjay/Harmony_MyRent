import log from "@open/log";
import { getDiscoverData } from "../apis/DiscoverApis"
import { BasicConstants } from "../common/constants/BasicConstants";
import { rvp } from "../common/utils/responsiveUtil";
import { IBenefits, IContentBlock, IDanMuListModel, IDiscoverModel } from "../models/DiscoverDataModel"

@Component
export default struct Discover {
  @StorageProp('safeTop') safeTop: number = 0;
  @State discoverData: IDiscoverModel | null = null
  @State offsetX: string | number = 0
  private danMuScroller1: ListScroller = new ListScroller();
  private danMuScroller2: ListScroller = new ListScroller();
  getDiscoverData = async () => {
    this.discoverData = await getDiscoverData<IDiscoverModel>()
  }

  aboutToAppear(): void {
    this.getDiscoverData()
  }

  @Builder
  danMuListBuilder(danMuList: IDanMuListModel[], scroller: ListScroller, index: number) {
    List({ space: rvp(20), scroller: scroller }) {
      ForEach(danMuList, (danMu: IDanMuListModel) => {
        ListItem() {
          Row({ space: rvp(6) }) {
            Image(danMu.avatar).width(rvp(24)).height(rvp(24)).objectFit(ImageFit.Fill).borderRadius(rvp(24))
            Text(danMu.content).fontSize(14).fontColor($r('app.color.black'))
          }
          .padding({
            top: rvp(6),
            left: rvp(6),
            bottom: rvp(6),
            right: rvp(10)
          })
          .borderRadius(rvp(42))
          .backgroundColor('#CDFFD9')
        }
      })
    }
    .listDirection(Axis.Horizontal)
    .edgeEffect(EdgeEffect.None)
    .scrollBar(BarState.Off)
    .height(rvp(36))
    .onReachStart(() => {
      scroller.scrollEdge(Edge.End, { velocity: index === 1 ? 50 : 30 })
    })
    .onReachEnd(() => {
      scroller.scrollEdge(Edge.Start)
    })
  }

  build() {
    Column() {
      Stack({ alignContent: Alignment.Top }) {
        Image($r('app.media.discover_bg'))
          .width(BasicConstants.FULL_WIDTH)
          .height(rvp(322)).objectFit(ImageFit.Fill)
        Column() {
          Row() {
            Text('家庭服务').fontSize(rvp(18)).fontColor($r('app.color.black')).fontWeight(700)
            Image($r('app.media.discover_avatar')).width(rvp(30)).height(rvp(30))
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .width(BasicConstants.FULL_WIDTH)
          .height(rvp(44))
          .padding({
            left: rvp(18),
            right: rvp(18),
            top: rvp(12),
            bottom: rvp(12)
          })

          Text('与100万用户发现生活')
            .fontSize(rvp(14))
            .fontColor($r('app.color.black'))
            .margin({ bottom: rvp(20) })
            .alignSelf(ItemAlign.Start)
            .padding({
              left: rvp(18)
            })
          if (this.discoverData) {
            Column({ space: rvp(16) }) {
              this.danMuListBuilder(this.discoverData!.danMuList1, this.danMuScroller1, 1)
              this.danMuListBuilder(this.discoverData!.danMuList2, this.danMuScroller2, 2)
            }
            .width(BasicConstants.FULL_WIDTH)
          }
          Row({ space: rvp(14) }) {
            Column() {
              Text(`${this.discoverData?.postZone.mainPost.followerNum}位小谷粒`)
                .fontSize(rvp(10))
                .fontColor($r('app.color.gray_second'))
                .padding({ left: rvp(16), top: rvp(16) })
                .margin({ bottom: rvp(20) })
              Text(`“${this.discoverData?.postZone.mainPost.title}”`)
                .fontSize(26)
                .fontColor($r('app.color.black'))
                .margin({ bottom: rvp(8) })
                .padding({ left: rvp(16) })
                .fontWeight(700)
              Column({ space: 10 }) {
                Row({ space: rvp(8) }) {
                  Image(this.discoverData?.postZone.mainPost.userAvatar).width(rvp(28)).height(rvp(28))
                  Text(this.discoverData?.postZone.mainPost.userName).fontSize(12).fontColor('#636363')
                }
                .padding({ left: rvp(12), top: rvp(12) })
                .alignItems(VerticalAlign.Center)
                .width(BasicConstants.FULL_WIDTH)

                Text(this.discoverData?.postZone.mainPost.postContent)
                  .fontSize(12)
                  .fontColor('#636363')
                  .maxLines(4)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .padding({ left: rvp(12), right: rvp(12) })
              }
              .padding({ left: rvp(12), right: rvp(12) })
              .width(BasicConstants.FULL_WIDTH)
            }
            .alignItems(HorizontalAlign.Start)
            .borderRadius(rvp(8))
            .backgroundColor($r('app.color.white'))
            .width(rvp(192))
            .height(BasicConstants.FULL_HEIGHT)

            Column({ space: rvp(9) }) {
              ForEach(this.discoverData?.postZone.contentBlockList, (item: IContentBlock) => {
                Image(item.img).width(BasicConstants.FULL_WIDTH).height(rvp(67)).objectFit(ImageFit.Fill)
              })
            }
            .width(rvp(122))
            .height(BasicConstants.FULL_HEIGHT)
          }
          .height(rvp(218))
          .margin({ top: rvp(20) })
          .padding({ left: rvp(16), right: rvp(16) })
          .width(BasicConstants.FULL_WIDTH)

          Column() {
            Column({ space: 8 }) {
              Text('小谷粒福利')
                .width(rvp(80))
                .fontSize(12)
                .fontColor('#1F632F')
                .backgroundColor('#CDFFD9')
                .borderRadius(rvp(23))
                .padding({
                  left: rvp(10),
                  top: rvp(5),
                  right: rvp(10),
                  bottom: rvp(5)
                })
              Swiper() {
                ForEach(this.discoverData?.benefits, (benefit: IBenefits) => {
                  Column({ space: rvp(10) }) {
                    Text(benefit.title)
                      .fontColor($r('app.color.black'))
                      .fontSize(rvp(26))
                      .fontWeight(700)
                      .width(BasicConstants.FULL_WIDTH)
                      .textAlign(TextAlign.Start)
                    Image(benefit.img)
                      .width(BasicConstants.FULL_WIDTH)
                      .height(rvp(146))
                      .objectFit(ImageFit.Fill)
                      .borderRadius(rvp(8))
                  }
                  .width(BasicConstants.FULL_WIDTH)
                })
              }
              .autoPlay(true)
              .indicator(false)
              .width(BasicConstants.FULL_WIDTH)
            }
            .padding(rvp(16))
            .alignItems(HorizontalAlign.Start)
            .width(BasicConstants.FULL_WIDTH)
          }
          .margin({ top: rvp(10) })
          .padding({ left: rvp(16), right: rvp(16) })
          .width(BasicConstants.FULL_WIDTH)
        }
        .margin({ top: this.safeTop })
        .width(BasicConstants.FULL_WIDTH)
      }
    }
    .height(BasicConstants.FULL_HEIGHT)
    .width(BasicConstants.FULL_WIDTH)
  }
}