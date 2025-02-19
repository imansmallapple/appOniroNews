import { OniroNewsDB } from '../database/OniroNewsDB'
import { AccountDaoRdb } from '../database/dao/AccountDaoRdb'
import { NewUserDto } from '../database/dto/Account/NewUserDto'
import Log from '../utils/Log'
import { passwordEncoder, passwordDecoder } from '../utils/passwordManager'
import { AccountNewsDaoRdb } from '../database/dao/AccountNewsDaoRdb'
import { AccountNewsDto } from '../database/dto/AccountNews/AccountNewsDto'
import { NewsDaoRdb } from '../database/dao/NewsDaoRdb'
import { NewsDto } from '../database/dto/News/NewsDto'

const TAG = 'Test ACN'

export class AccountNewsManager {
  private dbInstance!: OniroNewsDB
  private accountNewsDao!: AccountNewsDaoRdb
  private newUser?: NewUserDto

  private async initialize(context: Context) {
    try {
      this.dbInstance = await OniroNewsDB.getInstance(context)
      this.accountNewsDao = new AccountNewsDaoRdb(this.dbInstance)
    }
    catch (error) {
      Log.error(TAG, 'Error during DB operations', JSON.stringify(error))
    }
  }

  constructor(context: Context) {
    this.initialize(context)
  }

  async getUserNews(email: string, newsDao: NewsDaoRdb): Promise<NewsDto[]> {
    const userAccountNews = await this.accountNewsDao.getNewsByEmail(email)
    Log.info(TAG, 'userAccountNews', JSON.stringify(userAccountNews))

    const newsPromises = userAccountNews.map(async (item) => {
      let res: NewsDto[] = await newsDao.getNewsById(item.news_id)
      return res.pop() // 可能为空
    })

    const results = await Promise.all(newsPromises)
    const currentUserNews = results.filter((news) => news !== undefined) as NewsDto[]

    Log.info(TAG, 'userAccountNews finish: ', JSON.stringify(currentUserNews))
    return currentUserNews
  }
}