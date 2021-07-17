import { AUTENTICACION_TOKEN_CLIENTE } from './constante';
export const necesitaAutenticacion = (to, from, next) => {
  if (typeof localStorage !== 'undefined') {
    return localStorage.getItem(AUTENTICACION_TOKEN_CLIENTE)
      ? next()
      : next(`/iniciar-sesion`);
  }
};
export const noNecesitaAutenticacion = (to, from, next) => {
  if (typeof localStorage !== 'undefined') {
    return localStorage.getItem(AUTENTICACION_TOKEN_CLIENTE)
      ? next('/')
      : next();
  }
};
