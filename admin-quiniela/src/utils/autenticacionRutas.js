import store from '@/store/index';
export const requiereAutenticacion = (to, from, next) => {
  if (typeof localStorage !== 'undefined') {
    return localStorage.getItem('autenticacion-token')
      ? next()
      : next(`/login`);
  }
};
export const NoRequiereAutenticacion = (to, from, next) => {
  if (typeof localStorage !== 'undefined') {
    return localStorage.getItem('autenticacion-token') ? next('/') : next();
  }
};
export const requiereAutenticacionAdmin = (to, from, next) => {
  if (typeof localStorage !== 'undefined') {
    const esAdmin = store.getters.esAdmin;
    if (!esAdmin) {
      return next('/');
    }
    return next();
  }
};
