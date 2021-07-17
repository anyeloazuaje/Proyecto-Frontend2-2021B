<template>
  <v-app>
    <div v-if="loading">
      <Spinner />
    </div>
    <v-container class="mt-5" v-else>
      <v-data-table
        :headers="tablaDatos"
        :items="equipos"
        :search="buscarEquipo"
        sort-by="id_categoria"
        class="elevation-1"
        :no-results-text="textoEquipoNoEncontrado"
      >
        <template v-slot:top>
          <v-toolbar flat>
            <v-toolbar-title>Equipos registrados</v-toolbar-title>
            <v-divider class="mx-4" inset vertical></v-divider>
            <v-text-field
              class="text-md-center"
              v-model="buscarEquipo"
              append-icon="mdi-account-search-outline"
              label="Buscar equipó"
              single-line
              hide-details
            ></v-text-field>
            <v-spacer></v-spacer>
            <v-dialog v-model="modalEquipo" max-width="500px">
              <template v-slot:activator="{ on, attrs }">
                <template v-if="esAdmin">
                  <v-btn
                    color="info darken-1 "
                    dark
                    fab
                    small
                    class="mb-2"
                    title="Abrir modla para crear un equipó."
                    v-bind="attrs"
                    v-on="on"
                  >
                    <v-icon> mdi-account-multiple-plus </v-icon>
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
                        <v-col cols="12" sm="6">
                          <v-text-field
                            type="text"
                              append-icon="mdi-format-color-text"
                            v-model.trim="equipo.nombre"
                            :rules="reglas"
                            label="Nombre del equipó"
                            hint="El nombre del equipó debe ser único."
                          ></v-text-field>
                        </v-col>
                        <v-col cols="12" sm="6">
                          <v-text-field
                            type="text"
                            append-icon="mdi-account-multiple"
                            :loading="deshabilitado"
                            v-model.trim="equipo.director"
                            :rules="reglas"
                            label="Nombre del director"
                          ></v-text-field>
                        </v-col>
                        <v-col cols="12" sm="6">
                          <v-text-field
                            :loading="deshabilitado"
                            append-icon="mdi-human"
                            v-model.number="equipo.jugadores"
                            :rules="reglas"
                            type="number"
                            min="3"
                            label="Número de jugadores del equipó"
                          ></v-text-field>
                        </v-col>
                        <v-col cols="12" sm="6">
                          <v-text-field
                            v-model.trim="equipo.url_imagen"
                            type="url"
                            :loading="deshabilitado"
                            append-icon="mdi-image-area"
                            :rules="reglas"
                            label="Logo del equipó"
                            hint="Imagen a través de un enlace."
                          ></v-text-field>
                        </v-col>
                        <v-col cols="12">
                          <v-select
                            :loading="deshabilitado"
                            :rules="reglas"
                            v-model="equipo.id_categoria"
                            append-icon="mdi-folder"
                            :items="selectCategorias"
                            chips
                            label="Categoría del equipo"
                            placeholder="Seleccionar categoría"
                            no-data-text="Este categoría no existe."
                            :allow-overflow="false"
                          ></v-select>
                        </v-col>
                      </v-row>
                      <v-container>
                        <div
                          class="text-center"
                          v-if="equipo.url_imagen && equipo.url_imagen.length"
                        >
                          <img
                            class="imagen-equipo"
                            :src="equipo.url_imagen"
                            alt="logo-equipó"
                          />
                        </div>
                      </v-container>
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
                    title="Cerrar Modal"
                  >
                    <v-icon>mdi-close</v-icon>
                  </v-btn>
                  <v-btn
                    title="Guarda Equipo"
                    :loading="deshabilitado"
                    :color="!esEditar ? 'primary' : 'teal'"
                    dark
                    medium
                    @click="enviarFormulario"
                  >
                    <v-icon>{{ iconoForm }}</v-icon>
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
              color="teal"
              @click="asignarDatosEditar(item)"
              :loading="deshabilitado"
            >
              <v-icon small class="white--text"> mdi-account-edit </v-icon>
            </v-btn>
            <v-btn
              @click="eliminarEquipo(item)"
              fab
              small
              color="error"
              class="ml-2"
              :loading="deshabilitado"
            >
              <v-icon small>mdi-account-multiple-minus</v-icon>
            </v-btn>
          </template>
          <template v-else>
            <small
              ><v-icon class="primary--text"
                >mdi-account-lock-outline</v-icon
              ></small
            >
          </template>
        </template>
        <template v-slot:no-data>
          <v-btn color="primary" @click="obtenerEquipos">
            <v-icon>mdi-reload</v-icon>
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
  name: "Equipos",
  components: {
    Spinner,
  },
  data() {
    return {
      loading: false,
      esEditar: false,
      modalEquipo: false,
      deshabilitado: false,
      buscarEquipo: "",
      textoEquipoNoEncontrado:
        "No se encontraron equipos relacionados con la búsqueda",
      tablaDatos: [
        {
          sortable: false,
        },
        { text: "#ID", value: "id" },
        { text: "Nombre", value: "nombre" },
        { text: "Jugadores", value: "jugadores" },
        { text: "Director", value: "director" },
        { text: "Categoría", value: "id_categoria" },
        { text: "Acciones", value: "actions", sortable: false },
      ],
      reglas: [(value) => !!value || "El campo es obligatorio."],

      equipo: {
        nombre: "",
        jugadores: "",
        director: "",
        url_imagen: "",
        id_categoria: "",
      },
      equipos: [],
      categorias: [],
      selectCategorias: [],
    };
  },
  watch: {
    modalEquipo(valor) {
      valor || this.cerraModal();
    },
  },
  created() {
    this.obtenerEquipos();
    this.obtenerCategorias();
  },
  computed: {
    tituloForm() {
      return this.esEditar ? "Editar Equipo" : "Crear Equipo";
    },
    iconoForm() {
      return this.esEditar
        ? "mdi-account-edit-outline"
        : "mdi-account-multiple-plus";
    },
    esAdmin() {
      return this.$store.getters.esAdmin;
    },
  },
  methods: {
    async obtenerCategorias() {
      try {
        this.loading = true;
        const { data } = await this.axios.get("/obtener-categorias");
        this.categorias = data;
        this.selectCategorias = data.map((autor) => autor.nombre);
        this.loading = false;
      } catch (error) {
        this.mostrarAlerta("error", error.response.data.msg);
        this.loading = false;
      }
    },
    async obtenerEquipos() {
      try {
        this.loading = true;
        const { data } = await this.axios.get("/obtener-equipos");
        this.loading = false;
        this.equipos = data;
      } catch (error) {
        this.loading = false;
        this.mostrarAlerta("error", error.response.data.msg);
      }
    },
    asignarDatosEditar(equipoEditar) {
      this.equipo = Object.assign({}, equipoEditar);
      this.esEditar = true;
      this.modalEquipo = true;
    },
    cerraModal() {
      this.modalEquipo = false;
      this.esEditar = false;
      this.$refs.form.resetValidation();
      this.equipo = {
        nombre: "",
        jugadores: "",
        director: "",
        url_imagen: "",
        id_categoria: "",
      };
    },
    eliminarEquipo(equipoEliminar) {
      Swal.fire({
        title: "Eliminar equipo",
        text: `¿Estas seguro en eliminar el equipo con nombre: ${equipoEliminar.nombre}? Al eliminar el equipo se borraran las apuestas en que participa, apuestas del cliente y seguimientos.`,
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#f14545",
        cancelButtonColor: "#009688",
        cancelButtonText: "No, Cerrar modal",
        confirmButtonText: "Si, Eliminar equipo",
      })
        .then(async (result) => {
          if (result.isConfirmed) {
            this.deshabilitado = true;
            const { data } = await this.axios.delete(
              `/eliminar-equipo/${equipoEliminar.id}`
            );
            this.mostrarAlerta("success", data.msg);
            this.equipos = this.equipos.filter(
              (equipo) => equipo.id !== equipoEliminar.id
            );
            this.deshabilitado = false;
          }
        })
        .catch((error) => {
          this.deshabilitado = false;
          this.mostrarAlerta("error", error.response.data.msg);
        });
    },
    async crearEquipo(equipoCrear) {
      if (
        !this.equipo.nombre ||
        !this.equipo.director ||
        !this.equipo.jugadores ||
        !this.equipo.url_imagen ||
        !this.equipo.id_categoria
      ) {
        this.$refs.form.validate();
        return this.mostrarAlerta(
          "error",
          "Todos los datos son necesarios para crear un equipo."
        );
      }
      try {
        const [categoriaSeleccionada] = this.categorias.filter(
          (categoria) => categoria.nombre === this.equipo.id_categoria
        );
        equipoCrear.id_categoria = categoriaSeleccionada.id;
        this.deshabilitado = true;
        const { data } = await this.axios.post("/crear-equipo", equipoCrear);
        this.mostrarAlerta("success", data.msg);
        this.deshabilitado = false;
        this.cerraModal();
        this.obtenerEquipos();
      } catch (error) {
        this.mostrarAlerta("error", error.response.data.msg);
        this.deshabilitado = false;
      }
    },
    async actualizarEquipo() {
      if (
        !this.equipo.nombre ||
        !this.equipo.director ||
        !this.equipo.jugadores ||
        !this.equipo.url_imagen ||
        !this.equipo.id_categoria
      ) {
        this.$refs.form.validate();
        return this.mostrarAlerta(
          "error",
          "Todos los datos son necesarios para actualizar un equipo."
        );
      }
      try {
        const [categoriaSeleccionada] = this.categorias.filter(
          (categoria) => categoria.nombre === this.equipo.id_categoria
        );
        this.equipo.id_categoria = categoriaSeleccionada.id;
        this.deshabilitado = true;
        const { data } = await this.axios.put(
          `/actualizar-equipo/${this.equipo.id}`,
          this.equipo
        );
        this.mostrarAlerta("success", data.msg);
        this.deshabilitado = false;
        this.cerraModal();
        this.obtenerEquipos();
      } catch (error) {
        this.deshabilitado = false;
        this.mostrarAlerta("error", error.response.data.msg);
      }
    },
    enviarFormulario() {
      this.esEditar ? this.actualizarEquipo() : this.crearEquipo(this.equipo);
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
.imagen-equipo {
  width: 190px;
  height: 106px;
}
</style>