import Vue from 'vue'
import Router from 'vue-router'
import Treasure from '@/components/Treasure'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'home',
      component: Treasure
    }
  ]
})
