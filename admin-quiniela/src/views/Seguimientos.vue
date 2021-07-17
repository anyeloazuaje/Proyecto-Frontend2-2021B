<template>
  <v-app>
    <v-container class="mt-5">
      <div v-if="loading">
        <Spinner />
      </div>
      <template v-else>
        <template v-if="seguimientos.length">
          <v-simple-table>
            <template v-slot:default>
              <thead>
                <tr class="deep-purple text-center text-uppercase">
                  <th class="white--text text-left">Nombre Cliente</th>
                  <th class="white--text text-left">Nombre Equipó</th>
                  <th class="white--text text-left">Fecha De Seguimiento</th>
                  <template v-if="esAdmin">
                  <th class="white--text text-left">Acción</th>
                  </template>
                </tr>
              </thead>
              <tbody>
                <tr v-for="seguimiento in seguimientos" :key="seguimiento.id">
                  <td>{{ seguimiento.id_cliente }}</td>
                  <td>{{ seguimiento.id_equipo }}</td>
                  <td>{{ formatoFecha(seguimiento.fecha) }}</td>
                  <template v-if="esAdmin">
                  <td>
                    <v-btn
                      :loading="deshabilitado"
                      medium
                      title="Eliminar seguimiento"
                      @click="eliminarSeguimiento(seguimiento)"
                    >
                      <v-icon dark class="error--text"> mdi-heart-off</v-icon>
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
            No existen seguimientos de los clientes.
            <v-icon color="purple"> mdi-heart-broken </v-icon>
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
  name: "Seguimientos",
  components: {
    Spinner,
  },
  data() {
    return {
      loading: false,
      deshabilitado: false,
      seguimientos: [],
    };
  },
  created() {
    this.obtenerSeguimientos();
  },
  computed:{
      esAdmin() {
      return this.$store.getters.esAdmin;
    },
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
    formatoFecha(fecha) {
      const fechaFormato = new Date(fecha);
      return fechaFormato.toLocaleString();
    },
    async obtenerSeguimientos() {
      try {
        this.loading = true;
        const { data } = await this.axios.get("/obtener-seguimientos");
        this.seguimientos = data;
        this.loading = false;
      } catch (error) {
        this.loading = false;
        this.mostrarMensaje("error", error.response.data.msg);
      }
    },
    eliminarSeguimiento(seguimientoEliminar) {
      Swal.fire({
        title: "Eliminar seguimiento",
        text: `¿Estas seguro en eliminar el seguimiento del cliente: ${seguimientoEliminar.id_cliente}?`,
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#f14545",
        cancelButtonColor: "#009688",
        cancelButtonText: "No, cancelar",
        confirmButtonText: "Si, eliminar seguimiento",
      })
        .then(async (result) => {
          if (result.isConfirmed) {
            this.deshabilitado = true;
            const { data } = await this.axios.delete(
              `/eliminar-seguimiento/${seguimientoEliminar.id}`
            );
            this.mostrarMensaje("success", data.msg);
            this.seguimientos = this.seguimientos.filter(
              (seguimiento) => seguimiento.id !== seguimientoEliminar.id
            );
            this.deshabilitado = false;
          }
        })
        .catch((error) => {
          this.deshabilitado = false;
          this.mostrarMensaje("error", error.response.data.msg);
        });
    },
  },
};
</script>

<style>
</style>
