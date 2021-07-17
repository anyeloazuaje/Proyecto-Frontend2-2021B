<template>
  <v-app>
    <v-container class="mt-5">
      <div v-if="loading">
        <Spinner />
      </div>
      <template v-else>
        <template v-if="contactos.length">
          <v-simple-table>
            <template v-slot:default>
              <thead>
                <tr class="info darken-3 text-center text-uppercase">
                  <th class="white--text text-left">Nombre</th>
                  <th class="white--text text-left">Correo</th>
                  <th class="white--text text-left">Mensaje</th>
                  <th class="white--text text-left">Fecha</th>
                  <template v-if="esAdmin">
                  <th class="white--text text-left">Acción</th>
                  </template>
                </tr>
              </thead>
              <tbody>
                <tr v-for="contacto in contactos" :key="contacto.id">
                  <td>{{ contacto.nombre }}</td>
                  <td>{{ contacto.correo }}</td>
                  <td>{{ contacto.mensaje.substring(0,90) }}...</td>
                  <td>{{ fechaYHoraConFormato(contacto.fecha) }}</td>
                  <template v-if="esAdmin">
                  <td>
                    <v-btn
                      :loading="deshabilitado"
                      medium
                      color="error"
                      title="Eliminar contacto"
                      @click="eliminarContacto(contacto)"
                    >
                      <v-icon dark >
                        mdi-email-off</v-icon
                      >
                    </v-btn>
                  </td>
                  </template>
                </tr>
              </tbody>
            </template>
          </v-simple-table>
        </template>
        <template v-else>
          <h3 class="text--darken-3 text-center">
            No existen mensajes de contactos.
            <v-icon color="teal"> mdi-message-processing-outline </v-icon>
          </h3>
        </template>
      </template>
    </v-container>
  </v-app>
</template>

<script>
import Swal from "sweetalert2";
import Spinner from "@/components/Spinner.vue";
export default {
  name: "Contacto",
  components: {
    Spinner,
  },
  data() {
    return {
      loading: false,
      deshabilitado: false,
      contactos: [],
    };
  },
  created() {
    this.obtenerMensajesContacto();
  },
  computed:{
      esAdmin() {
      return this.$store.getters.esAdmin;
  },
  },
  methods: {
    async obtenerMensajesContacto() {
      try {
        this.loading = true;
        const { data } = await this.axios.get("/obtener-contactos");
        this.contactos = data;
        this.loading = false;
      } catch (error) {
        this.loading = false;
        this.mostrarAlerta("error", error.response.data.msg);
      }
    },
    fechaYHoraConFormato(fecha) {
      const fechaFormato = new Date(fecha);
      return fechaFormato.toLocaleString();
    },
    async eliminarContacto(noticiaEliminar) {
      Swal.fire({
        title: "Eliminar noticia",
        text: `¿Estas seguro en eliminar la noticia ${noticiaEliminar.nombre}.`,
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#f14545",
        cancelButtonColor: "#009688",
        cancelButtonText: "No, cerrar",
        confirmButtonText: "Si, Eliminar",
      })
        .then(async (result) => {
          if (result.isConfirmed) {
            this.deshabilitado = true;
            const { data } = await this.axios.delete(
              `/eliminar-contacto/${noticiaEliminar.id}`
            );
            this.mostrarAlerta("success", data.msg);
            this.contactos = this.contactos.filter(
              (contacto) => contacto.id !== noticiaEliminar.id
            );
            this.deshabilitado = false;
          }
        })
        .catch((error) => {
          this.deshabilitado = false;
          this.mostrarAlerta("error", error.response.data.msg);
        });
    },
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
  },
};
</script>

<style scoped>
@media only screen and (max-width: 580px) {
  .ocultar-noticia{
    display: none;
  }
  table,
  thead,
  tbody,
  th,
  td,
  tr {
    display: block;
  }

  thead tr {
    position: absolute;
    top: -9999px;
    left: -9999px;
  }

  tr {
    margin: 0 0 1rem 0;
    margin-top: 2em;
  }

  tr:nth-child(odd) {
    background: #d4d4d4;
  }

  td {
    border: none;
    border-bottom: 1px solid #ddd;
    position: relative;
    margin-left: 5em;
  }

  td:before {
    position: absolute;
    top: 0;
    left: -65px;
    white-space: nowrap;
    font-weight: bold;
  }

  td:nth-of-type(1):before {
    content: "Nombre";
  }
  td:nth-of-type(2):before {
    content: "Correo";
  }
  td:nth-of-type(3):before {
    content: "Mensaje";
  }
  td:nth-of-type(4):before {
    content: "Fecha";
  }
 
  td:nth-of-type(5):before {
    content: "Acción";
  }
}
</style>