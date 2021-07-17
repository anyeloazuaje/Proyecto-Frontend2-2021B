<template>
  <v-app>
    <div v-if="loading">
      <Spinner />
    </div>
    <v-container class="mt-5" v-else>
      <v-data-table
        :headers="valorTablaCategoria"
        :items="categorias"
        :search="busquedaCategoria"
        sort-by="id"
        class="elevation-1"
        :no-results-text="noEncontrado"
      >
        <template v-slot:top>
          <v-toolbar flat>
            <v-toolbar-title>Categorías</v-toolbar-title>
            <v-divider class="mx-4" inset vertical></v-divider>
            <v-text-field
              class="text-md-center"
              v-model="busquedaCategoria"
              append-icon="mdi-folder-search"
              label="Buscar categoría"
              single-line
              hide-details
            ></v-text-field>
            <v-spacer></v-spacer>
            <v-dialog v-model="modalCategoria" max-width="500px">
              <template v-slot:activator="{ on, attrs }">
                <v-btn
                  color="primary darken-2 "
                  dark
                  title="Agregar nueva categoría"
                  fab
                  small
                  class="mb-2"
                  v-bind="attrs"
                  v-on="on"
                >
                  <v-icon> mdi-folder-plus </v-icon>
                </v-btn>
              </template>
              <v-card>
                <v-card-title>
                  <span class="text-h5">
                    {{ esEditar ? "Editar" : "Agregar" }} Categoría</span
                  >
                </v-card-title>

                <v-card-text>
                  <v-container>
                    <v-form ref="form">
                      <v-row>
                        <v-col cols="12">
                          <v-text-field
                            :rules="reglas"
                            v-model.trim="categoria.nombre"
                            :loading="deshabilitado"
                            append-icon="mdi-folder"
                            label="Tipo de categoría"
                            hint="El tipo de la categoría debe ser único. Ej Fútbol."
                          ></v-text-field>
                        </v-col>
                      </v-row>
                    </v-form>
                  </v-container>
                </v-card-text>

                <v-card-actions>
                  <v-spacer></v-spacer>
                  <v-btn
                    medium
                    dark
                    title="Cerrar modal"
                    color="error"
                    @click="cerrarModal"
                    :loading="deshabilitado"
                  >
                    <v-icon> mdi-close </v-icon>
                  </v-btn>
                  <v-btn
                    dark
                    :color="!esEditar ?  'teal' : 'primary'"
                    :title="esEditar ? 'Editar Categoría' : 'Crear Categoría'"
                    @click="guardarCategoria"
                    :loading="deshabilitado"
                  >
                    <v-icon>
                      {{ esEditar ? "mdi-folder-edit" : " mdi-folder-plus" }}
                    </v-icon>
                  </v-btn>
                </v-card-actions>
              </v-card>
            </v-dialog>
          </v-toolbar>
        </template>
        <template v-slot:[`item.actions`]="{ item }">
          <v-btn
            small
            title="Editar categoría"
            @click="editarCategoria(item)"
            :loading="deshabilitado"
          >
            <v-icon small class="primary--text"> mdi-folder-edit </v-icon>
          </v-btn>
          <v-btn
            small
            class="ml-2"
            title="Eliminar categoría"
            @click="eliminarCategoria(item)"
            :loading="deshabilitado"
          >
            <v-icon small class="error--text"> mdi-delete-circle </v-icon>
          </v-btn>
        </template>
        <template v-slot:no-data>
          <v-btn
            color="teal dark-2 white--text my-3"
            @click="obtenerCategorias"
          >
            Categorías vacías. <v-icon>mdi-reload</v-icon>
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
  name: "Categoria",
  components: {
    Spinner,
  },
  data() {
    return {
      esEditar: false,
      busquedaCategoria: "",
      loading: false,
      deshabilitado: false,
      valorTablaCategoria: [
        {
          sortable: true,
        },
        { text: "#ID", value: "id" },
        { text: "Nombre", value: "nombre" },
        { text: "Fecha de modificación", value: "fecha" },
        { text: "Acciones", value: "actions", sortable: false },
      ],
      reglas: [(value) => !!value || "El campo es obligatorio."],
      categorias: [],
      categoria: {
        nombre: "",
      },
      modalCategoria: false,
      noEncontrado: "No se han encontrado categorías que coincidan con la búsqueda.",
    };
  },
  watch: {
    modalCategoria(valor) {
      valor || this.cerrarModal();
    },
  },
  methods: {
    async eliminarCategoria(categoria) {
      Swal.fire({
        title: "Eliminar categoría",
        text: `¿Estas seguro en eliminar la categoría ${categoria.nombre}? Al eliminar la categoría se borraran las noticias que pertenece.`,
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#f14545",
        cancelButtonColor: "#2196F3",
        cancelButtonText: "No, Cerrar modal",
        confirmButtonText: "Si, Eliminar",
      })
        .then(async (result) => {
          if (result.isConfirmed) {
            this.deshabilitado = true;
            const { data } = await this.axios.delete(
              `/eliminar-categoria/${categoria.id}`
            );
            this.mostrarAlerta("success", data.msg);
            this.categorias = this.categorias.filter(
              (cateogoria) => cateogoria.id !== categoria.id
            );
            this.deshabilitado = false;
          }
        })
        .catch((error) => {
          this.deshabilitado = false;
          this.mostrarAlerta("error", error.response.data.msg);
        });
    },
    guardarCategoria() {
      this.esEditar
        ? this.actualizarCategoria(this.categoria)
        : this.crearCategoria();
    },
    cerrarModal() {
      this.modalCategoria = false;
      this.$refs.form.resetValidation();
      this.esEditar = false;
      this.categoria = {
        nombre: "",
      };
    },
    async crearCategoria() {
      if (!this.categoria.nombre.length) {
        this.$refs.form.validate();
        return this.mostrarAlerta(
          "error",
          "Debes escribir el típo de categoría a registrar."
        );
      }
      try {
        this.deshabilitado = true;
        const { data } = await this.axios.post(
          "/crear-categoria",
          this.categoria
        );
        this.deshabilitado = false;
        this.mostrarAlerta("success", data.msg);
        this.obtenerCategorias();
        this.cerrarModal();
      } catch (error) {
        this.deshabilitado = false;
        this.mostrarAlerta("error", error.response.data.msg);
      }
    },
    async actualizarCategoria(categoriaDatos) {
      try {
        this.deshabilitado = true;
        categoriaDatos.fecha = new Date();
        const { data } = await this.axios.put(
          `actualizar-categoria/${categoriaDatos.id}`,
          categoriaDatos
        );
        this.mostrarAlerta("success", data.msg);
        this.deshabilitado = false;
        this.obtenerCategorias();
        this.cerrarModal();
      } catch (error) {
        this.deshabilitado = false;
        this.mostrarAlerta("error", error.response.data.msg);
      }
    },
    editarCategoria(categoriaDatos) {
      this.esEditar = true;
      Object.assign(this.categoria, categoriaDatos);
      this.modalCategoria = true;
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
    formatearFecha(datosCategorias) {
      return datosCategorias.map(({ id, nombre, fecha }) => {
        return {
          id,
          nombre,
          fecha: new Date(fecha).toLocaleString(),
        };
      });
    },
    async obtenerCategorias() {
      try {
        this.loading = true;
        const { data } = await this.axios.get("/obtener-categorias");
        this.categorias = this.formatearFecha(data);
        this.loading = false;
      } catch (error) {
        this.loading = false;
        this.mostrarAlerta("error", error.response.data.msg);
      }
    },
  },
  mounted() {
    this.obtenerCategorias();
  },
};
</script>

<style>
</style>