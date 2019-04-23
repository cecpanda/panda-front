<template>
  <div>
    <h1>1</h1>
    <a-button type="primary" v-action:view="services.ItSysTft">view</a-button>
    <a-button type="primary" v-action:add="services.ItSysTft">add</a-button>
    <a-button type="primary" v-action:change="services.ItSysTft">change</a-button>
    <a-button type="primary" v-action:delete="services.ItSysTft">delete</a-button>
  </div>
</template>

<script>
import { services } from '@/permission'

export default {
  name: 'ItSysTft',
  data () {
    return {
      services: services
    }
  }
}
</script>

<style scoped>

</style>
