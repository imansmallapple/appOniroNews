import { DataSource } from '../data/DataSource';
import { NewsResponse, News } from '../model/news';
import hilog from '@ohos.hilog';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State latestNews: News[] = []

  async aboutToAppear(): Promise<void> {
    let source = new DataSource()
    let res: NewsResponse = await source.getLatestNews('en')
    this.latestNews = res.news
    hilog.info(0x00, 'latest', JSON.stringify(this.latestNews))
    let res1: NewsResponse = await source.searchNews('en', 'trump', 1)
    hilog.info(0x00, 'latest', JSON.stringify(res1))
  }

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }
}