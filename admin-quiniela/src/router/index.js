import Vue from 'vue';
import VueRouter from 'vue-router';
import Home from '@/views/Home.vue';
import Login from '@/views/Login.vue';
import Autor from '@/views/Autor.vue';
import Categoria from '@/views/Categoria.vue';
import Noticias from '@/views/Noticias.vue';
import NoticiaCrear from '@/views/NoticiaCrear.vue';
import NoticiaEditar from '@/views/NoticiaEditar.vue';
import Equipos from '@/views/Equipos.vue';
import Contacto from '@/views/Contacto.vue';
import Seguimientos from '@/views/Seguimientos.vue';
import Apuestas from '@/views/Apuestas.vue';
import ApuestaCliente from '@/views/ApuestaCliente.vue';
import DefinirApuesta from '@/views/DefinirApuesta.vue';
import Recargas from '@/views/Recargas.vue';
import Usuarios from '@/views/Usuarios.vue';
import {
  NoRequiereAutenticacion,
  requiereAutenticacion,
  requiereAutenticacionAdmin
} from '@/utils/autenticacionRutas';

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
    beforeEnter: requiereAutenticacion,
    meta: {
      title: 'La Quiniela | Clientes Registrados',
    },
  },
  {
    path: '/login',
    name: 'Login',
    component: Login,
    beforeEnter: NoRequiereAutenticacion,
    meta: {
      title: 'La Quiniela | Login Administrativo',
    },
  },
  {
    path: '/autor',
    name: 'Autor',
    component: Autor,
    beforeEnter: requiereAutenticacionAdmin,
    meta: {
      title: 'La Quiniela | Autores Registrados',
    },
  },
  {
    path: '/categoria',
    name: 'Categoria',
    component: Categoria,
    beforeEnter: requiereAutenticacionAdmin,
    meta: {
      title: 'La Quiniela | Categorias Registradas',
    },
  },
  {
    path: '/noticia',
    name: 'Noticias',
    component: Noticias,
    beforeEnter: requiereAutenticacion,
    meta: {
      title: 'La Quiniela | Noticas Recientes',
    },
  },
  {
    path: '/crear-noticia',
    name: 'CrearNoticia',
    component: NoticiaCrear,
    beforeEnter: requiereAutenticacionAdmin,
    meta: {
      title: 'La Quiniela | Crear Noticia',
    },
  },
  {
    path: '/editar-noticia/:noticiaID',
    name: 'NoticiaEditar',
    component: NoticiaEditar,
    beforeEnter: requiereAutenticacionAdmin,
    meta: {
      title: 'La Quiniela | Actualizar Noticia',
    },
  },
  {
    path: '/equipo',
    name: 'Equipos',
    component: Equipos,
    beforeEnter: requiereAutenticacion,
    meta: {
      title: 'La Quiniela | Equipos Registrados',
    },
  },
  {
    path: '/contacto',
    name: 'Contacto',
    component: Contacto,
    beforeEnter: requiereAutenticacion,
    meta: {
      title: 'La Quiniela | Mensajes De Contacto',
    },
  },
  {
    path: '/seguimiento',
    name: 'Seguimientos',
    component: Seguimientos,
    beforeEnter: requiereAutenticacion,
    meta: {
      title: 'La Quiniela | Seguimientos Del Cliente',
    },
  },
  {
    path: '/apuesta',
    name: 'Apuestas',
    component: Apuestas,
    beforeEnter: requiereAutenticacion,
    meta: {
      title: 'La Quiniela | Apuestas Registradas',
    },
  },
  {
    path: '/apuesta-cliente',
    name: 'ApuestasCliente',
    component: ApuestaCliente,
    beforeEnter: requiereAutenticacion,
    meta: {
      title: 'La Quiniela | Apuestas Del Cliente',
    },
  },
  {
    path: '/definir-apuesta/:apuestaID',
    name: 'DefinirApuesta',
    component: DefinirApuesta,
    beforeEnter: requiereAutenticacionAdmin,
    meta: {
      title: 'La Quiniela | Definir Apuesta Del Cliente',
    },
  },
  {
    path: '/solicitud-recargas',
    name: 'Recargas',
    component: Recargas,
    beforeEnter: requiereAutenticacionAdmin,
    meta: {
      title: 'La Quiniela | Solicitudes De Recarga',
    },
  },
  {
    path: '/usuarios',
    name: 'Usuarios',
    component: Usuarios,
    beforeEnter: requiereAutenticacionAdmin,
    meta: {
      title: 'La Quiniela | Usuarios Administradores',
    },
  },
  {
    path: '*',
    redirect: '/',
  },
];

const router = new VueRouter({
  routes,
});

const defaultTitle = 'La Quiniela | Administración';
router.afterEach((to) => {
  Vue.nextTick(() => {
    document.title = to.meta.title || defaultTitle;
  });
});

export default router;
