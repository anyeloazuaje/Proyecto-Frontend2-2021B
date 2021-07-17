     <template>
  <v-app>
    <div v-if="loading">
      <Spinner />
    </div>
    <v-container class="mt-5" v-else>
      <v-data-table
        :headers="tablaLabel"
        :items="autores"
        :search="busqueda"
        sort-by="fecha"
        class="elevation-1"
        :no-results-text="sinResultados"
      >
        <template v-slot:top>
          <v-toolbar flat>
            <v-toolbar-title>Autores</v-toolbar-title>
            <v-divider class="mx-4" inset vertical></v-divider>
            <v-text-field
              class="text-md-center"
              v-model="busqueda"
              append-icon="mdi-account-search"
              label="Buscar autor"
              single-line
              hide-details
            ></v-text-field>
            <v-spacer></v-spacer>
            <v-dialog v-model="modalAutor" max-width="500px">
              <template v-slot:activator="{ on, attrs }">
                <v-btn
                  color="teal darken-1 "
                  dark
                  fab
                  small
                  class="mb-2"
                  v-bind="attrs"
                  v-on="on"
                >
                  <v-icon> mdi-plus </v-icon>
                </v-btn>
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
                            :rules="reglas"
                            :loading="deshabilitado"
                            v-model.trim="autor.nombre"
                            append-icon="mdi-account-box"
                            label="Nombre del autor"
                            hint="El nombre del autor debe ser único."
                          ></v-text-field>
                        </v-col>
                        <v-col cols="12" sm="6">
                          <v-text-field
                            :rules="reglas"
                            :loading="deshabilitado"
                            v-model.trim="autor.pais"
                            append-icon="mdi-earth"
                            label="País del autor"
                          ></v-text-field>
                        </v-col>
                      </v-row>
                    </v-form>
                  </v-container>
                </v-card-text>

                <v-card-actions>
                  <v-spacer></v-spacer>
                  <v-btn title="Cerrar" :loading="deshabilitado" medium dark color="error" @click="cerraModal">
                   <v-icon>mdi-close</v-icon>
                  </v-btn>
                  <v-btn :title="tituloForm" :loading="deshabilitado" :color="editar ? 'teal' : 'primary'" dark medium @click="enviarAutorAccion">
                   <v-icon> {{iconBoton}} </v-icon>
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
            color="primary"
            @click="editarAutor(item)"
            :loading="deshabilitado"
          >
            <v-icon small> mdi-pencil </v-icon>
          </v-btn>
          <v-btn
            fab
            small
            color="error"
            class="ml-2"
            @click="eliminarAutor(item)"
            :loading="deshabilitado"
          >
            <v-icon small> mdi-delete </v-icon>
          </v-btn>
        </template>
        <template v-slot:no-data>
          <v-btn color="primary" @click="obtenerAutores">
            Obtener autores<v-icon>mdi-reload</v-icon>
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
  name: "Autor",
  components: {
    Spinner,
  },
  data: () => ({
    loading: true,
    deshabilitado: false,
    busqueda: "",
    autores: [],
    modalAutor: false,
    reglas: [(value) => !!value || "El campo es obligatorio."],
    tablaLabel: [
      {
        sortable: false,
      },
      { text: "#ID", value: "id" },
      { text: "Nombre", value: "nombre" },
      { text: "País", value: "pais" },
      { text: "Fecha de modificación", value: "fecha" },
      { text: "Acciones", value: "actions", sortable: false },
    ],
    editar: false,
    autor: {
      nombre: "",
      pais: "",
    },
    sinResultados: "No existen autores que coincidan con la búsqueda.",
  }),

  computed: {
    tituloForm() {
      return this.editar ? "Editar Autor" : "Crear Autor";
    },
    iconBoton() {
      return this.editar ? "mdi-account-edit" : "mdi-account-plus";
    },
  },

  watch: {
    modalAutor(valor) {
      valor || this.cerraModal();
    },
  },

  created() {
    this.obtenerAutores();
  },

  methods: {
    fechaConFormato(fechaAFormatear) {
      return new Date(fechaAFormatear).toLocaleString();
    },
    async obtenerAutores() {
      this.loading = true;
      try {
        const { data } = await this.axios.get("/obtener-autores");
        this.autores = data.map((autor) => {
          return {
            id: autor.id,
            nombre: autor.nombre,
            pais: autor.pais,
            fecha: this.fechaConFormato(autor.fecha),
          };
        });
        this.loading = false;
      } catch (error) {
        this.loading = false;
        this.mostrarAlerta("error", error.response.data.msg);
      }
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
    editarAutor(item) {
      this.editar = true;
      this.autor = Object.assign({}, item);
      this.modalAutor = true;
    },
    async eliminarAutor(autorEliminar) {
      Swal.fire({
        title: "Eliminar autor",
        text: `¿Estas seguro en eliminar el autor ${autorEliminar.nombre}? Al eliminar el autor se borraran sus notícias.`,
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#f14545",
        cancelButtonColor: "#009688",
        cancelButtonText: "No, cancelar",
        confirmButtonText: "Si, Eliminar",
      })
        .then(async (result) => {
          if (result.isConfirmed) {
            this.deshabilitado = true;
            const { data } = await this.axios.delete(
              `/eliminar-autor/${autorEliminar.id}`
            );
            this.mostrarAlerta("success", data.msg);
            this.autores = this.autores.filter(
              (autor) => autor.id !== autorEliminar.id
            );
            this.deshabilitado = false;
          }
        })
        .catch((error) => {
          this.deshabilitado = false;
          this.mostrarAlerta("error", error.response.data.msg);
        });
    },
    cerraModal() {
      this.modalAutor = false;
      this.editar = false;
      this.$refs.form.resetValidation();
      this.$nextTick(() => {
        this.autor = {
          nombre: "",
          pais: "",
        };
      });
    },
    async actualizarAutor(autorEditar) {
      if (!autorEditar.nombre.length || !autorEditar.pais.length) {
        this.$refs.form.validate();
        return this.mostrarAlerta(
          "error",
          "Todos los campos son obligatorios."
        );
      }
      try {
        this.deshabilitado = true;
        const nuevoAutor = JSON.parse(JSON.stringify(autorEditar));
        nuevoAutor.fecha = new Date();
        const { data } = await this.axios.put(
          `/actualizar-autor/${autorEditar.id}`,
          nuevoAutor
        );
        this.mostrarAlerta("success", data.msg);
        this.obtenerAutores();
        this.deshabilitado = false;
        this.cerraModal();
      } catch (error) {
        this.deshabilitado = false;
        this.mostrarAlerta("error", error.response.data.msg);
      }
    },
    async crearAutor(informacionAutor) {
      try {
        if (!informacionAutor.nombre.length || !informacionAutor.pais.length) {
          this.$refs.form.validate();
          return this.mostrarAlerta(
            "error",
            "Todos los campos son obligatorios."
          );
        }
        this.deshabilitado = true;
        const { data } = await this.axios.post(
          "/crear-autor",
          informacionAutor
        );
        this.mostrarAlerta("success", data.msg);
        this.deshabilitado = false;
        this.obtenerAutores();
        this.autor = {
          nombre: "",
          pais: "",
        };
        this.cerraModal();
      } catch (error) {
        this.deshabilitado = false;
        this.mostrarAlerta("error", error.response.data.msg);
      }
    },
    enviarAutorAccion() {
      if (this.editar) {
        this.actualizarAutor(this.autor);
      } else {
        this.crearAutor(this.autor);
      }
    },
  },
};
</script>
