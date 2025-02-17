import router from '@ohos.router'

@Entry
@Component
struct Register {
  build() {
    Column({ space: 50 }) {
      Image($r('app.media.icon_back'))
        .width(25)
        .height(25)
        .alignSelf(ItemAlign.Start)
        .onClick(() => {
          router.back()
        })
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
        Text('Registration')
          .fontSize(22)
          .alignSelf(ItemAlign.Center)
          .fontWeight(700)

        Row() {
          Image($r('app.media.icon_user'))
            .width(25)
            .height(25)
          TextInput({ placeholder: 'username' })
            .height(40)
            .backgroundColor(Color.Transparent)
            .fontSize(14)
            .layoutWeight(1)
        }
        .margin({ top: 30 })

        Divider()
          .color(Color.Black)
          .strokeWidth(1)

        Row() {
          Image($r('app.media.icon_email'))
            .width(25)
            .height(25)
          TextInput({ placeholder: 'email' })
            .height(40)
            .backgroundColor(Color.Transparent)
            .fontSize(14)
            .layoutWeight(1)
        }
        .margin({ top: 30 })

        Divider()
          .color(Color.Black)
          .strokeWidth(1)


        Row() {
          Image($r('app.media.icon_security'))
            .width(25)
            .height(25)
          TextInput({ placeholder: 'password' })
            .height(40)
            .backgroundColor(Color.Transparent)
            .fontSize(14)
            .layoutWeight(1)
        }.margin({ top: 30 })

        Divider()
          .color(Color.Black)// .margin({ right: 120 })
          .strokeWidth(1)
        Row() {
          Image($r('app.media.icon_security'))
            .width(25)
            .height(25)
          TextInput({ placeholder: 'repeat password' })
            .height(40)
            .backgroundColor(Color.Transparent)
            .fontSize(14)
            .layoutWeight(1)
        }
        .margin({ top: 30 })

        Divider()
          .color(Color.Black)
          .strokeWidth(1)

        Button('Register')
          .fontColor(Color.White)
          .backgroundColor(Color.Black)
          .height('5%')
          .type(ButtonType.Normal)
          .fontSize(14)
          .borderWidth(1)
          .borderRadius(5)
          .fontWeight(FontWeight.Medium)
          .width('100%')
          .margin({ top: 50 })
          .onClick(() => {
            //to do: login
          })
      }
      .width('70%')
      .alignItems(HorizontalAlign.Start)
      .padding(30)
      .borderRadius(20)
      .backgroundColor(Color.White)
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Orange)
    .padding({
      top: 30,
      bottom: 30,
      left: 30,
      right: 30
    })
    .justifyContent(FlexAlign.Start)
  }
}
