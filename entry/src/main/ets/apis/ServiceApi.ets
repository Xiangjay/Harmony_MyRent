import { http } from '../http/Http';

export const getServiceData = <T>(): Promise<T> => {
  return http.get<T>('/service/info')
}