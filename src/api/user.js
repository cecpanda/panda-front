import { axios } from '@/utils/request'
import api from './index'

export const getUsers = () => {
  return axios.get(api.User)
}

export const getUser = (username) => {
  return axios.get(`${api.User}${username}/`)
}

export const changeAvatar = (data) => {
  return axios.post(`${api.User}change-avatar/`, data)
}

export const changeProfile = (data) => {
  return axios.post(`${api.User}change-profile/`, data)
}

export const changePassword = (data) => {
  return axios.post(`${api.User}change-password/`, data)
}
