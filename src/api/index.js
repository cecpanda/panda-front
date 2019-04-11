const authHost = process.env.VUE_APP_AUTH_HOST

const api = {
  Login: `${authHost}/jwt/auth/`,
  ForgePassword: `${authHost}/account/forge-password/`,
  Register: `${authHost}/account/register/`,
  SmsCaptcha: '/mock/mock.json',
  // get my info
  UserInfo: `${authHost}/account/user/info/`
}

export default api
