import { asyncRouterMap, constantRouterMap } from '@/config/router.config'

function isMenu (route, menu) {
  if (route.meta && route.meta.menu) {
    for (const m of menu) {
      if (route.meta.menu.includes(m)) {
        return true
      }
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
    addRputers: []
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
