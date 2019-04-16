<template>
  <a-modal
    title="修改头像"
    :visible="visible"
    :maskClosable="false"
    :confirmLoading="confirmLoading"
    :width="800"
    @cancel="cancelHandel"
  >
    <a-row>
      <a-col :xs="24" :md="12" :style="{marginBottom: '15px'}">
        <a-upload
          name="file"
          accept=".png,.jpg,.jpeg"
          :showUploadList="false"
          :beforeUpload="beforeUpload"
          @change="handleChange"
        >
          <a-button>
            <a-icon type="upload" />上传
          </a-button>
        </a-upload>
      </a-col>
    </a-row>
    <a-row>
      <a-col :xs="24" :md="12" :style="{height: '350px'}">
        <vue-cropper
          ref="cropper"
          :img="options.img"
          :info="true"
          outputType="png"
          :autoCrop="options.autoCrop"
          :autoCropWidth="options.autoCropWidth"
          :autoCropHeight="options.autoCropHeight"
          :fixedBox="options.fixedBox"
          @realTime="realTime"
        >
        </vue-cropper>
      </a-col>
      <a-col :xs="24" :md="12" :style="{height: '350px'}">
        <div class="avatar-upload-preview">
          <img :src="previews.url" :style="previews.img"/>
        </div>
      </a-col>
    </a-row>

    <template slot="footer">
      <a-button key="back" @click="cancelHandel">取消</a-button>
      <a-button key="submit" type="primary" :loading="confirmLoading" @click="okHandel">保存</a-button>
    </template>
  </a-modal>
</template>

<script>
// import { VueCropper } from 'vue-cropper'
import { changeAvatar } from '@/api/user'

export default {
  /*
  components: {
    VueCropper
  },
  */
  props: {
    avatar: {
      type: String,
      default: '/avatar.jpeg'
    }
  },
  data () {
    return {
      visible: false,
      id: null,
      confirmLoading: false,

      options: {
        img: this.avatar,
        autoCrop: true,
        autoCropWidth: 200,
        autoCropHeight: 200,
        fixedBox: true
      },
      previews: {}
    }
  },
  computed: {
  },
  methods: {
    edit (id) {
      this.visible = true
      this.id = id
      /* 获取原始头像 */
    },
    close () {
      this.id = null
      this.visible = false
    },
    cancelHandel () {
      this.close()
    },
    okHandel () {
      const _this = this

      _this.$refs.cropper.getCropBlob((data) => {
        // outputType="png"
        const avatar = new File([data], 'abc.png')
        var fd = new FormData()
        fd.append('avatar', avatar)

        _this.confirmLoading = true
        setTimeout(() => {
          _this.confirmLoading = false
          changeAvatar(fd)
            .then(res => {
              _this.$message.success('上传成功')
              _this.$emit('changeAvatar', res.avatar)
              _this.close()
            })
            .catch(err => {
              _this.$message.error('上传失败: ', err)
            })
        }, 1500)
      })
    },
    realTime (data) {
      this.previews = data
    },
    beforeUpload (file) {
      return false
    },
    handleChange (info) {
      var data = window.URL.createObjectURL(info.file)
      this.options.img = data
      // var reader = new FileReader()
      // reader.readAsDataURL(info.file)
    }
  },
  watch: {
    visible (newVal, oldVal) {
      if (newVal === false) {
        this.options.img = this.avatar
      }
    }
  },
  mounted () {
  }
}
</script>

<style lang="less" scoped>

  .avatar-upload-preview {
    position: absolute;
    top: 50%;
    transform: translate(50%, -50%);
    width: 180px;
    height: 180px;
    border-radius: 50%;
    box-shadow: 0 0 4px #ccc;
    overflow: hidden;

    img {
      width: 100%;
      height: 100%;
    }
  }
</style>
