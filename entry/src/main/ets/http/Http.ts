import axios, { AxiosError, AxiosResponse } from '@ohos/axios'
import log from '@open/log/src/main/ets/utils/log'
import { BasicConstants } from '../common/constants/BasicConstants'
import { AnyObject } from '../models/HttpDataModel'

const request = axios.create({
  baseURL: `${BasicConstants.BASE_IP}:${BasicConstants.PORT}`
})

request.interceptors.request.use((config) => {
  // 因为ts文件不能引入ets文件，所以这里用AppStorage代替preferencesUtil获取token
  const token: string = AppStorage.get('token')
  if (token) {
    config.headers.token = token
  }
  return config
})
request.interceptors.response.use((response: AxiosResponse) => {
  // 对响应数据做点什么
  return response.data.data;
}, (error: AxiosError) => {
  // 对响应错误做点什么
  return Promise.reject(error);
});

class Http {
  get<T>(url: string, params?: AnyObject) {
    return request.get<any, T>(url, { params })
  }

  post<T>(url: string, data?: AnyObject) {
    return request.post<any, T>(url, data)
  }

  put<T>(url: string, data?: AnyObject) {
    return request.put<any, T>(url, data)
  }

  delete<T>(url: string, params?: AnyObject) {
    return request.delete<any, T>(url, { params })
  }
}

export const http = new Http()