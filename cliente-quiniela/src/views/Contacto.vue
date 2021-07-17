<template>
  <section>
    <HeroContacto />
    <mdb-container>
      <section class="my-5">
        <h2 class="h1-responsive font-weight-bold text-center my-5 titulo">
          Contáctanos
        </h2>
        <p class="text-center w-responsive mx-auto pb-5">
          Lorem ipsum dolor sit amet, consectetur adipisicing elit. Fugit, error
          amet numquam iure provident voluptate esse quasi, veritatis totam
          voluptas nostrum quisquam eum porro a pariatur veniam.
        </p>
        <mdb-row>
          <mdb-col lg="7">
            <div
              id="map-container"
              class="rounded z-depth-1-half map-container"
              style="height: 400px"
            >
              <iframe
                src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3937.177217500111!2d-70.59904891619317!3d9.317560486338465!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x8e632840ba4ddd6b%3A0x8d522158b1ad26!2sValera%20-%20Carvajal%2C%20Valera%2C%20Trujillo!5e0!3m2!1ses-419!2sve!4v1626118782803!5m2!1ses-419!2sve"
                width="100%"
                height="100%"
                frameBorder="0"
                style="border: 0"
              ></iframe>
            </div>
            <br />
            <mdb-row class="text-center mb-2">
              <mdb-col md="4">
                <mdb-btn class="white-text">
                  <mdb-icon icon="map-marker" />
                </mdb-btn>
                <p>Carvajal, 94126</p>
                <p class="mb-md-0">Valera</p>
              </mdb-col>
              <mdb-col md="4">
                <mdb-btn class="white-text">
                  <mdb-icon icon="phone" />
                </mdb-btn>
                <p>+ 58 412 123 2130</p>
                <p class="mb-md-0">+ 58 212 332 4431</p>
              </mdb-col>
              <mdb-col md="4">
                <mdb-btn class="white-text">
                  <mdb-icon icon="envelope" />
                </mdb-btn>
                <p>info@quiniela.com</p>
                <p class="mb-md-0">contacto@quiniela.com</p>
              </mdb-col>
            </mdb-row>
          </mdb-col>
          <mdb-col lg="5" class="lg-0 mb-4">
            <mdb-card>
              <mdb-card-body>
                <div class="form-header titulo">
                  <h3 class="mt-2">
                    <mdb-icon icon="envelope" /> Completas los datos
                  </h3>
                </div>
                <p class="dark-grey-text text-center">
                  We'll write rarely, but only the best content.
                </p>
                <div class="md-form">
                  <mdb-input
                    icon="user"
                    label="Ingresa tu Nombre"
                    iconClass="grey-text"
                    type="text"
                    v-model.trim="contacto.nombre"
                  />
                </div>
                <div class="md-form">
                  <mdb-input
                    icon="envelope"
                    label="Escribe tu Correo"
                    iconClass="grey-text"
                    type="text"
                    v-model.trim="contacto.correo"
                  />
                </div>
                <div class="md-form">
                  <mdb-textarea
                    icon="comment"
                    label="Dejanos tu Mensaje"
                    iconClass="grey-text"
                    v-model.trim="contacto.mensaje"
                  />
                </div>
                <div class="text-center">
                  <mdb-btn
                    class="btn btn-block"
                    :icon="deshabilitado ? 'circle-notch' : ''"
                    :icon-class="deshabilitado ? '' : ''"
                    title="Enviar mensade de contácto"
                    :disabled="deshabilitado"
                    @click="enviarMensaje"
                    color="danger"
                    >Enviar
                    <i v-if="!deshabilitado" class="fas fa-location-arrow"></i>
                  </mdb-btn>
                </div>
              </mdb-card-body>
            </mdb-card>
          </mdb-col>
        </mdb-row>
      </section>
    </mdb-container>
  </section>
</template>

<script>
import Swal from 'sweetalert2'
import HeroContacto from "@/components/HeroContacto";
import {
  mdbContainer,
  mdbRow,
  mdbCol,
  mdbBtn,
  mdbIcon,
  mdbInput,
  mdbTextarea,
  mdbCard,
  mdbCardBody,
} from "mdbvue";

export default {
  name: "Contacto",
  components: {
    HeroContacto,
    mdbContainer,
    mdbRow,
    mdbCol,
    mdbBtn,
    mdbIcon,
    mdbInput,
    mdbTextarea,
    mdbCard,
    mdbCardBody,
  },
  data() {
    return {
      deshabilitado: false,
      contacto: {
        nombre: "",
        correo: "",
        mensaje: "",
      },
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
    async enviarMensaje() {
      if (
        !this.contacto.nombre ||
        !this.contacto.mensaje ||
        !this.contacto.correo ||
        !this.contacto.nombre.length ||
        !this.contacto.mensaje.length ||
        !this.contacto.correo.length
      ) {
        return this.mostrarMensaje(
          "error",
          "Todos los campos son obligatorios para enviar el mensaje de contácto."
        );
      }
      try {
        this.deshabilitado = true;
        const { data } = await this.axios.post(
          "/crear-contacto",
          this.contacto
        );
        this.mostrarMensaje("success", data.msg);
        this.contacto = {
          nombre: "",
          correo: "",
          mensaje: "",
        };
        this.deshabilitado = false;
      } catch (error) {
        this.deshabilitado = false;
        this.mostrarMensaje("success", data.msg);
      }
    },
  },
};
</script>


<style>
</style>