<template>
  <div class="user-wrapper">
    <div class="content-box">
      <span class="action" @click="handleSearchIcon">
        <a-icon type="search" v-if="searchIcon"></a-icon>
        <a-input-search placeholder="站内搜索" style="width: 12em;" v-else />
      </span>

      <template v-if="isLogin">
        <notice-icon class="action"/>
        <a-dropdown>
          <span class="action ant-dropdown-link user-dropdown-menu">
            <a-avatar class="avatar" size="large" :src="avatar()"/>
            <span>{{ nickname() }}</span>
          </span>
          <a-menu slot="overlay" class="user-dropdown-menu-wrapper">
            <a-menu-item key="0">
              <router-link :to="{ name: 'center' }">
                <a-icon type="user"/>
                <span>个人中心</span>
              </router-link>
            </a-menu-item>
            <a-menu-item key="1">
              <router-link :to="{ name: 'settings' }">
                <a-icon type="setting"/>
                <span>账户设置</span>
              </router-link>
            </a-menu-item>
            <a-menu-divider/>
            <a-menu-item key="3">
              <a href="javascript:;" @click="handleLogout">
                <a-icon type="logout"/>
                <span>退出登录</span>
              </a>
            </a-menu-item>
          </a-menu>
        </a-dropdown>
      </template>

      <a href="/user/login" v-else>
        <span class="action"><a-icon type="login" /></span>
      </a>

    </div>
  </div>
</template>

<script>
import NoticeIcon from '@/components/NoticeIcon'
import { mapActions, mapGetters } from 'vuex'

export default {
  name: 'UserMenu',
  components: {
    NoticeIcon
  },
  data () {
    return {
      searchIcon: true,
      isLogin: false
    }
  },
  computed: {
    // ...mapGetters({
    //   token: 'token',
    //   realname: 'realname'
    // })
  },
  methods: {
    ...mapActions(['Logout', 'GetInfo2']),
    ...mapGetters(['nickname', 'avatar', 'username', 'realname', 'token']),
    handleLogout () {
      const that = this

      this.$confirm({
        title: '提示',
        content: '真的要注销登录吗 ?',
        onOk () {
          return that.Logout({}).then(() => {
            window.location.reload()
          }).catch(err => {
            that.$message.error({
              title: '错误',
              description: err.message
            })
          })
        },
        onCancel () {
        }
      })
    },
    handleSearchIcon () {
      this.searchIcon = !this.searchIcon
    },
    handleIsLogin () {
      const token = this.token()
      const username = this.username()
      if (token && username) {
        this.isLogin = true
      } else {
        this.isLogin = false
      }
    }
  },
  async created () {
    await this.GetInfo2()
    await this.handleIsLogin()
  }
}
</script>

<style lang='stylus' scoped>

</style>
