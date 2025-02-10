import { DataSource } from '../data/DataSource'
import { NewsResponse, News } from '../model/news'
import hilog from '@ohos.hilog'
import { CategoryResponse } from '../model/categories'
import router from '@ohos.router'
import { timeFormatModify } from '../utils/timeUtil'

@Entry
@Component
struct Index {
  @State latestNews: News[] = []
  @State categories: string[] = []
  private source = new DataSource()
  // List
  private scroller: Scroller = new Scroller()


  async aboutToAppear(): Promise<void> {
    let res: NewsResponse = await this.source.getLatestNews('en')
    this.latestNews = res.news
    hilog.info(0x00, 'latest', JSON.stringify(this.latestNews))
    let res1: NewsResponse = await this.source.searchNews('en', 'trump', 1)
    hilog.info(0x00, 'latest', JSON.stringify(res1))
    let res2: CategoryResponse = await this.source.getCategories()
    hilog.info(0x00, 'category', JSON.stringify(res2))
    this.categories = res2.categories
  }

  async getCategorizedLatestNews(language: string, category: string) {
    let res: NewsResponse = await this.source.getLatestNews(language, category)
    this.latestNews = res.news
  }


  // private smoothScrollToTop() {
  //   const scrollDuration = 1000
  //   const frameRate = 60
  //   const interval = 1000 / frameRate
  //   const totalFrames = scrollDuration / interval
  //
  //   let currentFrame = 0;
  //   const startY = this.scroller.currentOffset().yOffset
  //   const distance = -startY
  //
  //   const scrollStep = () => {
  //     currentFrame++;
  //     const progress = Math.min(currentFrame / totalFrames, 1)
  //     const easeOutQuad = (t: number) => t * (2 - t)
  //     const easedProgress = easeOutQuad(progress)
  //
  //     this.scroller.scrollTo({
  //       xOffset: 0,
  //       yOffset: startY + distance * easedProgress,
  //       animation: false,
  //     });
  //
  //     if (currentFrame < totalFrames) {
  //       setTimeout(scrollStep, interval)
  //     }
  //   };
  //   scrollStep()
  // }

  @Builder
  floatIconBuilder(icon: Resource, callback?: () => void) {
    Row() {
      Image(icon)
        .width(20)
        .height(20)
        .zIndex(1)
        .objectFit(ImageFit.Contain)
    }
    .justifyContent(FlexAlign.Center)
    .backgroundColor('#33000000')
    .borderRadius(30)
    .width(45)
    .height(45)
    .margin({
      right: 10,
      bottom: 5
    })
    .backdropBlur(20)
    .onClick(callback)
  }

  build() {
    Stack() {
      Column() {
        Row({ space: 10 }) {
          List() {
            ForEach(this.categories, (item: string) => {
              ListItem() {
                Column() {
                  Text(item)
                    .fontWeight(600)
                    .fontSize(20)
                    .fontColor(Color.White)
                }
                .width('40%')
                .height('100%')
                .justifyContent(FlexAlign.Center)
              }
              .onClick(() => {
                this.getCategorizedLatestNews('en', item)
              })
            })
          }
          .listDirection(Axis.Horizontal)
        }
        .justifyContent(FlexAlign.Start)
        .alignItems(VerticalAlign.Center)
        .width('100%')
        .height('7%')
        .zIndex(0)
        .margin({ bottom: 5 })
        .backgroundColor('#ff4e4c4c')

        Scroll() {
          Column() {
            List({ scroller: this.scroller }) {
              ForEach(this.latestNews, (item: News) => {
                ListItem() {
                  Column() {
                    Column() {
                      Column() {
                        Image(item.image)
                          .width('100%')
                          .objectFit(ImageFit.Contain)
                          .borderRadius({ topLeft: 10, topRight: 10 })
                        Row() {
                          Text(item.title)
                            .fontSize(20)
                            .fontWeight(700)
                        }
                        .width('100%')
                        .padding(10)
                      }
                      .onClick(() => {
                        router.pushUrl({
                          url: "pages/NewsDetail",
                          params: item
                        })
                      })
                    }
                    .width('100%')

                    Row({ space: 10 }) {
                      Text(item.author)
                        .fontSize(15)
                        .fontWeight(FontWeight.Normal)
                        .fontColor('#56000000')
                        .padding(10)

                      Row() {
                        Text(timeFormatModify(item.published))
                          .fontSize(15)
                          .fontColor('#56000000')
                      }
                      .layoutWeight(1)
                      .justifyContent(FlexAlign.End)
                      .padding(10)

                    }
                    .justifyContent(FlexAlign.Start)
                    .width('100%')

                    // Description
                    Row() {
                      Text(item.description)
                        .width('100%')
                    }
                    .padding(10)

                    Row({ space: 10 }) {
                      Image($r('app.media.icon_stared'))
                        .width(25)
                      Image($r('app.media.icon_link'))
                        .width(20)
                    }
                    .width('100%')
                    .height('7%')
                    .justifyContent(FlexAlign.Start)
                    .alignItems(VerticalAlign.Center)
                    .margin({ left: 10 })
                  }
                  .width('100%')
                }
                .margin({ bottom: 40 })
                .backgroundColor('#ffe4f3f3')
                .borderRadius(10)
              })
            }
            .width('90%')

            // Image

            // Title

            // Author

            // Publish time

          }
          .width('100%')
          .alignItems(HorizontalAlign.Center)
        }
        .width('100%')
        .height('92%')
        .align(Alignment.Top)
        .zIndex(0)
      }
      .width('100%')
      .height('100%')

      Column() {
        // this.floatIconBuilder($r('app.media.icon_top'), () => {
        //   this.smoothScrollToTop()
        // })
        this.floatIconBuilder($r('app.media.icon_stared'), () => {
          router.pushUrl({
            url: 'pages/StarPage'
          })
        })
        this.floatIconBuilder($r('app.media.icon_search'), () => {
          router.pushUrl({
            url: 'pages/SearchPage'
          })
        })
      }
      .margin({ right: 10, bottom: 10 })
    }
    .width('100%')
    .height('100%')
    .align(Alignment.BottomEnd)
  }
}