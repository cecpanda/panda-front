import Vue from 'vue'
import router from './router'
import store from './store'

import NProgress from 'nprogress' // progress bar
import 'nprogress/nprogress.css' // progress bar style
import notification from 'ant-design-vue/es/notification'
import { timeFix, welcome } from '@/utils/util'
import { setDocumentTitle, domTitle } from '@/utils/domUtil'
import { getPermission } from '@/api/user'

NProgress.configure({ speed: 200, showSpinner: false }) // NProgress Configuration

// no redirect whitelist
const whiteList = [
  null,
  undefined,
  'home',
  'login',
  'register',
  'registerResult',
  'docs',
  'docs-it-sys',
  'docs-it-sys-titan-check',
  'docs-it-sys-titan-protocol',
  'docs-it-sys-titan-lantern',
  'docs-it-sys-titan-pkg',
  'docs-it-sys-titan-serviceguard',
  'docs-it-sys-titan-monitor'
]

var isInited = false

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
  if (!isInited) {
    isInited = true
    await store.dispatch('InitLoginStatus')
      .then(() => {

      })
      .catch(err => {
        console.log('InitLoginStatus: ', err)
      })
    await store.dispatch('GenerateRoutes', store.getters.menu)
      .then(() => {
        router.addRoutes(store.getters.addRouters)
        const redirect = decodeURIComponent(from.query.redirect || to.path)
        if (to.path === redirect) {
          // hack方法 确保addRoutes已完成 ,set the replace: true so the navigation will not leave a history record
          next({ ...to, replace: true })
        } else {
          // 跳转到目的路由
          next({ path: redirect })
        }
      })
      .catch(err => {
        console.log('GenerateRoutes: ', err)
      })
  }

  // console.log('---------------------------')
  // console.log('to: ', to)
  // console.log(store.getters.user)
  // console.log(store.getters.loginStatus)

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

const action = Vue.directive('action', {
  bind: function (el, binding, vnode) {
    const data = {
      action: binding.arg,
      app: binding.value.app,
      service: binding.value.service
    }
    getPermission(data)
      .then(res => {
        if (!res.allowed) {
          el.parentNode && el.parentNode.removeChild(el) || (el.style.display = 'none')
        }
      })
      .catch(() => {
        el.parentNode && el.parentNode.removeChild(el) || (el.style.display = 'none')
      })
  }
})

const services = {
  'ItSysTft': { app: 'it-sys', service: 'it-sys-tft' },
  'ItSysLcd': { app: 'it-sys', service: 'it-sys-lcd' }
}

export { action, services }
