import router from './router'
import store from './store'

import NProgress from 'nprogress' // progress bar
import 'nprogress/nprogress.css' // progress bar style
import notification from 'ant-design-vue/es/notification'
import { timeFix, welcome } from '@/utils/util'
import { setDocumentTitle, domTitle } from '@/utils/domUtil'

NProgress.configure({ speed: 200, showSpinner: false }) // NProgress Configuration

const whiteList = ['home', 'login', 'register', 'registerResult'] // no redirect whitelist

router.beforeEach(async (to, from, next) => {
  NProgress.start() // start progress bar
  to.meta && (typeof to.meta.title !== 'undefined' && setDocumentTitle(`${to.meta.title} - ${domTitle}`))

  // 每次切换路由都会请求一次 userinfo，不太行
  await store.dispatch('InitLoginStatus')
    .then(() => {

    })
    .catch(err => {
      console.log(err)
    })

  // console.log('-----------------')
  // console.log(to)
  // console.log(store.getters.loginStatus)
  // console.log('-----------------')

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
    if (whiteList.includes(to.name)) {
      // 在免登录白名单，直接进入
      next()
    } else {
      next({ name: 'login', query: { redirect: to.fullPath } })
      NProgress.done() // if current page is login will not trigger afterEach hook, so manually handle it
    }
  }
})

router.afterEach(() => {
  NProgress.done() // finish progress bar
})
