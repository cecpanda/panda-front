<template>
  <div class="user-wrapper">
    <div class="content-box">
      <span class="action" @click="handleSearchIcon">
        <a-icon type="search" v-if="searchIcon" style="font-size: 1.5em"></a-icon>
        <a-input-search placeholder="站内搜索" style="width: 12em;" v-else />
      </span>

      <template v-if="loginStatus()">
        <notice-icon class="action"/>
        <a-dropdown>
          <span class="action ant-dropdown-link user-dropdown-menu">
            <a-avatar class="avatar" size="large" :src="user().avatar"/>
            <!-- <span>{{ userInfo.username }}</span> -->
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
        <span class="action"><a-icon type="login" style="font-size: 1.5em"/></span>
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
      userInfo: {}
    }
  },
  computed: {
    // ...mapGetters({
    //   token: 'token',
    //   realname: 'realname'
    // })
  },
  methods: {
    ...mapActions(['Logout', 'InitLoginStatus']),
    ...mapGetters(['token', 'loginStatus', 'user']),
    handleLogout () {
      const that = this

      this.$confirm({
        title: '提示',
        content: '真的要注销登录吗 ?',
        onOk () {
          return that.Logout({}).then(() => {
            // this.$router.push({ name: 'home' })
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
    }
  },
  mounted () {
    // await this.InitLoginStatus()
    this.userInfo = this.user()
    // console.log('token: ', this.token())
    // console.log('loginstatus: ', this.loginStatus())
    // console.log('user: ', this.user())
  }
}
</script>

<style lang='stylus' scoped>

</style>
