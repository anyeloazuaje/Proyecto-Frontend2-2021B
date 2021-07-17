<template>
  <section>
    <!-- SEPARAR EN COMPONETE -->
    <mdb-card class="card-image background">
      <div class="text-white text-center py-5 px-4 my-5">
        <div>
          <h2 class="card-title h1-responsive pt-3 mb-5 font-bold">
            <strong>EJEMPLO</strong>
          </h2>
          <p class="mx-5 mb-5">
            Lorem ipsum dolor sit amet, consectetur adipisicing elit. Itaque,
            similique?
          </p>
        </div>
      </div>
    </mdb-card>
    <mdb-container>
      <section class="form-dark">
        <mdb-row class="mt-5">
          <mdb-col>
            <mdb-card class="auto card-image hero-login">
              <div class="text-white rgba-stylish-strong py-5 px-5 z-depth-4">
                <div class="text-center">
                  <h3 class="white-text mb-5 mt-4 font-weight-bold">
                    <strong>Iniciar</strong>
                    <a class="blue-text font-weight-bold"
                      ><strong> Sesión</strong></a
                    >
                  </h3>
                </div>
                <mdb-input
                  icon="envelope"
                  v-model.trim="cliente.correo"
                  label="Escribe tu correo"
                  type="email"
                />
                <mdb-input
                  icon="lock"
                  v-model.trim="cliente.clave"
                  :type="mostrarClave ? 'text' : 'password'"
                  label="Tu Contraseña"
                />
                <mdb-btn
                  class="toggle"
                  slot="append"
                  group
                  dark-waves
                  color="primary"
                  size="sm"
                  :icon="mostrarClave ? 'eye-slash' : 'eye'"
                  :title="mostrarClave ? 'Ocultar clave' : 'Mostrar clave'"
                  @click="mostrarClave = !mostrarClave"
                />
                <mdb-row class="d-flex align-items-center mb-4">
                  <div class="text-center mb-3 col-md-12">
                    <mdb-btn
                      @click="loginCliente"
                      color="danger"
                      type="button"
                      class="btn btn-block z-depth-1"
                      title="Iniciar Sesión"
                      :disabled="deshabilitado"
                      :icon="deshabilitado ? 'circle-notch' : 'user-lock'"
                      :icon-class="deshabilitado ? 'fa-spin' : ''"
                      >Ingresar</mdb-btn
                    >
                  </div>
                </mdb-row>
                <mdb-col md="12">
                  <p class="font-small white-text d-flex justify-content-end">
                    ¿No tienes cuenta?
                    <a
                      @click="$router.push('/registro')"
                      class="color ml-1 font-weight-bold"
                      >Registrate aqui <i class="fas fa-user-plus"></i
                    ></a>
                  </p>
                </mdb-col>
              </div>
            </mdb-card>
          </mdb-col>
        </mdb-row>
      </section>
    </mdb-container>
  </section>
</template>
<script>
import Swal from "sweetalert2";
import {
  mdbRow,
  mdbContainer,
  mdbCol,
  mdbCard,
  mdbCardBody,
  mdbInput,
  mdbBtn,
  mdbIcon,
} from "mdbvue";
import HeroRegistro from "@/components/HeroRegistro";
import { regEmail } from "@/utils/constante";
import { SET_DATOS_CLIENTE } from "@/store/types";
export default {
  name: "Login",
  components: {
    mdbRow,
    mdbCol,
    mdbContainer,
    mdbCard,
    mdbCardBody,
    mdbInput,
    mdbBtn,
    mdbIcon,
    HeroRegistro,
  },
  data() {
    return {
      mostrarClave: false,
      cliente: {
        correo: "",
        clave: "",
      },
      deshabilitado: false,
    };
  },
  methods: {
    mostrarMensaje(tipoIcono, mensaje) {
      const Toast = Swal.mixin({
        toast: true,
        position: "top-end",
        showConfirmButton: false,
        timer: 3000,
        timerProgressBar: true,
        didOpen: (toast) => {
          toast.addEventListener("mouseenter", Swal.stopTimer);
          toast.addEventListener("mouseleave", Swal.resumeTimer);
        },
      });
      Toast.fire({
        icon: tipoIcono,
        title: mensaje,
      });
    },
    validarEmail(email) {
      return regEmail.test(String(email).toLowerCase());
    },
    async loginCliente() {
      if (
        !this.cliente.correo ||
        !this.cliente.clave ||
        !this.cliente.clave.length ||
        !this.cliente.correo.length
      ) {
        return this.mostrarMensaje(
          "error",
          "Todos los datos son necesarios para iniciar sesión."
        );
      }
      if (!this.validarEmail(this.cliente.correo)) {
        return this.mostrarMensaje("error", "El correo no es valido.");
      }
      try {
        this.deshabilitado = true;
        const { data } = await this.axios.post(
          "/cliente/login-cliente",
          this.cliente
        );
        this.mostrarMensaje(
          "success",
          `Iniciado sesión correctamente ${this.cliente.correo}`
        );
        this.cliente = {
          correo: "",
          clave: "",
        };
        this.$router.push("/");
        this.deshabilitado = false;
        this.$store.dispatch(SET_DATOS_CLIENTE, data);
      } catch (error) {
        this.deshabilitado = false;
        this.mostrarMensaje("error", error.response.data.msg);
      }
    },
  },
};
</script>
<style scoped>
.toggle {
  right: 5em;
  position: absolute;
  top: 22em;
}
@media screen and (max-width: 700px) {
  .toggle {
    right: 5em;
    position: absolute;
    top: 21em;
  }
}
.background {
  background-image: url(../assets/img/hero-login.jpg);
  background-size: cover;
  background-color: #3f51b5;
  background-attachment: fixed;
  background-repeat: no-repeat;
}
.color {
  color: #00bcd4 !important;
}
</style>
<style>
.form-dark input {
  color: white !important;
}
.form-dark .font-small {
  font-size: 0.8rem;
}

.form-dark .md-form label {
  color: #fff;
}

.form-dark input[type="email"]:focus:not([readonly]) {
  border-bottom: 1px solid #d43939;
  -webkit-box-shadow: 0 1px 0 0 #d43939;
  box-shadow: 0 1px 0 0 #d43939;
}

.form-dark input[type="email"]:focus:not([readonly]) + label {
  color: #fff;
}

.form-dark input[type="password"]:focus:not([readonly]) {
  border-bottom: 1px solid #d43939;
  -webkit-box-shadow: 0 1px 0 0 #d43939;
  box-shadow: 0 1px 0 0 #d43939;
}

.form-dark input[type="password"]:focus:not([readonly]) + label {
  color: #fff;
}

.hero-login {
  background: url(../assets/img/login-hero.jpg);
  background-position: center;
  max-width: 56em;
}
.auto {
  margin: 0 auto;
}
</style>