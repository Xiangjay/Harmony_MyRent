import { http } from '../http/Http';
import { IReservation } from '../models/HouseModels';

// 根据房屋ID获取房屋详情
export const getHouseDetailById = <T>(id: string): Promise<T> => {
  return http.get<T>('/house/detail', { id })
}

// 预约看房
export const bookReservation = <T>(data: IReservation): Promise<T> => {
  return http.post<T>('/auth/house/reservation', data)
}

// 根据token获取用户预约的房源
export const getReservationByToken = <T>(): Promise<T> => {
  return http.get<T>('/auth/house/history')
}
