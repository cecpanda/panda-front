import { axios } from '@/utils/request'
import api from './index'

export const getInfo = () => {
  return axios.get(api.UserInfo)
}
