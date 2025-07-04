import { AccountManager } from '../viewModel/account'
import { common } from '@kit.AbilityKit';
import Storage from '../preference/Storage'

@Entry
@Component
struct Login {
  @State email: string = ''
  @State password: string = ''
  private context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
  private accountManager: AccountManager = new AccountManager(this.context)
  //Credentials
  private localStorage = new Storage()
  @State savedEmail: string = ''
  @State savedPwd: string = ''
  @State credential: string[] = []

  async aboutToAppear(): Promise<void> {
    let temp: string[] = (await this.localStorage.getStyle('credential')) as string[]
    if (temp.length !== 0) {
      this.savedEmail = temp[temp.length-2]
      this.savedPwd = temp[temp.length-1]
      this.getUIContext().getRouter().pushUrl({
        url: 'pages/Index',
        params: {
          email: this.savedEmail
        }
      })
      this.getUIContext().getPromptAction().showToast({
        message: "Auto logged in!"
      })
    }
  }

  build() {
    Column({ space: 50 }) {

      Column() {
        Row({ space: 20 }) {
          Image($r('app.media.icon_news'))
            .width(50)

          Text($r('app.string.Oniro_news'))
            .fontSize(30)
            .fontWeight(700)
        }
        .justifyContent(FlexAlign.Center)
        .width('100%')
        .height('100%')
        .padding(20)
      }
      .height('20%')

      Column() {
        Text('Welcome Login')
          .titleStyle()

        Row() {
          Image($r('app.media.icon_user'))
            .iconStyle()
          TextInput({ placeholder: 'email' })
            .inputStyle()
            .type(InputType.Email)
            .onChange((value) => {
              this.email = value
            })
        }
        .margin({ top: 30 })

        Divider()
          .color(Color.Black)
          .strokeWidth(1)
        Row() {
          Image($r('app.media.icon_security'))
            .iconStyle()
          TextInput({ placeholder: 'password' })
            .inputStyle()
            .type(InputType.Password)
            .onChange((value) => {
              this.password = value
            })
        }.margin({ top: 30 })

        Divider()
          .color(Color.Black)// .margin({ right: 120 })
          .strokeWidth(1)

        Button('Login')
          ._buttonStyle(
            Color.Black,
            Color.White
          )
          .width('100%')
          .margin({ top: 50 })
          .onClick(async () => {
            //to do: login
            let res = await this.accountManager.login(this.email, this.password)
            if (res == true) {

              // todo: Save user credentials into preferences
              this.credential.push(this.email)
              this.credential.push(this.password)
              this.localStorage.setStyle('credential', this.credential)

              this.getUIContext().getPromptAction().showToast({
                message: "Login succeed!"
              })
              this.getUIContext().getRouter().pushUrl({
                url: 'pages/Index',
                params: {
                  email: this.email
                }
              })
            } else {
              this.getUIContext().getPromptAction().showToast({
                message: "Wrong email or password!"
              })
            }
          })
      }
      .loginContainerStyle()
      .alignItems(HorizontalAlign.Start)
      .formBgStyle()

      Row() {
        Text('Don\'t have account? Register now!')
          .fontSize(15)
          .fontWeight(500)
          .fontColor(Color.Blue)
          .decoration({
            type: TextDecorationType.Underline,
            color: Color.Blue
          })
      }
      .justifyContent(FlexAlign.Center)
      .width('100%')
      .onClick(() => {
        this.getUIContext().getRouter().pushUrl({
          url: 'pages/Register'
        })
      })
    }
    .loginBgStyle()
    .justifyContent(FlexAlign.Center)
  }
}

@Extend(Image)
function iconStyle() {
  .width(25)
  .height(25)
}

@Extend(TextInput)
function inputStyle() {
  .height(40)
  .backgroundColor(Color.Transparent)
  .fontSize(14)
  .layoutWeight(1)
}

@Extend(Button)
function _buttonStyle(
  btColor: ResourceColor,
  fontColor: ResourceColor,
) {
  .fontColor(fontColor)
  .backgroundColor(btColor)
  .height('5%')
  .type(ButtonType.Normal)
  .fontSize(14)
  .borderWidth(1)
  .borderRadius(5)
  .fontWeight(FontWeight.Medium)
}

@Extend(Column)
function loginContainerStyle() {
  .width('70%')
}

@Styles
function formBgStyle() {
  .padding(30)
  .borderRadius(20)
  .backgroundColor(Color.White)
  .width('100%')
}

@Styles
function loginBgStyle() {
  .width('100%')
  .height('100%')
  .backgroundColor(Color.Orange)
  .padding({
    top: 30,
    bottom: 30,
    left: 30,
    right: 30
  })
}

@Extend(Text)
function titleStyle() {
  .fontSize(22)
  .alignSelf(ItemAlign.Center)
  .fontWeight(700)
}
