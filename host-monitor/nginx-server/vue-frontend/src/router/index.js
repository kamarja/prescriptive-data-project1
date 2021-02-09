import Vue from 'vue';
import Router from 'vue-router';
import Ping from '@/components/Ping';
import Hosts from '@/components/Hosts';

Vue.use(Router);

export default new Router({
  routes: [
    {
      path: '/',
      name: 'Hosts',
      component: Hosts,
    },
    {
      path: '/ping',
      name: 'Ping',
      component: Ping,
    },
  ],
  mode: 'hash',
});
