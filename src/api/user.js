import { axios } from '@/utils/request'
import api from './index'

export const getUsers = () => {
  return axios.get(api.User)
}

export const getUser = (username) => {
  return axios.get(`${api.User}${username}/`)
}
