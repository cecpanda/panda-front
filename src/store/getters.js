const getters = {
  device: state => state.app.device,
  theme: state => state.app.theme,
  color: state => state.app.color,
  token: state => state.user.token,
  // avatar: state => state.user.avatar,
  // nickname: state => state.user.name,
  // welcome: state => state.user.welcome,
  // roles: state => state.user.roles,
  // userInfo: state => state.user.info,
  addRouters: state => state.permission.addRouters,
  multiTab: state => state.app.multiTab,
  // username: state => state.user.username,
  // realname: state => state.user.realname
  loginStatus: state => {
    if (state.user.token && state.user.username) {
      return true
    } else {
      return false
    }
  },
  user: state => {
    return {
      username: state.user.username,
      realname: state.user.realname,
      avatar: state.user.avatar
    }
  }
}

export default getters
