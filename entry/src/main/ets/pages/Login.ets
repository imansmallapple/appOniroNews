@Entry
@Component
struct Login {
  build() {
    Column({ space: 50 }) {

      Column() {
        Row({ space: 20 }) {
          Image($r('app.media.app_icon'))
            .width(50)

          Text('App Title')
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
          TextInput({ placeholder: 'account number' })
            .inputStyle()
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
        }.margin({ top: 30 })

        Divider()
          .color(Color.Black)// .margin({ right: 120 })
          .strokeWidth(1)

        Button('Login')
          .buttonlStyle(
            Color.Black,
            Color.White
          )
          .width('100%')
          .margin({ top: 50 })
          .onClick(() => {
            //to do: login
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
function buttonlStyle(
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
