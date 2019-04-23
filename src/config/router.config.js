// eslint-disable-next-line
import { UserLayout, BasicLayout, RouteView, BlankLayout, PageView } from '@/layouts'

export const asyncRouterMap = [

  {
    path: '/',
    name: 'index',
    component: BasicLayout,
    meta: { title: '首页' },
    redirect: '/',
    children: [
      {
        path: '/',
        name: 'home',
        component: () => import('@/views/home/Home'),
        hidden: true,
        meta: { title: '首页' }
      },

      // 信息工程部, for manager
      {
        path: '/it',
        name: 'it',
        component: RouteView,
        meta: { title: '信息工程部', icon: 'robot', menu: ['it', 'manager'] },
        children: [
          {
            path: '/it/sys',
            name: 'it-sys',
            component: RouteView,
            meta: { title: '运营系统科' },
            children: [
              {
                path: '/it/sys/tft',
                name: 'it-sys-tft',
                component: () => import('@/views/it/sys/Tft'),
                meta: { title: 'TFT' }
              },
              {
                path: '/it/sys/lcd',
                name: 'it-sys-lcd',
                meta: { title: 'LCD' }
              }
            ]
          },
          {
            path: '/it/eq',
            name: 'it-eq',
            meta: { title: '运营设备科' }
          }
        ]
      },

      // 运营系统科, for department leader or room leader
      {
        path: '/it-sys',
        name: 'it-sys1',
        meta: { title: '运营系统科', icon: 'robot', menu: ['it-sys', 'leader'] },
        children: [
          {
            path: '/it-sys/tft',
            name: 'it-sys-tft1',
            meta: { title: 'TFT' }
          },
          {
            path: '/it-sys/lcd',
            name: 'it-sys-lcd1',
            meta: { title: 'LCD' }
          }
        ]
      },

      // 运营设备科
      {
        path: '/it-eq',
        name: 'it-eq1',
        meta: { title: '运营设备科', icon: 'robot', menu: ['it-eq', 'leader'] }
      },

      // for members
      {
        path: '/it-sys-tft',
        name: 'it-sys-tft2',
        meta: { title: 'TFT', icon: 'robot', menu: ['it-sys-tft', 'member'] }
      },

      {
        path: '/it-sys-lcd',
        name: 'it-sys-lcd2',
        meta: { title: 'LCD', icon: 'robot', menu: ['it-sys-lcd', 'member'] }
      },

      // 阵列制造部
      {
        path: '/tft',
        name: 'tft',
        meta: { title: '阵列制造部', icon: 'robot', menu: ['tft', 'manager'] },
        children: [
          {
            path: '/tft/cvd',
            name: 'tft-cvd',
            meta: { title: 'CVD', icon: 'robot', menu: ['tft-cvd'] }
          },
          {
            path: '/tft/pho',
            name: 'tft-pho',
            meta: { title: '曝光', icon: 'robot', menu: ['tft-pho'] }
          }
        ]
      },

      // account
      {
        path: '/account',
        component: RouteView,
        redirect: '/account/center',
        hidden: true,
        name: 'account',
        meta: { title: '个人页', icon: 'user', keepAlive: true },
        children: [
          {
            path: 'center',
            name: 'center',
            component: () => import('@/views/account/center/Index'),
            meta: { title: '个人中心', keepAlive: true }
          },
          {
            path: '/account/settings',
            name: 'settings',
            component: () => import('@/views/account/settings/Index'),
            meta: { title: '个人设置', hideHeader: true },
            redirect: '/account/settings/base',
            hideChildrenInMenu: true,
            children: [
              {
                path: '/account/settings/base',
                name: 'BaseSettings',
                component: () => import('@/views/account/settings/BaseSetting'),
                meta: { title: '基本设置', hidden: true }
              },
              {
                path: '/account/settings/security',
                name: 'SecuritySettings',
                component: () => import('@/views/account/settings/Security'),
                meta: { title: '安全设置', hidden: true, keepAlive: true }
              },
              {
                path: '/account/settings/custom',
                name: 'CustomSettings',
                component: () => import('@/views/account/settings/Custom'),
                meta: { title: '个性化设置', hidden: true, keepAlive: true }
              }
              // {
              //   path: '/account/settings/binding',
              //   name: 'BindingSettings',
              //   component: () => import('@/views/account/settings/Binding'),
              //   meta: { title: '账户绑定', hidden: true, keepAlive: true }
              // },
              // {
              //   path: '/account/settings/notification',
              //   name: 'NotificationSettings',
              //   component: () => import('@/views/account/settings/Notification'),
              //   meta: { title: '新消息通知', hidden: true, keepAlive: true }
              // }
            ]
          }
        ]
      }

    ]
  },
  {
    path: '*', redirect: '/error/404', hidden: true
  }
]

/**
 * 基础路由
 * @type { *[] }
 */
export const constantRouterMap = [
  {
    path: '/user',
    component: UserLayout,
    redirect: '/user/login',
    hidden: true,
    children: [
      {
        path: 'login',
        name: 'login',
        component: () => import(/* webpackChunkName: "user" */ '@/views/user/Login')
      },
      {
        path: 'register',
        name: 'register',
        component: () => import(/* webpackChunkName: "user" */ '@/views/user/Register')
      },
      {
        path: 'register-result',
        name: 'registerResult',
        component: () => import(/* webpackChunkName: "user" */ '@/views/user/RegisterResult')
      }
    ]
  },

  // {
  //   path: '/test',
  //   component: BlankLayout,
  //   redirect: '/test/home',
  //   children: [
  //     {
  //       path: 'home',
  //       name: 'TestHome',
  //       component: () => import('@/views/Home')
  //     }
  //   ]
  // },

  // {
  //   path: '/404',
  //   component: () => import(/* webpackChunkName: "fail" */ '@/views/exception/404')
  // },

  {
    path: '/error',
    component: BasicLayout,
    children: [
      {
        path: '/error/404',
        component: () => import(/* webpackChunkName: "fail" */ '@/views/exception/404')
      }
    ]
  }

]
