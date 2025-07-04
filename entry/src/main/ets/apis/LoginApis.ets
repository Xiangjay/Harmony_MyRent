import { http } from '../http/Http';

export const getVerifyCode = <T>(phoneNumber: string): Promise<T> => {
  return http.post<T>('/sendSMSCode', { phone: phoneNumber })
}

export const login = <T>(phoneNumber: string, verifyCode: string): Promise<T> => {
  return http.post<T>('/login', { phone: phoneNumber, code: verifyCode })
}

export const getUserInfo = <T>(): Promise<T> => {
  return http.get<T>('/auth/user/userInfo')
}