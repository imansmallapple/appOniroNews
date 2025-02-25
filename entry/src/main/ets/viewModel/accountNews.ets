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

  async getUserNews(email: string): Promise<string[]> {
    const userAccountNews = await this.accountNewsDao.getNewsByEmail(email)
    Log.info(TAG, 'userAccountNews', JSON.stringify(userAccountNews))
    let res: string[] = []
    userAccountNews.forEach((item) => {
      res.push(item.news_id)
    })
    return res
  }

  // async getUserNews(email: string): Promise<string[]> {
  //   const userAccountNews = await this.accountNewsDao.getNewsByEmail(email);
  //   Log.info(TAG, 'userAccountNews', JSON.stringify(userAccountNews));
  //
  //   let res = userAccountNews.map(item => item.news_id);
  //   Log.info(TAG, 'Final news list:', JSON.stringify(res));
  //
  //   return res;
  // }

  async addUserNews(email: string, newsId: string): Promise<number> {
    let entity: AccountNewsDto = {
      account_email: email,
      news_id: newsId
    }
    let res = await this.accountNewsDao.addAccountNews(entity)
    return res
  }

  async removeUserNews(email: string, newsId: string): Promise<number> {
    let entity: AccountNewsDto = {
      account_email: email,
      news_id: newsId
    }
    let res = await this.accountNewsDao.removeAccountNews(entity)
    return res
  }
}