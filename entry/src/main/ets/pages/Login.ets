import log from '@open/log';
import { getVerifyCode, login } from '../apis/LoginApis';
import { BasicConstants } from '../common/constants/BasicConstants'
import { rvp } from '../common/utils/responsiveUtil';
import NavBar from '../components/common/NavBar'
import { ILogin } from '../models/LoginModel';
import { router, window } from '@kit.ArkUI';
import { preferencesUtil } from '../common/utils/PreferencesUtils';

@Entry
@Component
struct Login {
  windowClass: window.Window = AppStorage.get("windowClass") as window.Window;
  @StorageProp('safeTop') safeTop: number = 0;
  START_TIME: number = 60
  @State phoneNumber: string = ''
  @State isValidPhone: boolean = false
  @State agree: boolean = false
  @State showVerifyCode: boolean = false
  @State timeLeft: number = this.START_TIME
  @State verifyCode: string = ''
  private intervalId: number = 0
  handlePhoneNumber = (val: string) => {
    this.phoneNumber = val
    const reg = /^[1][3-9][0-9]{9}$/;
    this.isValidPhone = reg.test(this.phoneNumber)
  }
  sendVerifyCode2Phone = () => {
    getVerifyCode<null>(this.phoneNumber)
    this.startInterval()

  }
  startInterval = () => {
    this.intervalId = setInterval(() => {
      this.timeLeft--
      if (this.timeLeft === 0) {
        clearInterval(this.intervalId)
      }
    }, 1000)
  }
  login = async () => {
    const res = await login<ILogin>(this.phoneNumber, this.verifyCode)
    if (res.token) {
      preferencesUtil.insertData('token', res.token)
      router.back()
    }
  }

  aboutToAppear(): void {
    this.windowClass.setWindowSystemBarProperties({
      statusBarContentColor: '#000000'
    });
  }

  @Builder
  verifyCodeBuilder() {
    Column() {
      Image($r('app.media.ic_back'))
        .width(rvp(24))
        .height(rvp(24))
        .onClick(() => {
          this.showVerifyCode = false
        })
        .alignSelf(ItemAlign.Start)
        .padding({ left: rvp(16) })

      Column() {
        Stack({ alignContent: Alignment.End }) {
          TextInput({ placeholder: '请输验证码' })
            .backgroundColor(Color.Transparent)
            .fontSize(rvp(16))
            .placeholderColor('#C1C1C1')
            .placeholderFont({
              size: rvp(16)
            })
            .border({
              width: {
                bottom: rvp(1)
              },
              color: '#C4EDCE'
            })
            .borderRadius(0)
            .padding({
              top: rvp(8),
              bottom: rvp(8),
              left: 0,
              right: 0
            })
            .caretColor($r('app.color.primary'))
            .type(InputType.Number)
            .maxLength(6)
            .onChange((val: string) => {
              this.verifyCode = val
            })
          Text(this.timeLeft === 0 ? '重新获取验证码' : `${this.timeLeft}s`)
            .fontColor($r('app.color.primary'))
            .fontSize(rvp(16))
            .onClick(() => {
              this.timeLeft = this.START_TIME
              this.sendVerifyCode2Phone()
            })
        }
        .width(BasicConstants.FULL_WIDTH)


        Button('确定')
          .width(rvp(100))
          .height(rvp(40))
          .margin({ top: rvp(40) })
          .backgroundColor($r('app.color.primary'))
          .alignSelf(ItemAlign.End)
          .enabled(this.verifyCode.length === 6)
          .onClick(this.login)
      }
      .margin({ top: rvp(40) })
      .padding({ left: rvp(37), right: rvp(37) })
      .width(BasicConstants.FULL_WIDTH)
    }
    .linearGradient({
      direction: GradientDirection.Bottom,
      colors: [['#DEFBE5', 0], ['#FFFFFF', 0.3]]
    })
    .padding({ top: this.safeTop })
    .height(BasicConstants.FULL_HEIGHT)
    .width(BasicConstants.FULL_WIDTH)
  }

  build() {
    Column() {
      NavBar({ title: '登录' })
      Column() {
        Stack({ alignContent: Alignment.End }) {
          TextInput({ placeholder: '请输入手机号' })
            .backgroundColor(Color.Transparent)
            .fontSize(rvp(16))
            .placeholderColor('#C1C1C1')
            .placeholderFont({
              size: rvp(16)
            })
            .border({
              width: {
                bottom: rvp(1)
              },
              color: '#C4EDCE'
            })
            .borderRadius(0)
            .padding({
              top: rvp(8),
              bottom: rvp(8),
              left: 0,
              right: 0
            })
            .caretColor($r('app.color.primary'))
            .type(InputType.Number)
            .maxLength(11)
            .onChange(this.handlePhoneNumber)
          if (this.isValidPhone) {
            Image($r('app.media.login_correct')).width(rvp(12)).height(rvp(8))
          }
        }
        .width(BasicConstants.FULL_WIDTH)

        Row({ space: rvp(6) }) {
          Checkbox()
            .select($$this.agree)
            .selectedColor($r('app.color.primary'))
            .width(rvp(14)).height(rvp(14))
          Text() {
            Span('同意').fontSize(rvp(12)).fontColor('#C1C1C1')
            Span('《用户协议》').fontSize(rvp(12)).fontColor($r('app.color.primary'))
            Span('和').fontSize(rvp(12)).fontColor('#C1C1C1')
            Span('《隐私政策》').fontSize(rvp(12)).fontColor($r('app.color.primary'))
          }
        }
        .width(BasicConstants.FULL_WIDTH).margin(rvp(16))

        Button('获取验证码')
          .width(rvp(100))
          .height(rvp(40))
          .margin({ top: rvp(40) })
          .backgroundColor($r('app.color.primary'))
          .alignSelf(ItemAlign.End)
          .enabled(this.agree && this.isValidPhone)
          .onClick(() => {
            this.showVerifyCode = true
          })
          .bindContentCover($$this.showVerifyCode, this.verifyCodeBuilder(), {
            modalTransition: ModalTransition.DEFAULT,
            onAppear: () => {
              this.sendVerifyCode2Phone()
            },
            onDisappear: () => {
              clearInterval(this.intervalId)
            }
            // transition: TransitionEffect.SLIDE.animation({ duration: 1000 }),
          })
      }
      .margin({ top: rvp(40) })
      .padding({ left: rvp(37), right: rvp(37) })
      .width(BasicConstants.FULL_WIDTH)
    }
    .linearGradient({
      direction: GradientDirection.Bottom,
      colors: [['#DEFBE5', 0], ['#FFFFFF', 0.3]]
    })
    .padding({ top: this.safeTop })
    .height(BasicConstants.FULL_HEIGHT)
    .width(BasicConstants.FULL_WIDTH)
  }
}