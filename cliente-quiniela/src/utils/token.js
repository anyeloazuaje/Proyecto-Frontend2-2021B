export const obtenerDatosToken  = (token)=> {
    const payload = token ? token.split('.')[1] : null;
    return payload ? JSON.parse(atob(payload)) : {};
  }
  