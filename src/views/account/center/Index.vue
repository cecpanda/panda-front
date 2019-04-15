<template>
  <div class="page-header-index-wide page-header-wrapper-grid-content-main">
    <a-row :gutter="24">
      <a-col :md="24" :lg="7">
        <a-card :bordered="false">
          <div class="account-center-avatarHolder">
            <div class="avatar">
              <img :src="userInfo.avatar">
            </div>
            <div class="username">{{ userInfo.username }}</div>
            <div class="bio">{{ userInfo.brief }}</div>
          </div>
          <div class="account-center-detail">
            <p>
              <i class="job"></i>{{ userInfo.job }}
            </p>
            <p>
              <i class="room"></i>华东科技-{{ userInfo.department }}-{{ userInfo.room }}
            </p>
            <!-- <p>
              <i class="address"></i>
              <span>浙江省</span>
              <span>杭州市</span>
            </p> -->
          </div>
          <a-divider/>

          <a-divider :dashed="true"/>

          <div class="account-center-team">
            <div class="teamTitle">团队</div>
            <!-- <a-spin :spinning="teamSpinning">
              <div class="members">
                <a-row>
                  <a-col :span="12" v-for="(item, index) in userInfo.groups" :key="index">
                    <a>
                      <a-avatar size="small" :src="item.avatar"/>
                      <span class="member">{{ item }}</span>
                    </a>
                  </a-col>
                </a-row>
              </div>
            </a-spin> -->
            <div class="members">
              <a-row>
                <a-col :span="12" v-for="(item, index) in userInfo.groups" :key="index">
                  <a>
                    <!-- <a-avatar size="small" :src="item.avatar"/> -->
                    <a-icon type="usergroup-add" />
                    <span class="member">{{ item }}</span>
                  </a>
                </a-col>
              </a-row>
            </div>
          </div>
        </a-card>
      </a-col>
      <a-col :md="24" :lg="17">
        <!-- <a-card
          style="width:100%"
          :bordered="false"
          :tabList="tabListNoTitle"
          :activeTabKey="noTitleKey"
          @tabChange="key => handleTabChange(key, 'noTitleKey')"
        >
          <article-page v-if="noTitleKey === 'article'"></article-page>
          <app-page v-else-if="noTitleKey === 'app'"></app-page>
          <project-page v-else-if="noTitleKey === 'project'"></project-page>
        </a-card> -->
      </a-col>
    </a-row>
  </div>
</template>

<script>
import { PageView, RouteView } from '@/layouts'
import { AppPage, ArticlePage, ProjectPage } from './page'
import { mapGetters } from 'vuex'
import { getUser } from '@/api/user'

export default {
  components: {
    RouteView,
    PageView,
    AppPage,
    ArticlePage,
    ProjectPage
  },
  data () {
    return {
      userInfo: {},
      teamSpinning: true,

      tabListNoTitle: [
        {
          key: 'article',
          tab: '文章(8)'
        },
        {
          key: 'app',
          tab: '应用(8)'
        },
        {
          key: 'project',
          tab: '项目(8)'
        }
      ],
      noTitleKey: 'app'
    }
  },
  mounted () {
    const username = this.user().username
    getUser(username)
      .then(res => {
        this.userInfo = res
      })
  },
  methods: {
    ...mapGetters(['user']),
    handleTabChange (key, type) {
      this[type] = key
    }
  }
}
</script>

<style lang="less" scoped>
.page-header-wrapper-grid-content-main {
  width: 100%;
  height: 100%;
  min-height: 100%;
  transition: 0.3s;

  .account-center-avatarHolder {
    text-align: center;
    margin-bottom: 24px;

    & > .avatar {
      margin: 0 auto;
      width: 104px;
      height: 104px;
      margin-bottom: 20px;
      border-radius: 50%;
      overflow: hidden;
      img {
        height: 100%;
        width: 100%;
      }
    }

    .username {
      color: rgba(0, 0, 0, 0.85);
      font-size: 20px;
      line-height: 28px;
      font-weight: 500;
      margin-bottom: 4px;
    }
  }

  .account-center-detail {
    p {
      margin-bottom: 8px;
      padding-left: 26px;
      position: relative;
    }

    i {
      position: absolute;
      height: 14px;
      width: 14px;
      left: 0;
      top: 4px;
      background: url(https://gw.alipayobjects.com/zos/rmsportal/pBjWzVAHnOOtAUvZmZfy.svg);
    }

    .job {
      background-position: 0 0;
    }
    .room {
      background-position: 0 -22px;
    }
    .address {
      background-position: 0 -44px;
    }
  }

  .account-center-tags {
    .ant-tag {
      margin-bottom: 8px;
    }
  }

  .account-center-team {
    .members {
      a {
        display: block;
        margin: 12px 0;
        line-height: 24px;
        height: 24px;
        .member {
          font-size: 14px;
          color: rgba(0, 0, 0, 0.65);
          line-height: 24px;
          max-width: 100px;
          vertical-align: top;
          margin-left: 12px;
          transition: all 0.3s;
          display: inline-block;
        }
        &:hover {
          span {
            color: #1890ff;
          }
        }
      }
    }
  }

  .tagsTitle,
  .teamTitle {
    font-weight: 500;
    color: rgba(0, 0, 0, 0.85);
    margin-bottom: 12px;
  }
}
</style>
