export const decodificarToken  = (token)=> {
    const payload = token ? token.split('.')[1] : null;
    return payload ? JSON.parse(atob(payload)) : {};
  }
  