import { BaseRelationalDatabase } from '../db/BaseRelationalDB'
import { AccountNewsDto } from '../dto/AccountNews/AccountNewsDto'
import { AccountNewsEntity } from '../entity/AccountNewsEntity'
import { AccountNewsMapper } from '../mapper/AccountNewsMapper'
import { IAccountNewsDao } from './IAccountNewsDao'
import relationalStore from '@ohos.data.relationalStore'

export class AccountNewsDaoRdb implements IAccountNewsDao {
  private db: BaseRelationalDatabase

  constructor(dbInstance: BaseRelationalDatabase) {
    this.db = dbInstance
  }

  async getAllAccountNews(): Promise<AccountNewsDto[]> {
    return this.db.query(
      AccountNewsEntity.getTableName(),
      AccountNewsEntity.getTableColumns(),
      (predicates) => predicates,
      (resultSet: relationalStore.ResultSet) => AccountNewsMapper.resultSetToAccountNews(resultSet)
    )
  }

  getNewsByEmail(email: string): Promise<AccountNewsDto[]> {
    return this.db.query(
      AccountNewsEntity.getTableName(),
      AccountNewsEntity.getTableColumns(),
      (predicates) => predicates.equalTo(AccountNewsEntity.getTableColumns()[0], email),
      (resultSet: relationalStore.ResultSet) => AccountNewsMapper.resultSetToAccountNews(resultSet)
    )
  }

  getByNewsId(id: string): Promise<AccountNewsDto[]> {
    return this.db.query(
      AccountNewsEntity.getTableName(),
      AccountNewsEntity.getTableColumns(),
      (predicates) => predicates.equalTo(AccountNewsEntity.getTableColumns()[1], id),
      (resultSet: relationalStore.ResultSet) => AccountNewsMapper.resultSetToAccountNews(resultSet)
    )
  }

  removeAccountNews(item: AccountNewsDto): Promise<number> {
    return this.db.delete<AccountNewsEntity>(
      AccountNewsEntity.getTableName(),
      (predicates) => predicates.equalTo(AccountNewsEntity.getTableColumns()[0], item.account_email)
    )
  }

  async addAccountNews(item: AccountNewsDto): Promise<number> {
    return this.db.insert<AccountNewsEntity>(
      AccountNewsEntity.getTableName(),
      AccountNewsMapper.toAccountNewsEntity(item),
      (entity) => AccountNewsMapper.entityToSave(entity),
      true
    )
  }
}