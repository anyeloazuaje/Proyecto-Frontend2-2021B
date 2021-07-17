<template>
  <v-row justify="center">
    <v-dialog v-model="mostrarModal" persistent max-width="600px">
      <v-card>
        <v-card-title>
          <span class="text-h5">Cambiar Clave</span>
        </v-card-title>
        <v-card-text>
          <v-container>
            <v-form ref="form">
              <v-row>
                <v-col cols="12">
                  <v-text-field
                    label="Clave"
                    required
                    :type="botonClave.type"
                    append-icon="mdi-lock"
                    v-model.trim="nuevaClave.clave"
                    hint="Minimo de 6 carácteres."
                    :rules="reglas"
                  ></v-text-field>
                </v-col>
                <v-col cols="12">
                  <v-text-field
                    label="Confirmar clave"
                    hint="La contraseña debe ser iguales"
                    append-icon="mdi-lock"
                    required
                    :type="botonClave.type"
                    v-model.trim="nuevaClave.confirmar"
                    :rules="reglas"
                  ></v-text-field>
                </v-col>
              </v-row>
            </v-form>
          </v-container>
          <small class="primary--text"
            >La cláve debe tener minimo 6 carácteres.</small
          >
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn
            :loading="deshabilitado"
            @click="cerrarModal"
            title="Cerrar"
            class="mx-2"
            dark
            color="error"
          >
            <v-icon>mdi-close-circle</v-icon>
          </v-btn>
          <v-btn
            :title="botonClave.type === 'text' ? 'Ocultar clave' : 'Ver clave'"
            :loading="deshabilitado"
            @click="toggleClave"
            class="mx-2"
            dark
            color="teal"
          >
            <v-icon>{{ botonClave.icono }} </v-icon>
          </v-btn>
          <v-btn
            title="Cambiar Clave"
            :loading="deshabilitado"
            @click="ejecutarModal"
            class="mx-2"
            dark
            color="primary"
          >
            <v-icon>mdi-account-key-outline</v-icon>
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-row>
</template>
<script>
import Swal from "sweetalert2";
export default {
  name: "ModalCambiarClave",
  data() {
    return {
      deshabilitado: false,
      nuevaClave: {
        clave: "",
        confirmar: "",
      },
      botonClave: {
        type: "password",
        icono: "mdi-eye",
      },
      reglas: [
        (value) => !!value || "El campo es obligatorio.",
        (value) =>
          value.length >= 6 || "La clave debe ser minimo 6 carácteres.",
      ],
    };
  },
  props: {
    mostrarModal: {
      type: Boolean,
    },
    clienteID: {
      type: Number,
    },
    usuarioID: {
      type: Number,
    },
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
    cerrarModal() {
      this.$emit("cerrar");
      this.limpiarModal();
    },
    toggleClave() {
      if (this.botonClave.type === "password") {
        this.botonClave.type = "text";
        this.botonClave.icono = "mdi-eye";
      } else {
        this.botonClave.type = "password";
        this.botonClave.icono = "mdi-eye-off";
      }
    },
    validarClave() {
      if (!this.nuevaClave.clave.length || !this.nuevaClave.confirmar.length) {
        this.mostrarAlerta("error", "Las cláves son requeridas.");
        this.$refs.form.validate();
        return false;
      }
      if (
        this.nuevaClave.clave.length < 6 ||
        this.nuevaClave.confirmar.length < 6
      ) {
        this.mostrarAlerta(
          "error",
          "La cláve debe de tener una longitud minima de 6 carácteres."
        );
        this.$refs.form.validate();
        return false;
      }
      if (this.nuevaClave.clave !== this.nuevaClave.confirmar) {
        this.mostrarAlerta("error", "Las cláves deben ser iguales.");
        this.$refs.form.validate();
        return false;
      }
      return true;
    },
    async cambiarClave() {
      this.deshabilitado = true;
      let endpoint = null;
      if (this.clienteID) {
        endpoint = `/actualizar-claveCliente/${this.clienteID}`;
      } else {
        endpoint = `/actualizar-claveUsuario/${this.usuarioID}`;
      }
      try {
        const { data } = await this.axios.put(endpoint, this.nuevaClave);
        this.mostrarAlerta("success", data.msg);
        this.$emit("cerrar");
        this.limpiarModal();
        this.deshabilitado = false;
      } catch (error) {
        this.deshabilitado = false;
        this.mostrarAlerta("error", error.response.data.msg);
      }
    },
    limpiarModal() {
      this.$refs.form.resetValidation();
      this.nuevaClave = {
        clave: "",
        confirmar: "",
      };
    },
    ejecutarModal() {
      const validacionClave = this.validarClave();
      if (validacionClave) {
        this.cambiarClave();
      }
    },
  },
};
</script>