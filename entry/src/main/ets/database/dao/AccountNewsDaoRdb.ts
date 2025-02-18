import { BaseRelationalDatabase } from '../db/BaseRelationalDB'
import { AccountNewsDto } from '../dto/AccountNews/AccountNewsDto'
import { AccountNewsEntity } from '../entity/AccountNewsEntity'
import { AccountNewsMapper } from '../mapper/AccountNewsMapper'
import { IAccountNewsDao } from './IAccountNewsDao'

export class AccountNewsDaoRdb implements IAccountNewsDao {
  private db: BaseRelationalDatabase

  constructor(dbInstance: BaseRelationalDatabase) {
    this.db = dbInstance
  }

  addAccountNews(item: AccountNewsDto): Promise<number> {
    return this.db.insert<AccountNewsEntity>(
      AccountNewsEntity.getTableName(),
      AccountNewsMapper.toAccountNewsEntity(item),
      (entity) => AccountNewsMapper.entityToSave(entity),
      true
    )
  }
}