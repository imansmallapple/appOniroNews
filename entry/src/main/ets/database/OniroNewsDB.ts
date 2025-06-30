import { relationalStore } from '@kit.ArkData'
import { BaseRelationalDatabase } from '../database/db/BaseRelationalDB'
import { Context } from '@kit.AbilityKit'
import { DBConfig } from './config/DbConfig'
import Log from '../utils/Log'

export class OniroNewsDB extends BaseRelationalDatabase {
  private static instance: OniroNewsDB | null = null

  private constructor(rdbStore: relationalStore.RdbStore) {
    super(rdbStore)
  }

  public static async getInstance(context: Context): Promise<OniroNewsDB> {
    // If instance not exists
    if (!OniroNewsDB.instance) {
      const store = await relationalStore.getRdbStore(context, DBConfig.STORE_CONFIG)
      await OniroNewsDB.initializeTables(store)
      OniroNewsDB.instance = new OniroNewsDB(store)
      Log.debug('DB initialized:' + DBConfig.STORE_CONFIG.name)
    }
    return OniroNewsDB.instance
  }

  public static async initializeTables(store: relationalStore.RdbStore): Promise<void> {
    await store.executeSql(DBConfig.NEWS_TABLE.sqlCreate)
    Log.debug(`DB Table created: ${DBConfig.NEWS_TABLE.tableName}[${DBConfig.NEWS_TABLE.columns}]`)
    await store.executeSql(DBConfig.ACCOUNT_TABLE.sqlCreate)
    Log.debug(`DB Table created: ${DBConfig.ACCOUNT_TABLE.tableName}[${DBConfig.ACCOUNT_TABLE.columns}]`)
    await store.executeSql(DBConfig.ACCOUNT_NEWS_TABLE.sqlCreate)
    Log.debug(`DB Table created: ${DBConfig.ACCOUNT_NEWS_TABLE.tableName}[${DBConfig.ACCOUNT_NEWS_TABLE.columns}]`)
  }
}

