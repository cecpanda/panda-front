import router from './router'
import store from './store'

import NProgress from 'nprogress' // progress bar
import 'nprogress/nprogress.css' // progress bar style
import notification from 'ant-design-vue/es/notification'
import { timeFix, welcome } from '@/utils/util'
import { setDocumentTitle, domTitle } from '@/utils/domUtil'

NProgress.configure({ speed: 200, showSpinner: false }) // NProgress Configuration

// const whiteList = ['home', 'login', 'register', 'registerResult'] // no redirect whitelist

router.beforeEach(async (to, from, next) => {
  NProgress.start() // start progress bar
  to.meta && (typeof to.meta.title !== 'undefined' && setDocumentTitle(`${to.meta.title} - ${domTitle}`))

  // 每次切换路由都会请求一次 userinfo，不太行
  // if (store.getters.loginStatus) {

  // } else {
  //   console.log('InitLoginStatus')
  //   await store.dispatch('InitLoginStatus')
  //     .then(() => {

  //     })
  //     .catch(err => {
  //       console.log(err)
  //     })
  // }

  console.log('---------------------------')
  console.log('to: ', to)
  console.log(store.getters.token)
  console.log(store.getters.user)
  console.log(store.getters.loginStatus)
  console.log('--------------------------')

  if (store.getters.loginStatus) {
    if (to.name === 'login') {
      notification.info({
        message: `${timeFix()}, 你已经登录了`,
        description: `${welcome()}`
      })
      next({ name: 'account' })
    } else {
      next()
    }
  } else {
    // 已登录的用户就不再多那么一次请求了
    console.log('InitLoginStatus')
    await store.dispatch('InitLoginStatus')
      .then(() => {

      })
      .catch(err => {
        console.log('permission.js InitLoginStatus: ', err)
      })
    await store.dispatch('GenerateRoutes', store.getters.menu)
      .then(() => {
        router.addRoutes(store.getters.addRouters)
      })
      .catch(err => {
        console.log('permission.js GenerateRoutes: ', err)
      })
    next({ path: to.fullPath })
    // if (whiteList.includes(to.name)) {
    //   // 在免登录白名单，直接进入
    //   next()
    // } else {
    //   next({ name: 'login', query: { redirect: to.fullPath } })
    //   NProgress.done() // if current page is login will not trigger afterEach hook, so manually handle it
    // }
  }
})

router.afterEach(() => {
  NProgress.done() // finish progress bar
})
