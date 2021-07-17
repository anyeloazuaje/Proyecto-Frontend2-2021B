<template>
  <v-app>
    <div v-if="loading">
      <spinner />
    </div>
    <section v-else>
      <v-container>
        <v-row class="flex align-center justify-space-between">
          <v-col class="justify-end" cols="12 text-center" sm="4">
            <v-btn fab @click="$router.go(-1)" color="teal darken-1 " medium>
              <v-icon medium class="white--text">
                mdi-arrow-left-circle
              </v-icon>
            </v-btn>
          </v-col>
          <v-col class="justify-start" cols="12 text-center" sm="4"> </v-col>
        </v-row>
      </v-container>
      <section class="mt-8 mb-3">
        <v-container fluid>
          <v-row align="center" justify="center">
            <v-col cols="10">
              <v-row justify="center">
                <v-col cols="10" sm="12" md="6">
                  <v-card class="padding">
                    <v-form
                      class="p-5"
                      ref="form"
                      @submit.prevent="actualizarNoticia"
                    >
                      <v-text-field
                        append-icon="mdi-format-title"
                        :loading="deshabilitado"
                        v-model.trim="noticia.titulo"
                        :rules="reglaTitulo"
                        label="Titulo de la noticia"
                        required
                      ></v-text-field>
                      <v-autocomplete
                         append-icon="mdi-folder"
                        :loading="deshabilitado"
                        :rules="reglas"
                        v-model="noticia.categoria"
                        :items="selectCategorias"
                        label="Categoría de la noticia"
                        placeholder="Seleccionar o buscar categoría"
                        no-data-text="Categoría no encontrada."
                        chips
                        :allow-overflow="false"
                      ></v-autocomplete>
                      <v-text-field
                        :loading="deshabilitado"
                        append-icon="mdi-image-size-select-actual"
                        v-model.trim="noticia.url_imagen"
                        :rules="reglas"
                        type="url"
                        label="Enlace de la imagen"
                        required
                        hint="El enlace debe ser https://enlaceimagen.com"
                      ></v-text-field>
                      <v-select
                        :rules="reglas"
                        v-model="noticia.autor"
                        :items="selectAutores"
                         append-icon="mdi-account-details-outline"
                        :loading="deshabilitado"
                        label="Autor de la noticia"
                        placeholder="Seleccionar autor"
                        no-data-text="Este autor no existe."
                        :allow-overflow="false"
                      ></v-select>
                      <v-textarea
                        outlined
                        clearable
                        clear-icon="mdi-close-circle"
                        value="Elimina la descricpción de la noticia."
                        counter
                        append-icon="mdi-newspaper-variant"
                        auto-grow
                        rows="4"
                        :rules="reglasDescripcion"
                        label="Descripción de la noticia"
                        v-model.trim="noticia.descripcion"
                        required
                      />
                      <div
                        v-if="noticia.url_imagen && noticia.url_imagen.length"
                        class="text-center"
                      >
                        <img
                          :src="noticia.url_imagen"
                          class="imagen-formulario"
                          alt="imagen-noticia"
                        />
                      </div>
                      <v-btn
                        :loading="deshabilitado"
                        type="submit"
                        rounded
                        block
                        dark
                        class="mt-3"
                        color="primary"
                      >
                        Actualizar noticia <v-icon>mdi-reload</v-icon>
                      </v-btn>
                    </v-form>
                  </v-card>
                </v-col>
              </v-row>
            </v-col>
          </v-row>
        </v-container>
      </section>
    </section>
  </v-app>
</template>

<script>
import Spinner from "@/components/Spinner.vue";
import Swal from "sweetalert2";
export default {
  components: { Spinner },
  name: "NoticiaEditar",
  data() {
    return {
      deshabilitado: false,
      loading: false,
      reglas: [(value) => !!value || "El campo es obligatorio."],
      reglasDescripcion: [
        (value) => !!value || "El campo es obligatorio.",
        (value) =>
          String(value)?.length <= 2000 ||
          "La descripción no debe ser mayor a 2000 carácteres.",
      ],
      reglaTitulo: [
        (value) => !!value || "El campo es obligatorio.",
        (value) =>
          value.length <= 50 ||
          "La descripción no debe ser mayor a 50 carácteres.",
      ],
      categorias: [],
      autores: [],
      selectAutores: [],
      selectCategorias: [],
      noticia: {
        titulo: "",
        autor: "",
        categoria: "",
        url_imagen: "",
        descripcion: "",
      },
    };
  },
  created() {
    this.obtenerDatosNoticia();
  },
  methods: {
    async obtenerDatosNoticia() {
      await Promise.all([
        this.obtenerAutores(),
        this.obtenerCategorias(),
        this.obtenerNoticia(),
      ]);
    },
    async obtenerNoticia() {
      try {
        this.loading = true;
        const { data } = await this.axios.get(
          `/obtener-noticia/${this.$route.params.noticiaID}`
        );
        const [datosNoticia] = data;
        const objetoNoticia = {
          id: datosNoticia.id,
          titulo: datosNoticia.titulo,
          descripcion: datosNoticia.descripcion,
          autor: datosNoticia.id_autor,
          categoria: datosNoticia.id_categoria,
          url_imagen: datosNoticia.url_imagen,
        };
        this.noticia = objetoNoticia;
        this.loading = false;
      } catch (error) {
        this.loading = false;
        this.mostrarAlerta("error", error.response.data.msg);
        setTimeout(() => {
          this.$router.push("/noticia");
        }, 2000);
      }
    },
    async actualizarNoticia() {
      if (
        !this.noticia.titulo.length ||
        !this.noticia.url_imagen.length ||
        !this.noticia.descripcion.length ||
        !this.noticia.categoria.length ||
        !this.noticia.categoria ||
        !this.noticia.autor.length ||
        !this.noticia.autor
      ) {
        this.$refs.form.validate();
        return this.mostrarAlerta(
          "error",
          "Todos los campos son obligatorios para crear una noticia."
        );
      }
      if (this.noticia.titulo.length > 50) {
        return this.mostrarAlerta(
          "error",
          "El titulo no puede ser mayor a 50 carácteres. "
        );
      }
      if (this.noticia.descripcion.length > 2000) {
        return this.mostrarAlerta(
          "error",
          "La descripción no puede ser mayor a 2000 carácteres. "
        );
      }
      const [autorSeleccionado] = this.autores.filter(
        (autor) => autor.nombre === this.noticia.autor
      );
      const [categoriaSeleccionada] = this.categorias.filter(
        (categoria) => categoria.nombre === this.noticia.categoria
      );
      const noticiaActualizar = JSON.parse(JSON.stringify(this.noticia));
      noticiaActualizar.id_autor = autorSeleccionado.id;
      noticiaActualizar.id_categoria = categoriaSeleccionada.id;
      try {
        this.deshabilitado = true;
        const { data } = await this.axios.put(
          `/actualizar-noticia/${this.$route.params.noticiaID}`,
          noticiaActualizar
        );
        this.mostrarAlerta("success", data.msg);
        this.$refs.form.resetValidation();
        this.noticia = {
          titulo: "",
          autor: "",
          categoria: "",
          url_imagen: "",
          descripcion: "",
        };
        this.deshabilitado = false;
        setTimeout(() => {
          this.$router.push("/noticia");
        }, 1500);
      } catch (error) {
        this.mostrarAlerta("error", error.response.data.msg);
        this.deshabilitado = false;
      }
    },
    async obtenerAutores() {
      try {
        this.loading = true;
        const { data } = await this.axios.get("/obtener-autores");
        this.autores = data;
        this.selectAutores = data.map((autor) => autor.nombre);
        this.loading = false;
      } catch (error) {
        this.mostrarAlerta("error", error.response.data.msg);
        this.loading = false;
      }
    },
    async obtenerCategorias() {
      try {
        this.loading = true;
        const { data } = await this.axios.get("/obtener-categorias");
        this.categorias = data;
        const categoriaSelect = data.map((categoria) => categoria.nombre);
        this.selectCategorias = categoriaSelect;
        this.loading = false;
      } catch (error) {
        this.mostrarAlerta("error", error.response.data.msg);
        this.loading = false;
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
  },
};
</script>

