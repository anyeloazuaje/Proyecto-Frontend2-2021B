<template>
  <v-app>
    <v-container>
      <div v-if="loading">
        <Spinner />
      </div>
      <template v-else>
        <template v-if="apuestasClientes.length">
          <v-simple-table class="mt-4">
            <template v-slot:default>
              <thead>
                <tr class="cyan darken-4">
                  <th class="white--text text-left">Cliente</th>
                  <th class="white--text text-left">Apostó por</th>
                  <th class="white--text text-left">Apuesta</th>
                  <th class="white--text text-left">Fecha que apostó</th>
                  <th class="white--text text-left">Resultado</th>
                  <template v-if="esAdmin">
                  <th class="white--text text-left">Acciones</th>
                  </template>
                </tr>
              </thead>
              <tbody>
                <tr v-for="apuesta in apuestasClientes" :key="apuesta.id">
                  <td>{{ apuesta.id_cliente }}</td>
                  <td>{{ apuesta.id_equipo }}</td>
                  <td>
                    {{ apuesta.id_apuesta.equipo1 }}
                    <strong><span>VS</span> </strong>
                    {{ apuesta.id_apuesta.equipo2 }}
                  </td>
                  <td>{{ formatearFecha(apuesta.fecha) }}</td>
                  <td>
                    {{
                      apuesta.resultado
                        ? apuesta.resultado
                        : "No se ha definido el resultado."
                    }}
                  </td>
                  <template v-if="esAdmin">
                  <td>
                    <v-btn
                      :loading="deshabilitado"
                      dark
                      small
                      color="error"
                      title="Eliminar Apuesta del cliente"
                      @click="eliminarApuesta(apuesta)"
                    >
                      <v-icon dark> mdi-delete-circle-outline</v-icon>
                    </v-btn>
                    <template v-if="!apuesta.resultado">
                      <v-btn
                        :loading="deshabilitado"
                        class="margen"
                        dark
                        small
                        color="info"
                        title="Definir Resultado"
                        @click="$router.push(`/definir-apuesta/${apuesta.id}`)"
                      >
                        <v-icon dark> mdi-arrow-right-box</v-icon>
                      </v-btn>
                    </template>
                  </td>
                  </template>
                </tr>
              </tbody>
            </template>
          </v-simple-table>
        </template>
        <template v-else>
          <h3 class="text--darken-3 mt-5 text-center">
            Los clientes no han realizado apuestas.
            <v-icon class="error--text">mdi-close-circle</v-icon>
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
  name: "ApuestaCliente",
  components: {
    Spinner,
  },
  data() {
    return {
      loading: false,
      deshabilitado: false,
      apuestasClientes: [],
    };
  },
  created() {
    this.obtenerApuestasCliente();
  },
  computed:{
    esAdmin() {
    return this.$store.getters.esAdmin;
  },
  },
  methods: {
    eliminarApuesta(apuestaEliminar) {
      Swal.fire({
        title: "Eliminar apuesta del cliente",
        text: `¿Estas seguro en eliminar la apuesta del cliente: ${apuestaEliminar.id_cliente}?`,
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#f14545",
        cancelButtonColor: "#204e65",
        cancelButtonText: "No, Cancelar",
        confirmButtonText: "Si, Eliminar Apuesta",
      })
        .then(async (result) => {
          if (result.isConfirmed) {
            this.deshabilitado = true;
            const { data } = await this.axios.delete(
              `/eliminar-apuestaCliente/${apuestaEliminar.id}`
            );
            this.mostrarAlerta("success", data.msg);
            this.apuestasClientes = this.apuestasClientes.filter(
              (apuesta) => apuesta.id !== apuestaEliminar.id
            );
            this.deshabilitado = false;
          }
        })
        .catch((error) => {
          this.deshabilitado = false;
          this.mostrarAlerta("error", error.response.data.msg);
        });
    },
    async obtenerApuestasCliente() {
      try {
        this.loading = true;
        const { data } = await this.axios.get("/obtener-apuestasCliente");
        this.apuestasClientes = data;
        this.loading = false;
      } catch (error) {
        this.loading = false;
        this.mostrarAlerta("error", error.response.data.msg);
      }
    },
    formatearFecha(fecha) {
      const newFecha = new Date(fecha);
      return newFecha.toLocaleString();
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
.margen{
    margin-left: 1em;
}
@media screen and (max-width:800px){
    .margen{
    margin-left: 0;
        margin-top:1em
    }
}
</style>