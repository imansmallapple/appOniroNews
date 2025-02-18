import { AccountNewsDto } from '../dto/AccountNews/AccountNewsDto'

export interface IAccountNewsDao {
  addAccountNews(item: AccountNewsDto): Promise<number>
}