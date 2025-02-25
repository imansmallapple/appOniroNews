@Component
struct LoadComponent {
  build() {
    Column() {
      LoadingProgress()
        .color(Color.Blue)
        .width(50)
        .margin({ bottom: '10%' })
    }
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}

@Component
struct HttpErrorComponent {
  @Prop text: string = 'No internet'

  build() {
    Column() {
      Column() {
        Image($r('app.media.icon_no_wifi'))
          .width('20%')
          .opacity(0.4)
        Text(this.text)
          .opacity(0.4)
          .margin(5)
      }
      .margin({
        bottom: '10%'
      })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .zIndex(0)
  }
}

@Component
struct EmptyComponent {
  @Prop text: string = ''

  build() {
    Column() {
      Column() {

        Image($r('app.media.icon_empty'))
          .width('20%')
          .opacity(0.4)
        Text(this.text)
          .opacity(0.4)
          .margin(5)
      }
      .margin({
        bottom: '10%'
      })
    }
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}

export { HttpErrorComponent, LoadComponent, EmptyComponent }