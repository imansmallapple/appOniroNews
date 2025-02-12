import http from '@ohos.net.http'
import abilityTest from '../../../ohosTest/ets/test/Ability.test'
import { NewsResponse } from '../model/news'
import { BusinessError } from '@ohos.base'
import hilog from '@ohos.hilog'
import { CategoryResponse } from '../model/categories'

const BaseUrl = 'https://api.currentsapi.services'
const key = 'Eg_5qbw7G1byzAwGqffkMLnp61rDmuDqqjc0ekYmgsyMgF6y'
const LatestNewsUrl = BaseUrl + '/v1/latest-news'
const SearchNews = BaseUrl + '/v1/search'


export class DataSource {
  constructor() {
  }

  async getLatestNews(language: string, category?: string): Promise<NewsResponse> {
    return new Promise<NewsResponse>((resolve, reject) => {
      let httpRequest = http.createHttp()
      httpRequest.request(LatestNewsUrl + `?language=${language}&apiKey=${key}` + (category ? `&category=${category}` : ''),
        {
          method: http.RequestMethod.GET,
          readTimeout: 30000,
          connectTimeout: 30000,
        },
        (err: BusinessError, data: http.HttpResponse) => {
          if (!err) {
            try {
              let responseData: NewsResponse = JSON.parse(data.result as string)
              resolve(responseData)
            } catch (error) {
              reject('Failed to parse response data')
            }
            finally {
              httpRequest.off('headersReceive');
              httpRequest.destroy();
            }
          } else {
            reject('Error: ' + err)
          }
        })
    })
  }

  async searchNews(language: string, keywords: string, type: number, page_number?: number): Promise<NewsResponse> {
    return new Promise<NewsResponse>((resolve, reject) => {
      let httpRequest = http.createHttp()
      httpRequest.request(SearchNews + `?language=${language}&keywords=${keywords}&type=${type}&apiKey=${key}`,
        {
          method: http.RequestMethod.GET,
          readTimeout: 30000,
          connectTimeout: 30000,
        },
        (err: BusinessError, data: http.HttpResponse) => {
          if (!err) {
            try {
              let responseData: NewsResponse = JSON.parse(data.result as string)
              resolve(responseData)
            } catch (error) {
              reject('Failed to parse response data')
            }
            finally {
              httpRequest.off('headersReceive');
              httpRequest.destroy();
            }
          } else {
            reject('Error: ' + err)
          }
        })
    })
  }

  async getCategories(): Promise<CategoryResponse> {
    return new Promise<CategoryResponse>((resolve, reject) => {
      let httpRequest = http.createHttp()
      httpRequest.request(BaseUrl + '/v1/available/categories',
        {
          method: http.RequestMethod.GET,
          readTimeout: 30000,
          connectTimeout: 30000,
        },
        (err: BusinessError, data: http.HttpResponse) => {
          if (!err) {
            try {
              let responseData: CategoryResponse = JSON.parse(data.result as string)
              resolve(responseData)
            } catch (error) {
              reject('Failed to parse response data')
            }
            finally {
              httpRequest.off('headersReceive');
              httpRequest.destroy();
            }
          } else {
            reject('Error: ' + err)
          }
        })
    })
  }

  async fetchHttpCode(): Promise<number> {
    try {
      let httpRequest = http.createHttp();
      const response = await new Promise<number>((resolve, reject) => {
        httpRequest.request(LatestNewsUrl + `?language=en&apiKey=${key}`,
          (err: Error, data: http.HttpResponse) => {
            if (!err) {
              resolve(data.responseCode);
            } else {
              reject(err);
            }
          });
      });
      return response;
    } catch (error) {
      console.error('Error fetching HTTP code:', error);
      return -1;
    }
  }
}