import Vue from 'vue'
import Router from 'vue-router'
import { constantRouterMap } from '@/config/router.config'

Vue.use(Router)

const router = new Router({
  mode: 'history',
  base: process.env.BASE_URL,
  scrollBehavior: () => ({ y: 0 }),
  routes: constantRouterMap
})

// 此功能已经在 '@/permission.js' 中实现了
//
// router.beforeEach(async (to, from, next) => {
//   if (to.matched.some(r => r.meta.requireAuth)) {
//     await store.dispatch('InitLoginStatus')
//     if (store.getters.loginStatus) {
//       next()
//     } else {
//       next({
//         name: 'login',
//         query: { redirect: to.fullPathh }
//       })
//     }
//   } else {
//     next()
//   }
// })

export default router
