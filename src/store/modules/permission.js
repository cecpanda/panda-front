import { asyncRouterMap, constantRouterMap } from '@/config/router.config'

// menu 中的元素是 or 的关系
// function isMenu (route, menu) {
//   if (route.meta && route.meta.menu) {
//     if (route.meta.menu.length) {
//       for (const m of menu) {
//         if (route.meta.menu.includes(m)) {
//           return true
//         }
//       }
//     } else {
//       return true // menu: [], 表示没有 menu 要求
//     }
//     return false
//   }
//   return true
// }

// menu 中的元素是 and 的关系
function isMenu (route, menu) {
  if (route.meta && route.meta.menu) {
    const yes = route.meta.menu.every(value => {
      return menu.includes(value)
    })
    if (yes) {
      return true
    }
    return false
  }
  return true
}

function filterAsyncRouter (routerMap, menu) {
  const accessedRouters = routerMap.filter(route => {
    if (isMenu(route, menu)) {
      if (route.children && route.children.length) {
        route.children = filterAsyncRouter(route.children, menu)
      }
      return true
    }
    return false
  })
  return accessedRouters
}

const permission = {
  state: {
    routers: constantRouterMap,
    addRouters: []
  },
  mutations: {
    SET_ROUTERS: (state, routers) => {
      state.addRouters = routers
      state.routers = constantRouterMap.concat(routers)
    }
  },
  actions: {
    GenerateRoutes ({ commit }, menu) {
      return new Promise(resolve => {
        const accessedRouters = filterAsyncRouter(asyncRouterMap, menu)
        commit('SET_ROUTERS', accessedRouters)
        resolve()
      })
    }
  }
}

export default permission
