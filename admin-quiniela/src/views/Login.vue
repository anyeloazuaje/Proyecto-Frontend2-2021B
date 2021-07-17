<template>
  <v-app>
    <div class="v-main__wrap">
      <v-container class="fill-height" fluid>
        <v-row align="center" justify="center">
          <v-col cols="12" sm="8" md="8">
            <v-card class="elevation-12">
              <v-row>
                <v-col cols="12" md="12">
                  <v-card-text class="mt-12">
                    <h1
                      class="text-center display-2 teal--text text--primary-3"
                    >
                      Iniciar sesión
                    </h1>
                    <h4 class="text-center mt-4">
                      Ingresa al panel administrativo
                    </h4>
                    <v-form @submit.prevent="submitForm" ref="form">
                      <v-text-field
                        label="Usuario"
                        prepend-icon="mdi-shield-account"
                        type="text"
                        v-model.trim="login.usuario"
                        :rules="rules"
                        color="teal accent-3"
                      />

                      <v-text-field
                        label="Contraseña"
                        prepend-icon="mdi-lock"
                        type="password"
                        v-model="login.clave"
                        :rules="rules"
                        color="teal accent-3"
                      />
                      <div v-if="error.length">
                        <p class="red--text text-center">
                          {{ error }}
                        </p>
                      </div>
                      <div class="text-center mt-3">
                        <v-btn
                          :loading="deshabilitado"
                          type="submit"
                          rounded
                          color="primary accent-3"
                          dark
                          >Iniciar Sesión <v-icon>mdi-account-lock</v-icon></v-btn
                        >
                      </div>
                    </v-form>
                  </v-card-text>
                </v-col>
              </v-row>
            </v-card>
          </v-col>
        </v-row>
      </v-container>
    </div>
  </v-app>
</template>

<script>
import Swal from "sweetalert2";
export default {
  name: "Login",
  data() {
    return {
      login: {
        usuario: "",
        clave: "",
      },
      error: "",
      deshabilitado: false,
      rules: [(value) => !!value || "El campo es obligatorio."],
    };
  },
  methods: {
    mostrarAlerta(tipoIcono, mensaje) {
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
    async submitForm() {
      this.deshabilitado = true;
      this.error = "";
      if (!this.login.usuario || !this.login.clave) {
        this.$refs.form.validate();
        this.deshabilitado = false;
        return (this.error = "Todos los datos son necesarios.");
      }
      try {
        const { data: token } = await this.axios.post(
          "/login-usuario",
          this.login
        );
        this.deshabilitado = false;
        this.mostrarAlerta("success", "Has iniciado sesión correctamente.");
        this.$store.dispatch("establecerDatos", token);
        this.$router.push("/");
      } catch (error) {
        this.$refs.form.resetValidation();
        this.mostrarAlerta("error", error.response.data.msg);
        this.deshabilitado = false;
        this.form = {
          usuario: "",
          clave: "",
        };
      }
    },
  },
};
</script>

<style scoped>
.v-main__wrap {
  background: #43cea2;
  background: -webkit-linear-gradient(to right, #185a9d, #43cea2);
  background: linear-gradient(to right, #185a9d, #43cea2);
}
</style>