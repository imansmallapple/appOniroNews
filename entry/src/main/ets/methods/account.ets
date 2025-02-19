import { OniroNewsDB } from '../database/OniroNewsDB'
import { AccountDaoRdb } from '../database/dao/AccountDaoRdb'
import { NewUserDto } from '../database/dto/Account/NewUserDto'
import Log from '../utils/Log'
import { passwordEncoder, passwordDecoder } from '../utils/passwordManager'
import { AccountNewsDaoRdb } from '../database/dao/AccountNewsDaoRdb'
import { AccountNewsDto } from '../database/dto/AccountNews/AccountNewsDto'
import { NewsDaoRdb } from '../database/dao/NewsDaoRdb'
import { NewsDto } from '../database/dto/News/NewsDto'

const Tag = 'Test RDB'

export async function runAccountOperations(context: Context): Promise<boolean> {
  try {
    const dbInstance = await OniroNewsDB.getInstance(context)

    const accountDao = new AccountDaoRdb(dbInstance)

    const newsDao = new NewsDaoRdb(dbInstance)

    const newNews: NewsDto = {
      id: 'wdwcw2rk2of32',
      title: 'This is title1',
      image: 'this is image1',
      url: 'this is url1',
      published: 'published1',
      description: 'description1',
      category: 'category1',
      author: 'author1',
      language: 'language1'
    }
    const newUser1: NewUserDto = {
      email: 'alf139540fun@gmail.com',
      username: 'alfred',
      token: '23243faefe'
    }

    const newUser2: NewUserDto = {
      email: 'alf138540fun@gmail.com',
      username: 'alfred',
      token: '23243faefe'
    }
    const accountNewsDao = new AccountNewsDaoRdb(dbInstance)
    const newAccountNews1: AccountNewsDto = {
      account_email: newUser1.email,
      news_id: newNews.id
    }
    const newAccountNews2: AccountNewsDto = {
      account_email: newUser2.email,
      news_id: newNews.id
    }
    const newAccountNewsId1 = await accountNewsDao.addAccountNews(newAccountNews1)
    const newAccountNewsId2 = await accountNewsDao.addAccountNews(newAccountNews2)
    Log.info(Tag, 'Inserted accountNews with ID:', newAccountNewsId1)
    Log.info(Tag, 'Inserted accountNews with ID:', newAccountNewsId2)

    const allAccountNews = await accountNewsDao.getAllAccountNews()
    Log.info(Tag, 'All account news:', JSON.stringify(allAccountNews.length))
    Log.info(Tag, 'All account news:', JSON.stringify(allAccountNews))

    const User1News = await accountNewsDao.getNewsByEmail('alf139540fun@gmail.com')
    const User2News = await accountNewsDao.getNewsByEmail('alf138540fun@gmail.com')
    const User3News = await accountNewsDao.getByNewsId('wdwcw2rk2of32')
    Log.info(Tag, 'User1News:', JSON.stringify(User1News))
    Log.info(Tag, 'User2News:', JSON.stringify(User2News))
    Log.info(Tag, 'User3News:', JSON.stringify(User3News))


    const newUserId = await accountDao.addUser(newUser1)
    Log.info(Tag, 'Inserted news with ID:', newUserId)
    const allAccounts = await accountDao.getAllUsers()
    Log.info(Tag, 'All news:', JSON.stringify(allAccounts))
    const userByName1 = await accountDao.getUserByName('alfred')
    Log.info(Tag, 'User alfred info1:', JSON.stringify(userByName1))
    const userByName2 = await accountDao.getUserByName('alf139540fun@gmail.com')
    Log.info(Tag, 'User alfred info2:', JSON.stringify(userByName2))

    const userByEmail1 = await accountDao.getUserByEmail('alf139540fun@gmail.com')
    const userByEmail2 = await accountDao.getUserByEmail('alf139540fun@gma.com')
    if (userByEmail1.length === 0) {
      Log.info(Tag, 'user1 not exist')
    } else {
      Log.info(Tag, 'user1 exist')
      return true
    }

    if (userByEmail2.length === 0) {
      Log.info(Tag, 'user2 not exist')
    } else {
      Log.info(Tag, 'user2 exist')
      return true
    }
    return false
  } catch (error) {
    Log.error(Tag, 'Error during DB operations', JSON.stringify(error))
    return false
  }
}

export class AccountManager {
  private TAG = 'Test RDB'
  private dbInstance!: OniroNewsDB
  private accountDao!: AccountDaoRdb
  private newUser?: NewUserDto

  private async initialize(context: Context) {
    try {
      this.dbInstance = await OniroNewsDB.getInstance(context)
      this.accountDao = new AccountDaoRdb(this.dbInstance)
    }
    catch (error) {
      Log.error(Tag, 'Error during DB operations', JSON.stringify(error))
    }
  }

  constructor(context: Context) {
    this.initialize(context)
  }

  async login(email: string, password: string): Promise<boolean> {
    const res: NewUserDto[] = await this.accountDao.getUserByEmail(email)
    if (res.length === 0) {
      Log.info(this.TAG, 'user not exist')
      return false
    } else {
      Log.info(this.TAG, 'user exist, check password')
      let checkRes = await this.checkUserPassword(res, password)
      return checkRes
    }
  }

  async register(email: string, username: string, password: string): Promise<boolean> {
    // todo: find if user exist in the db or not
    let res = await this.isUserExist(email)
    if (res == true) {
      Log.info(this.TAG, 'user exist')
      return false
    } else {
      Log.info(this.TAG, 'user not exist, can register')
      // todo: Check if input data legal or not
      const newUser: NewUserDto = {
        email: email,
        username: username,
        token: passwordEncoder(password)
      }
      let newUserId: number = await this.accountDao.addUser(newUser)
      Log.info(this.TAG, 'register successful', newUserId)
      return true
    }
  }

  async isUserExist(email: string): Promise<boolean> {
    const res: NewUserDto[] = await this.accountDao.getUserByEmail(email)
    if (res.length === 0) {
      Log.info(Tag, 'user not exist')
      return false
    } else {
      Log.info(Tag, 'user exist')
      return true
    }
  }

  async checkUserPassword(user: NewUserDto[], password: string): Promise<boolean> {
    let decodePwd: string = passwordDecoder(user[0].token)
    if (decodePwd == password) {
      return true
    } else {
      return false
    }
  }

  isDataLegal(username: string, email: string, password: string, repeat: string): boolean {
    if (password !== repeat) {
      Log.info(this.TAG, 'password don\'t match')
      return false
    }
    const emailRegex: RegExp = new RegExp("^[^\\s@]+@[^\s@]+\\.(com|net|org|edu|gov|info|io|cn)$")
    const passwordRegex: RegExp = new RegExp("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{8,}$")

    // username at least 6 letters long
    if (username.length < 6) {
      Log.info(this.TAG, 'username ileagal')
      return false
    }

    // email at least 6 letters long and must have @ and .com like ending
    if (email.length < 6 || !emailRegex.test(email)) {
      Log.info(this.TAG, 'email illegal');
      return false;
    }

    // password at least 8 letters long and must have capital and small letters and numbers
    if (!passwordRegex.test(password)) {
      Log.info(this.TAG, 'password illegal');
      return false;
    }
    return true
  }
}