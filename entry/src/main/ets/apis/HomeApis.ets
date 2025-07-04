import { http } from '../http/Http';

export const getHomeData = <T>(): Promise<T> => {
  return http.get<T>('/home/info')
}

export const getRecommendHouse = <T>(): Promise<T> => {
  return http.get<T>('/house/nearbyHouses')
}