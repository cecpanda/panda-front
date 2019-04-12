import Vue from 'vue'
import { login, getInfo, getInfo2 } from '@/api/login'
import { ACCESS_TOKEN } from '@/store/mutation-types'
import { welcome } from '@/utils/util'

const user = {
  state: {
    token: '', // 为什么刷新后 state.token 还在？因为 bootstrap()
    username: '',
    realname: '',
    avatar: ''
    // name: '',
    // welcome: '',
    // avatar: '',
    // roles: [],
    // info: {}
  },

  mutations: {
    SET_TOKEN: (state, token) => {
      state.token = token
    },
    SET_USER: (state, user) => {
      state.username = user.username
      state.realname = user.realname
      state.avatar = user.avatar
    }
    // SET_NAME: (state, { name, welcome }) => {
    //   state.name = name
    //   state.welcome = welcome
    // },
    // SET_NAME: (state, { username, realname, avatar, welcome }) => {
    //   state.username = username
    //   state.realname = realname
    //   state.avatar = avatar
    //   state.welcome = welcome
    // },
    // SET_AVATAR: (state, avatar) => {
    //   state.avatar = avatar
    // },
    // SET_ROLES: (state, roles) => {
    //   state.roles = roles
    // },
    // SET_INFO: (state, info) => {
    //   state.info = info
    // }
  },

  actions: {
    // 登录
    Login ({ commit }, userInfo) {
      return new Promise((resolve, reject) => {
        login(userInfo).then(res => {
          Vue.ls.set(ACCESS_TOKEN, res.token, 7 * 24 * 60 * 60 * 1000)
          commit('SET_TOKEN', res.token)
          resolve()
        }).catch(error => {
          reject(error)
        })
      })
    },

    InitLoginStatus ({ commit }) {
      return new Promise((resolve, reject) => {
        getInfo2()
          .then(res => {
            commit('SET_USER', res)
            resolve(res)
          })
          .catch(err => {
            // reject(err)  // 当token 错误时会在console中打印 vue warn
            console.log(err)
          })
      })
    },

    // 获取用户信息
    GetInfo ({ commit }) {
      return new Promise((resolve, reject) => {
        getInfo().then(response => {
          const result = response.result

          if (result.role && result.role.permissions.length > 0) {
            const role = result.role
            role.permissions = result.role.permissions
            role.permissions.map(per => {
              if (per.actionEntitySet != null && per.actionEntitySet.length > 0) {
                const action = per.actionEntitySet.map(action => { return action.action })
                per.actionList = action
              }
            })
            role.permissionList = role.permissions.map(permission => { return permission.permissionId })
            commit('SET_ROLES', result.role)
            commit('SET_INFO', result)
          } else {
            reject(new Error('getInfo: roles must be a non-null array !'))
          }

          commit('SET_NAME', { name: result.name, welcome: welcome() })
          commit('SET_AVATAR', result.avatar)

          resolve(response)
        }).catch(error => {
          reject(error)
        })
      })
    },

    // 登出
    Logout ({ commit, state }) {
      commit('SET_TOKEN', '')
      // commit('SET_ROLES', [])
      commit('SET_USER', {})
      Vue.ls.remove(ACCESS_TOKEN)
      // return new Promise((resolve) => {
      //   commit('SET_TOKEN', '')
      //   // commit('SET_ROLES', [])
      //   commit('SET_NAME', {})
      //   Vue.ls.remove(ACCESS_TOKEN)

      //   logout(state.token).then(() => {
      //     resolve()
      //   }).catch(() => {
      //     resolve()
      //   })
      // })
    }

  }
}

export default user
