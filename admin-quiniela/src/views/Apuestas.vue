<template>
  <v-app>
    <div v-if="loading">
      <Spinner />
    </div>
    <v-container class="mt-5" v-else>
      <v-data-table
        :headers="headerApuestas"
        :items="apuestas"
        :search="busquedaApuesta"
        sort-by="fecha"
        class="elevation-1"
        :no-results-text="apuestasNoEncontradas"
      >
        <template v-slot:top>
          <v-toolbar flat>
            <v-toolbar-title>Apuestas Registradas</v-toolbar-title>
            <v-divider class="mx-4" inset vertical></v-divider>
            <v-text-field
              class="text-md-center"
              v-model="busquedaApuesta"
              append-icon="mdi-trophy-variant-outline"
              label="Buscar apuesta"
              single-line
              hide-details
            ></v-text-field>
            <v-spacer></v-spacer>
            <v-dialog v-model="modalApuesta" max-width="500px">
              <template v-slot:activator="{ on, attrs }">
              <template v-if="esAdmin">
                <v-btn
                  color="primary darken-1 "
                  dark
                  fab
                  small
                  class="mb-2"
                  v-bind="attrs"
                  title="Crear Apuesta"
                  v-on="on"
                >
                  <v-icon> mdi-plus-circle </v-icon>
                </v-btn>
              </template>
              </template>
              <v-card>
                <v-card-title>
                  <span class="text-h5">{{ tituloForm }}</span>
                </v-card-title>
                <v-card-text>
                  <v-container>
                    <v-form ref="form">
                      <v-row>
                        <template v-if="!editarApuesta">
                          <v-col cols="12">
                            <v-autocomplete
                              clearable
                              chips
                              :loading="deshabilitado"
                              :rules="reglas"
                              v-model="apuesta.id_equipo1.nombre"
                              @change="ejecutarCambio"
                              :items="equipoSelect"
                              label="Primer Equipó A Competir"
                              append-icon="mdi-account-group"
                              placeholder="Seleccionar o buscar equipo primer equipo"
                              no-data-text="Equipó no encontrado."
                              :allow-overflow="false"
                            ></v-autocomplete>
                          </v-col>
                          <v-col cols="12">
                            <v-autocomplete
                              clearable
                              chips
                              :loading="deshabilitado"
                              :rules="reglas"
                              v-model="apuesta.id_equipo2.nombre"
                              ref="input"
                              @change="ejecutarCambio"
                              :items="equipoSelect"
                              label="Segundo Equipó A Competir"
                              placeholder="Seleccionar o buscar equipo segundo equipo"
                              hint="No debe ser igual al primero."
                              no-data-text="Equipó no encontrado."
                              append-icon="mdi-account-group-outline"
                              :allow-overflow="false"
                            ></v-autocomplete>
                          </v-col>
                        </template>
                        <v-col cols="12" sm="6">
                          <v-text-field
                            type="number"
                            min="10"
                            max="200"
                            append-icon="mdi-cash-usd"
                            :loading="deshabilitado"
                            :rules="reglas"
                            v-model.number="apuesta.costo"
                            label="Costo de la apuesta"
                            hint="Costo en coins que se restara al cliente."
                          ></v-text-field>
                        </v-col>
                        <v-col cols="12" sm="6">
                          <v-text-field
                            type="number"
                            min="10"
                            max="200"
                            :loading="deshabilitado"
                            :rules="reglas"
                            v-model.number="apuesta.ganancia"
                            append-icon="mdi-currency-usd-circle"
                            label="Ganancía de la apuesta"
                            hint="Este valor sera sumando en los coins del cliente."
                          ></v-text-field>
                        </v-col>
                         <v-col cols="12">
                          <v-menu
                            ref="menu"
                            v-model="menu"
                            :close-on-content-click="false"
                            :return-value.sync="apuesta.fecha_resultado"
                            transition="scale-transition"
                            offset-y
                            min-width="auto"
                          >
                            <template v-slot:activator="{ on, attrs }">
                              <v-text-field
                                v-model="apuesta.fecha_resultado"
                                label="Seleccionar fecha de resultado."
                                append-icon="mdi-calendar"
                                hint="Esta fecha puede cambiar."
                                v-bind="attrs"
                                v-on="on"
                              ></v-text-field>
                            </template>
                            <v-date-picker
                              color="teal darken-1"
                              header-color="primary"
                              v-model="apuesta.fecha_resultado"
                              no-title
                              scrollable
                            >
                              <v-spacer></v-spacer>
                              <v-btn title="Cerrar" text color="primary" @click="menu = false">
                                Cerrar 
                              </v-btn>
                              <v-btn
                                text
                                color="primary"
                                title="Establecer fecha"
                                @click="
                                  $refs.menu.save(apuesta.fecha_resultado)
                                "
                              >
                                Guardar
                              </v-btn>
                            </v-date-picker>
                          </v-menu>
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
                    @click="cerraModal"
                    title="Cerra Modal"
                  >
                     <v-icon>mdi-close</v-icon>
                  </v-btn>
                  <v-btn
                    :loading="deshabilitado"
                    :color="editarApuesta ? 'teal' : 'primary'"
                    @click="enviarApuesta"
                    dark
                    medium
                    title="Enviar Apuesta"
                  >
                    <v-icon>mdi-trophy-outline</v-icon>
                  </v-btn>
                </v-card-actions>
              </v-card>
            </v-dialog>
          </v-toolbar>
        </template>
        <template v-slot:[`item.actions`]="{ item }">
        <template v-if="esAdmin">
          <v-btn
            fab
            small
            color="primary"
            :loading="deshabilitado"
            title="Editar Apuesta"
            @click="asignarDatosApuesta(item)"
          >
            <v-icon small> mdi-tooltip-edit-outline </v-icon>
          </v-btn>
          <v-btn
            fab
            small
            color="error"
            :loading="deshabilitado"
            title="Eliminar Apuesta"
            @click="eliminarApuesta(item)"
          >
            <v-icon small> mdi-trophy </v-icon>
          </v-btn>
        </template>
        <template v-else>
          <v-icon class="primary--text"> mdi-shield-lock</v-icon>
        </template>
        </template>
        <template v-slot:no-data>
          <v-btn color="primary" @click="obtenerApuestas">
            Obtener apuestas<v-icon>mdi-trophy-award</v-icon>
          </v-btn>
        </template>
      </v-data-table>
    </v-container>
  </v-app>
</template>

<script>
import Swal from "sweetalert2";
import Spinner from "@/components/Spinner.vue";
export default {
  name: "Apuestas",
  components: {
    Spinner,
  },
  data() {
    return {
      apuestasNoEncontradas:
        "No se encontraron apuestas relacionando con la búsqueda.",
      modalApuesta: false,
      loading: false,
      menu: false,
      deshabilitado: false,
      busquedaApuesta: "",
      reglas: [(value) => !!value || "El campo es obligatorio."],
      equipos: [],
      equipoSelect: [],
      editarApuesta: false,
      apuesta: {
        id_equipo1: {nombre:""},
        id_equipo2: {nombre:""},
        fecha_resultado: new Date(
          Date.now() - new Date().getTimezoneOffset() * 60000
        )
          .toISOString()
          .substr(0, 10),
        costo:null,
        ganancia:null,
      },
      apuestas: [],
      headerApuestas: [
        {
          sortable: false,
        },
        { text: "Primer Equipo", value: "id_equipo1.nombre" },
        { text: "Segúndo Equipo", value: "id_equipo2.nombre" },
        { text: "Costo de la apuesta (coins)", value: "costo" },
        { text: "Ganancía de la apuesta (coins)", value: "ganancia" },
        { text: "Fecha de modificación", value: "fecha" },
        { text: "Fecha de resultado", value: "fecha_resultado" },
        { text: "Acciones", value: "actions", sortable: false },
      ],
    };
  },
  computed: {
    tituloForm() {
      return this.editarApuesta ? "Editar Apuesta" : "Crear Apuesta";
    },
     esAdmin() {
      return this.$store.getters.esAdmin;
    },
  },

  watch: {
    modalApuesta(valor) {
      valor || this.cerraModal();
    },
  },
  created() {
    this.obtenerDatosApuestas();
  },
  methods: {
    obtenerDatosApuestas() {
      this.obtenerApuestas();
      this.obtenerEquipos();
    },
    ejecutarCambio() {
      if (this.apuesta.id_equipo1.nombre === this.apuesta.id_equipo2.nombre) {
        this.$refs.form.validate();
        this.mostrarAlerta(
          "error",
          "Los equipos en la apuesta no debe ser los mismos."
        );
        this.apuesta.id_equipo2.nombre = null;
        return;
      }
    },
    asignarDatosApuesta(apuestaEditar) {
      this.editarApuesta = true;
      this.apuesta = Object.assign({}, apuestaEditar);
      this.modalApuesta = true;
    },

    eliminarApuesta(informacionApuesta) {
      Swal.fire({
        title: "Eliminar apuesta",
        text: `¿Estas seguro en eliminar la apuesta ${informacionApuesta.id_equipo1.nombre} VS ${informacionApuesta.id_equipo2.nombre}?`,
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#f14545",
        cancelButtonColor: "#204e65",
        cancelButtonText: "No, Cerrar modal",
        confirmButtonText: "Si, Eliminar apuesta",
      })
        .then(async (result) => {
          if (result.isConfirmed) {
            this.deshabilitado = true;
            const { data } = await this.axios.delete(
              `/eliminar-apuesta/${informacionApuesta.id}`
            );
            this.mostrarAlerta("success", data.msg);
            this.apuestas = this.apuestas.filter(
              (apuesta) => apuesta.id !== informacionApuesta.id
            );
            this.deshabilitado = false;
          }
        })
        .catch((error) => {
          this.deshabilitado = false;
          this.mostrarAlerta("error", error.response.data.msg);
        });
    },
    enviarApuesta() {
      if (
        !this.apuesta.id_equipo1.nombre ||
        !this.apuesta.id_equipo2.nombre ||
        !this.apuesta.id_equipo1.nombre.length ||
        !this.apuesta.id_equipo2.nombre.length ||
        !this.apuesta.ganancia ||
        !this.apuesta.costo
      ) {
        this.mostrarAlerta(
          "error",
          "Todos los campos son obligatorios para crear  una apuesta."
        );
        return this.$refs.form.validate();
      }
      if (this.apuesta.id_equipo1.nombre === this.apuesta.id_equipo2.nombre) {
        this.$refs.form.validate();
        this.mostrarAlerta(
          "error",
          "Los equipos en la apuesta no debe ser los mismos."
        );
        return;
      }
      if (this.apuesta.costo > 255) {
        this.mostrarAlerta(
          "error",
          "El costó de la apuesta es mayor a 255. Indica un costó menor."
        );
        return;
      }
      if (this.apuesta.ganancia > 200) {
        this.mostrarAlerta(
          "error",
          "El costó de la ganancia es muy elevado, debe ser menor a 200."
        );
        return;
      }
      this.editarApuesta
        ? this.actualizarApuesta()
        : this.crearApuesta(this.apuesta);
    },
    async actualizarApuesta() {
      const apuestaActualizar = JSON.parse(JSON.stringify(this.apuesta));
      apuestaActualizar.fecha = new Date();
      try {
        this.deshabilitado = true;
        const { data } = await this.axios.put(
          `/actualizar-apuesta/${this.apuesta.id}`,
          apuestaActualizar
        );
        this.deshabilitado = false;
        this.mostrarAlerta("success", data.msg);
        this.cerraModal();
        this.obtenerApuestas();
      } catch (error) {
        this.deshabilitado = false;
        this.mostrarAlerta("error", error.response.data.msg);
      }
    },
    async crearApuesta(apuestaCrear) {
      const [equipoUno] = this.equipos.filter(
        (equipo) => equipo.nombre === apuestaCrear.id_equipo1.nombre
      );
      const [equipoDos] = this.equipos.filter(
        (equipo) => equipo.nombre === apuestaCrear.id_equipo2.nombre
      );
      const apuestaEnviar = JSON.parse(JSON.stringify(apuestaCrear));
      apuestaEnviar.id_equipo1 = equipoUno.id;
      apuestaEnviar.id_equipo2 = equipoDos.id;
      try {
        this.deshabilitado = true;
        const { data } = await this.axios.post("/crear-apuesta", apuestaEnviar);
        this.mostrarAlerta("success", data.msg);
        this.deshabilitado = false;
        this.cerraModal();
        this.obtenerApuestas();
      } catch (error) {
        this.deshabilitado = false;
        this.mostrarAlerta("error", error.response.data.msg);
      }
    },
    cerraModal() {
      this.modalApuesta = false;
      this.editarApuesta = false;
      this.$refs.form.resetValidation();
      this.apuesta = {
        id_equipo1: {nombre:""},
        id_equipo2: {nombre:""},
        fecha_resultado:new Date(
          Date.now() - new Date().getTimezoneOffset() * 60000
        )
          .toISOString()
          .substr(0, 10),
        costo: null,
        ganancia: null,
      };
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
    async obtenerEquipos() {
      try {
        this.loading = true;
        const { data } = await this.axios.get("/obtener-equipos");
        this.equipos = data;
        this.loading = false;
        const equipoSelect = data.map((equipo) => equipo.nombre);
        this.equipoSelect = equipoSelect;
      } catch (error) {
        this.loading = false;
        this.mostrarAlerta("error", error.response.data.msg);
      }
    },
    async obtenerApuestas() {
      try {
        this.loading = true;
        const { data } = await this.axios.get("/obtener-apuestas");
        this.apuestas = data.map((apuesta) => {
          return {
            id: apuesta.id,
            id_equipo1: apuesta.id_equipo1,
            id_equipo2: apuesta.id_equipo2,
            costo: apuesta.costo,
            ganancia: apuesta.ganancia,
            fecha_resultado: apuesta.fecha_resultado,
            fecha: new Date(apuesta.fecha).toLocaleString(),
          };
        });
        this.loading = false;
      } catch (error) {
        this.loading = false;
        this.mostrarAlerta("error", error.response.data.msg);
      }
    },
  },
};
</script>