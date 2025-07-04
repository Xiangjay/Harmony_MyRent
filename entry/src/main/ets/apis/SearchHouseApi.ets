import { http } from '../http/Http';
import { ISearchHouseParams } from '../models/HouseModels';

// 搜索房源
export const searchHouses = <T>(params: ISearchHouseParams): Promise<T> => {
  return http.get<T>('/house/search', params)
}

// 获取省份列表
export const getAllProvinces = <T>(): Promise<T> => {
  return http.get<T>('/province')
}

// 根据省份code获取城市列表
export const getAllCitiesByProvinceId = <T>(code: string): Promise<T> => {
  return http.get<T>('/city', { provinceCode: code })
}

// 根据城市code获取区县列表
export const getAllAreasByCityId = <T>(code: string): Promise<T> => {
  return http.get<T>('/area', { cityCode: code })
}