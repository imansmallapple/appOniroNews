import relationalStore from '@ohos.data.relationalStore';
import { AccountNewsDto } from '../dto/AccountNews/AccountNewsDto';
import { AccountNewsEntity } from '../entity/AccountNewsEntity';

export class AccountNewsMapper {
  public static toAccountNewsEntity(item: AccountNewsDto): AccountNewsEntity {
    return new AccountNewsEntity(
      item.account_email,
      item.news_id,
    )
  }

  public static toAccountDto(item: AccountNewsEntity): AccountNewsDto {
    return {
      account_email: item.account_email,
      news_id: item.news_id
    }
  }

  public static resultSetToAccountNews(resultSet: relationalStore.ResultSet): AccountNewsDto[] {
    const accountNewsList: AccountNewsDto[] = []
    while (resultSet.goToNextRow()) {
      const accountNews: AccountNewsDto = {
        account_email: resultSet.getString(resultSet.getColumnIndex('account_email')),
        news_id: resultSet.getString(resultSet.getColumnIndex('news_id')),
      }
      accountNewsList.push(accountNews)
    }
    return accountNewsList
  }

  public static entityToSave(entity: AccountNewsEntity): relationalStore.ValuesBucket {
    return {
      account_email: entity.account_email,
      news_id: entity.news_id
    }
  }
}