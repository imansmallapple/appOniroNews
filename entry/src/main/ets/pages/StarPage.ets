import { AccountNewsManager } from '../methods/accountNews'
import router from '@ohos.router'
import { NewsDto } from '../database/dto/News/NewsDto'
import { NewsManager } from '../methods/news'
import Log from '../utils/Log'

interface RouterParams {
  email: string
  accountNewsManager: AccountNewsManager
  newsManager: NewsManager
  savedNewsId: string[]
}

const Tag: string = 'Test saved news'

@Entry
@Component
struct StarPage {
  private email: string = ''
  private accountNewsManager!: AccountNewsManager
  private newsManager !: NewsManager
  @State message: string = ''
  @State savedNewsId: string[] = []
  @State SavedNews: NewsDto[] = []

  async aboutToAppear(): Promise<void> {
    let res: RouterParams = router.getParams() as RouterParams
    this.email = res.email
    this.accountNewsManager = res.accountNewsManager
    this.savedNewsId = res.savedNewsId
    Log.info('Test Star', 'About To Appear')
    Log.info('Test Star', res)
    Log.info('Test Star saved news ids: ', this.savedNewsId)
    // this.savedNewsId.forEach(async (id: string) => {
    //   let res = await this.newsManager.getNewsById(id)
    //  this.SavedNews.push(res.pop() as NewsDto)
    // })
    // Log.info('Test Star this.SavedNews: ', this.SavedNews)

    for (const id of this.savedNewsId) {
      let res = await this.newsManager.getNewsById(id);
      this.SavedNews.push(res.pop() as NewsDto);
    }

    Log.info('Test Star this.SavedNews: ', JSON.stringify(this.SavedNews));
  }

  // async testGet() {
  //   this.savedNewsIds = await this.accountNewsManager.getUserNews(this.email)
  //   Log.info('Test Star', JSON.stringify(this.savedNewsIds))
  // }

  async onPageShow(): Promise<void> {
    // Log.info('Test Star', 'On Page Show')
    // let res2: NewsDto[] = await this.accountNewsManager.getUserNews(this.email, this.newsManager)
    // this.savedNews = res2
    // Log.info('Test Star', JSON.stringify(res2))
    // this.message = JSON.stringify(this.savedNews)
    // Log.info('Test Star', 'On Page Show')
    // Log.info('Test Star', JSON.stringify(this.savedNews))
  }

  async showAllNews(email: string) {
    let res = await this.accountNewsManager.getUserNews(email)
    Log.info(Tag, 'user all news:', JSON.stringify(res))
  }

  build() {
    Column() {
      Text(`message: ${this.message}`)
      Button('test')
        .onClick(() => {
          Log.info(Tag, 'email:', this.email)
          this.showAllNews(this.email)
          // this.testGet()
          // let res = await this.accountNewsManager.getUserNews('alf138540fun@gmail.com', this.newsManager)
          // Log.info('Test Star', 'Account News Manager method test:', JSON.stringify(res))
        })
    }
    .width('100%')
    .height('100%')
  }
}