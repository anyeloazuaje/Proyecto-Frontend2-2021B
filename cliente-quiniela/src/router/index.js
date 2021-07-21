import Vue from 'vue';
import VueRouter from 'vue-router';
import Home from '@/views/Home.vue';
import Registro from '@/views/Registro.vue';
import Noticias from '@/views/Noticias.vue';
import Noticia from '@/views/Noticia.vue';
import Login from '@/views/Login.vue';
import Equipos from '@/views/Equipos.vue';
import Contacto from '@/views/Contacto.vue';
import Seguimientos from '@/views/Seguimientos.vue';
import SolicitudRecarga from '@/views/SolicitudRecarga.vue';
import Apuestas from '@/views/Apuestas.vue';
import ApuestasDelCliente from '@/views/ApuestasDelCliente.vue';
import {
  necesitaAutenticacion,
  noNecesitaAutenticacion,
} from '@/utils/proteccionRutas';

Vue.use(VueRouter);
const pushPrototype = VueRouter.prototype.push;
VueRouter.prototype.push = function push(location) {
  return pushPrototype.call(this, location).catch((e) => e);
};

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home,
    meta: {
      title: 'El mejor centro de apuestas | La Quiniela',
    },
  },
  {
    path: '/registro',
    name: 'Registro',
    component: Registro,
    beforeEnter: noNecesitaAutenticacion,
    meta: {
      title: 'Registrate & comienza a disfrutar | La Quiniela',
    },
  },
  {
    path: '/iniciar-sesion',
    name: 'Login',
    component: Login,
    beforeEnter: noNecesitaAutenticacion,
    meta: {
      title: 'Iniciar Sesión | La Quiniela',
    },
  },
  {
    path: '/noticias',
    name: 'Noticias',
    component: Noticias,
    meta: {
      title: 'Noticias Recientes | La Quiniela',
    },
  },
  {
    path: '/noticia/:noticiaID',
    name: 'Noticia',
    component: Noticia,
    meta: {
      title: 'Detalles de la noticia  | La Quiniela',
    },
  },
  {
    path: '/equipos',
    name: 'Equipos',
    component: Equipos,
    meta: {
      title: 'Equipos registrados  | La Quiniela',
    },
  },
  {
    path: '/contacto',
    name: 'Contacto',
    component: Contacto,
    meta: {
      title: 'Contáctanos  | La Quiniela',
    },
  },
  {
    path: '/seguimientos',
    name: 'Seguimientos',
    component: Seguimientos,
    beforeEnter: necesitaAutenticacion,
    meta: {
      title: 'Seguimiento del cliente  | La Quiniela',
    },
  },
  {
    path: '/solicitud-recarga',
    name: 'SolicitudRecarga',
    component: SolicitudRecarga,
    beforeEnter: necesitaAutenticacion,
    meta: {
      title: 'Apuestas que has realizado  | La Quiniela',
    },
  },
  {
    path: '/apuesta-cliente',
    name: 'ApuestaCliente',
    component: ApuestasDelCliente,
    beforeEnter: necesitaAutenticacion,
    meta: {
      title: 'Solicitud de recarga para apuestas  | La Quiniela',
    },
  },
  {
    path: '/apuestas',
    name: 'Apuestas',
    component: Apuestas,
    meta: {
      title: 'Apuestas registradas  | La Quiniela',
    },
  },
  {
    path: '*',
    redirect: '/registro',
  },
];

const router = new VueRouter({
  routes,
});
const defaultTitle = 'Centro de apuestas | La Quiniela';
router.afterEach((to) => {
  Vue.nextTick(() => {
    document.title = to.meta.title || defaultTitle;
  });
});

export default router;

