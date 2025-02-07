import { DataSource } from '../data/DataSource'
import { NewsResponse, News } from '../model/news'
import hilog from '@ohos.hilog'
import { CategoryResponse } from '../model/categories'

@Entry
@Component
struct Index {
  @State message: string = 'Hello World'
  @State latestNews: News[] = []
  @State categories: string[] = []
  private source = new DataSource()

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

  build() {
    Column() {
      Row({ space: 10 }) {
        // Image($r('app.media.icon_back'))
        //   .width(30)
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
      .margin({ left: 10 })
      .backgroundColor('#ff4e4c4c')

      // todo: Replace the index news with categories
      Scroll() {
        Column() {
          List() {
            ForEach(this.latestNews, (item: News) => {
              ListItem() {
                Column() {
                  Column() {
                    Image(item.image)
                      .width('100%')

                    Text(item.title)
                      .fontSize(20)
                      .fontColor(Color.White)
                      .fontWeight(700)
                  }
                  .width('100%')

                  Column({ space: 10 }) {
                    Text(item.author)
                      .fontSize(15)
                      .fontColor(Color.White)

                    Text(item.published)
                      .fontSize(15)
                      .fontColor(Color.White)
                  }
                  .alignItems(HorizontalAlign.Start)
                  .width('100%')
                }
                .width('100%')
                .margin({ bottom: 40 })
              }
            })
          }

          // Image

          // Title

          // Author

          // Publish time

        }
      }
      .width('100%')
      .height('88%')
      .align(Alignment.Top)
      .zIndex(0)
    }
    .width('100%')
    .backgroundColor(Color.Black)
  }
}