import { http } from '../http/Http';

export const getDiscoverData = <T>(): Promise<T> => {
  return http.get<T>('/discover/info')
}