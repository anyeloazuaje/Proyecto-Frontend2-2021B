<template>
  <v-app>
    <v-container>
      <div v-if="loading">
        <Spinner />
      </div>
      <v-container class="mt-5" v-else>
        <v-data-table
          :headers="datosSolicitudRecarga"
          :items="recargas"
          :search="filtrarSolicitudesRecarga"
          sort-by="fecha"
          class="elevation-1"
          :no-results-text="noEncontrado"
        >
          <template v-slot:top>
            <v-toolbar flat>
              <v-toolbar-title>Solicitudes De Recarga</v-toolbar-title>
              <v-divider class="mx-4" inset vertical></v-divider>
              <v-text-field
                class="text-md-center"
                v-model="filtrarSolicitudesRecarga"
                append-icon="mdi-account-cash-outline"
                label="Buscar solicitudes"
                single-line
                hide-details
              ></v-text-field>
              <v-spacer></v-spacer>
              <v-dialog v-model="modalRecargar" max-width="500px">
                <v-card>
                  <v-card-title>
                    <span class="text-h5">Recargar coins</span>
                  </v-card-title>

                  <v-card-text>
                    <v-container>
                      <v-form ref="form">
                        <v-row>
                          <v-col cols="12">
                            <v-text-field
                              :loading="deshabilitado"
                              :rules="regla"
                              v-model.number="recargar.coins"
                              append-icon="mdi-currency-usd-circle-outline"
                              label="Indique los coins a recargar"
                              min="5"
                              type="number"
                              max="255"
                              hint="El monto debe ser menos a 255 coins."
                            ></v-text-field>
                          </v-col>
                        </v-row>
                      </v-form>
                    </v-container>
                  </v-card-text>
                  <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn
                      :loading="deshabilitado"
                      medium
                      dark
                      color="error"
                      title="Cerrar"
                      @click="cerraModal"
                    >
                      <v-icon> mdi-close-circle </v-icon>
                    </v-btn>
                    <v-btn
                      :loading="deshabilitado"
                      color="teal"
                      dark
                      medium
                      title="Recargar coins"
                      @click="recargarCoins"
                    >
                      <v-icon>mdi-cash-check</v-icon>
                    </v-btn>
                  </v-card-actions>
                </v-card>
              </v-dialog>
            </v-toolbar>
          </template>
          <template v-slot:[`item.actions`]="{ item }">
            <v-btn
              fab
              small
              color="green"
              dark
              @click="abriModalRecargar(item)"
              title="Abrir modal para recargar"
              :loading="deshabilitado"
            >
              <v-icon> mdi-currency-usd-circle-outline </v-icon>
            </v-btn>
            <v-btn
              fab
              small
              color="error"
              class="ml-2"
              title="Eliminar solicitud de recarga"
              @click="eliminarSolicitudRecarga(item)"
              :loading="deshabilitado"
            >
              <v-icon small>mdi-account-cash </v-icon>
            </v-btn>
          </template>
          <template v-slot:no-data>
            Los clientes no han solicitado recargas.
            <v-icon
              title="Recargar solicitudes"
              @click="obtenerSolicitudRecargas"
              class="error--text"
              >mdi-account-cash</v-icon
            >
          </template>
        </v-data-table>
      </v-container>
    </v-container>
  </v-app>
</template>

<script>
import Swal from "sweetalert2";
import Spinner from "@/components/Spinner.vue";
export default {
  name: "Recargas",
  components: {
    Spinner,
  },
  data() {
    return {
      regla: [(value) => !!value || "El campo es obligatorio."],
      recargas: [],
      modalRecargar: false,
      recargar: {
        coins: null,
      },
      datosSolicitud: {},
      noEncontrado:
        "No se han encontrado solicitudes de recarga que coincidan con la búsqueda.",
      filtrarSolicitudesRecarga: "",
      loading: false,
      deshabilitado: false,
      datosSolicitudRecarga: [
        {
          sortable: false,
        },
        { text: "Nombre del titular", value: "nombre" },
        { text: "Apellido del titular", value: "apellido" },
        { text: "Fecha de solicitud", value: "fecha" },
        { text: "Correo", value: "id_cliente.correo" },
        { text: "Coins actuales", value: "id_cliente.coins" },
        { text: "Tarjeta", value: "tarjeta" },
        { text: "N° Tarjeta", value: "numero_tarjeta" },
        { text: "Acciones", value: "actions", sortable: false },
      ],
    };
  },
  created() {
    this.obtenerSolicitudRecargas();
  },
  watch: {
    modalRecargar(valor) {
      valor || this.cerraModal();
    },
  },
  methods: {
    abriModalRecargar(solicitudRecargar) {
      this.datosSolicitud = Object.assign({}, solicitudRecargar);
      this.modalRecargar = true;
    },
    eliminarSolicitudRecarga(recargarEliminar) {
      Swal.fire({
        title: "Eliminar solicitud de recarga",
        text: `¿Desea eliminar la solicitud de recarga del cliente ${recargarEliminar.id_cliente.correo}?`,
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#f14545",
        cancelButtonColor: "#204e65",
        cancelButtonText: "No, cerrar",
        confirmButtonText: "Si, Eliminar",
      })
        .then(async (result) => {
          if (result.isConfirmed) {
            this.deshabilitado = true;
            const { data } = await this.axios.delete(
              `eliminar-solicitudRecarga/${recargarEliminar.id}`
            );
            this.mostrarAlerta("success", data.msg);
            this.recargas = this.recargas.filter(
              (recarga) => recarga.id !== recargarEliminar.id
            );
            this.deshabilitado = false;
          }
        })
        .catch((error) => {
          this.deshabilitado = false;
          this.mostrarAlerta("error", error.response.data.msg);
        });
    },
    async obtenerSolicitudRecargas() {
      try {
        this.loading = true;
        const { data } = await this.axios.get("/obtener-solicitudRecargas");
        this.recargas = data.map((recarga) => ({
          id: recarga.id,
          nombre: recarga.nombre,
          apellido: recarga.apellido,
          id_cliente: recarga.id_cliente,
          numero_tarjeta: recarga.numero_tarjeta,
          tarjeta: recarga.tarjeta,
          fecha: new Date(recarga.fecha).toLocaleString(),
        }));
        this.loading = false;
      } catch (error) {
        this.loading = false;
        this.mostrarAlerta("error", error.response.data.msg);
      }
    },
    async recargarCoins() {
      if (!this.recargar.coins) {
        this.$refs.form.validate();
        return this.mostrarAlerta(
          "error",
          "Debes indicar el monto a recargar."
        );
      }
      if (this.recargar.coins > 255) {
        this.$refs.form.validate();
        return this.mostrarAlerta(
          "error",
          "El monto debe ser menos a 255 coins."
        );
      }
      try {
        this.deshabilitado = true;
        const recargaID = JSON.parse(JSON.stringify(this.datosSolicitud.id));
        const { data } = await this.axios.put(
          `/recargar-cliente/${recargaID}`,
          this.recargar
        );
        this.mostrarAlerta("success", data.msg);
        this.recargas = this.recargas.filter(
          (recarga) => recarga.id !== recargaID
        );
        this.deshabilitado = false;
        this.cerraModal();
      } catch (error) {
        this.mostrarAlerta("error", error.response.data.msg);
        this.deshabilitado = false;
      }
    },
    cerraModal() {
      this.modalRecargar = false;
      this.$refs.form.resetValidation();
      this.recargar = {
        coins: null,
      };
      this.datosSolicitud = {};
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

<style>
input::-webkit-outer-spin-button,
input::-webkit-inner-spin-button {
  -webkit-appearance: none;
  margin: 0;
}

input[type="number"] {
  -moz-appearance: textfield;
}
</style>