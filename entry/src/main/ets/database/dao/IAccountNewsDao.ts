import { AccountNewsDto } from '../dto/AccountNews/AccountNewsDto'

export interface IAccountNewsDao {
  addAccountNews(item: AccountNewsDto): Promise<number>

  removeAccountNews(item: AccountNewsDto): Promise<number>

  getNewsByEmail(email: string): Promise<AccountNewsDto[]>

  getAllAccountNews(): Promise<AccountNewsDto[]>

  getByNewsId(id: string): Promise<AccountNewsDto[]>
}