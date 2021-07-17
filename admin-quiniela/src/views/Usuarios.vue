<template>
  <v-app>
    <v-container>
      <div v-if="loading">
        <Spinner />
      </div>
      <v-container class="mt-5" v-else>
        <v-data-table
          :headers="datosUsuarios"
          :items="usuarios"
          :search="filtroUsuario"
          sort-by="id_rol"
          class="elevation-1"
          :no-results-text="usuarioNoEncontrado"
        >
          <template v-slot:top>
            <v-toolbar flat>
              <v-toolbar-title>Usuarios Administradores</v-toolbar-title>
              <v-divider class="mx-4" inset vertical></v-divider>
              <v-text-field
                class="text-md-center"
                v-model="filtroUsuario"
                append-icon="mdi-account-search"
                label="Buscar usuarios"
                single-line
                hide-details
              ></v-text-field>
              <v-spacer></v-spacer>
              <v-dialog v-model="modalUsuario" max-width="500px">
                <template v-slot:activator="{ on, attrs }">
                  <v-btn
                    color="cyan darken-2"
                    dark
                    small
                    :loading="deshabilitado"
                    class="mb-2"
                    v-bind="attrs"
                    v-on="on"
                  >
                    <v-icon> mdi-account-plus-outline</v-icon>
                  </v-btn>
                </template>
                <v-card>
                  <v-card-title>
                    <span class="text-h5">{{
                      editar ? "Editar Usuario" : "Crear Usuario"
                    }}</span>
                  </v-card-title>
                  <v-card-text>
                    <v-container>
                      <v-form ref="form">
                        <v-row>
                          <v-col cols="12">
                            <v-text-field
                              :loading="deshabilitado"
                              :rules="regla"
                              v-model.trim="usuario.nombre"
                              append-icon="mdi-format-text-variant"
                              label="Nombre de la persona administradora"
                            ></v-text-field>
                          </v-col>
                          <v-col cols="12">
                            <v-text-field
                              :loading="deshabilitado"
                              :rules="regla"
                              v-model.trim="usuario.usuario"
                              append-icon="mdi-account-lock-outline"
                              label="Usuario para ingresar"
                              hint="El usuarioes único."
                            ></v-text-field>
                          </v-col>
                          <v-col cols="12">
                             <v-autocomplete
                              :rules="regla"
                              :loading="deshabilitado"
                              v-model="usuario.id_rol"
                              append-icon="mdi-account-cog"
                              :items="selectRoles"
                              label="Seleccionar Rol"
                              placeholder="Seleccionar o buscar rol"
                              no-data-text="Rol no encontrado."
                              chips
                              :allow-overflow="false"
                            ></v-autocomplete>
                          </v-col>
                          <template v-if="!editar">
                          <v-col cols="12">
                            <v-text-field
                              :loading="deshabilitado"
                              :rules="reglaClave"
                              :type="botonClave.type"
                              v-model.trim="usuario.clave"
                              append-icon="mdi-lock"
                              label="Clave del usuario"
                              hint="La clave debe ser mayor a 6 caracteres."
                            ></v-text-field>
                          </v-col>
                            </template>
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
                    <template v-if="!editar">
                    <v-btn
                      :loading="deshabilitado"
                      medium
                      dark
                      :color="
                        botonClave.icono === 'mdi-eye' ? 'primary' : 'purple'
                      "
                      :title="
                        botonClave.type === 'text'
                          ? 'Ocultar clave'
                          : 'Ver clave'
                      "
                      @click="cambiarTypeIput"
                    >
                      <v-icon> {{ botonClave.icono }} </v-icon>
                    </v-btn>
                    </template>
                    <v-btn
                      :loading="deshabilitado"
                      color="teal"
                      dark
                      medium
                      :title="
                        !editar ? 'Agregar nuevo usuario' : 'Editar usuario'
                      "
                      @click="enviarFormulario"
                    >
                      <v-icon>{{
                        !editar ? "mdi-account-plus" : "mdi-account-edit"
                      }}</v-icon>
                    </v-btn>
                  </v-card-actions>
                </v-card>
              </v-dialog>
            </v-toolbar>
          </template>
          <template v-slot:[`item.actions`]="{ item }">
            <v-btn
              small
              color="primary"
              dark
              title="Editar Usuario"
              :loading="deshabilitado"
              @click="asignarDatosEditar(item)"
            >
              <v-icon>mdi-account-edit</v-icon>
            </v-btn>
            <v-btn
              dark
              small
              color="teal"
              class="ml-2"
              title="Cambiar Clave"
              @click="abriModalClave(item)"
              :loading="deshabilitado"
            >
              <v-icon>mdi-account-key</v-icon>
            </v-btn>
            <v-btn
              small
              color="error"
              class="ml-2"
              title="Eliminar Usuario"
              @click="eliminarUsuario(item)"
              :loading="deshabilitado"
            >
              <v-icon>mdi-account-off</v-icon>
            </v-btn>
          </template>
          <template v-slot:no-data>
            No existen usuarios registrados.
            <v-icon
              title="Recargar solicitudes"
              @click="obtenerUsuarios"
              class="error--text"
              >mdi-account-supervisor-circle-outline</v-icon
            >
          </template>
        </v-data-table>
      </v-container>
    </v-container>
    <ModalCambiarClave 
     :mostrarModal="mostrarModalClave"
      :usuarioID="usuario && usuario.id"
      @cerrar="cerraModalClave"
    />
  </v-app>
</template>

<script>
import Swal from "sweetalert2";
import Spinner from "@/components/Spinner.vue";
import ModalCambiarClave from '../components/ModalCambiarClave.vue';
export default {
  name: "Usuarios",
  components: {
    Spinner,
    ModalCambiarClave,
  },
  data() {
    return {
      mostrarModalClave:false,
      regla: [(value) => !!value || "El campo es obligatorio."],
      reglaClave: [
        (value) => !!value || "El campo es obligatorio.",
        (value) =>
           String(value)?.length >= 6 || "La clave debe ser minimo 6 carácteres.",
      ],
      usuarios: [],
      roles:[],
      selectRoles:[],
      usuario: {
        nombre: "",
        usuario: "",
        clave: "",
        id_rol:""
      },
      botonClave: {
        type: "password",
        icono: "mdi-eye",
      },
      editar: false,
      modalUsuario: false,
      loading: false,
      deshabilitado: false,
      filtroUsuario: "",
      usuarioNoEncontrado:
        "No se encontrarón usuarios relacionados con la busqueda.",
      datosUsuarios: [
        {
          sortable: false,
        },
        { text: "Nombre", value: "nombre" },
        { text: "Usuario de ingreso al admin", value: "usuario" },
        { text: "Rol", value: "id_rol" },
        { text: "Acciones", value: "actions", sortable: false },
      ],
    };
  },
  computed: {
    tituloForm() {
      return this.editar ? "Editar Autor" : "Crear Autor";
    },
  },
  watch: {
    modalUsuario(valor) {
      valor || this.cerraModal();
    },
  },
  created() {
    this.obtenerUsuarios();
    this.obtenerDatosRol()
  },
  methods: {
    asignarDatosEditar(datosAdmin){
      this.editar = true;
      this.usuario = Object.assign({},datosAdmin);
      this.modalUsuario = true;
    },
    async obtenerDatosRol(){
      try {
       const {data} = await this.axios.get('/obtener-roles');
       this.roles = data;
       this.selectRoles = data.map(rol=>rol.rol)
      } catch (error) {
        this.mostrarAlerta('error', error.response.data.msg)
      }
    },
    abriModalClave(usuarioInformacion){
      this.usuario = usuarioInformacion;
      this.mostrarModalClave = true
    },
    cerraModalClave(){
      this.mostrarModalClave = false;
      this.usuario = {
        nombre:"",
        usuario:"",
        clave:"",
         id_rol:""
      }
    },
    validarCampos() {
      if (
        !this.usuario.clave ||
        !this.usuario.usuario ||
        !this.usuario.nombre ||
        !this.usuario.clave.length ||
        !this.usuario.usuario.length ||
        !this.usuario.nombre.length ||
        !this.usuario.id_rol ||
        !this.usuario.id_rol.length
      ) {
        this.$refs.form.validate();
        return false;
      }
      return true;
    },
    async crearUsuario() {
      const esCorrecto = this.validarCampos();
      if (!esCorrecto) {
        return this.mostrarAlerta("error", "Debes completar todos los campos.");
      }
      if (this.usuario.clave.length < 6) {
        return this.mostrarAlerta(
          "error",
          "La clave debe ser minimo de 6 caracteres."
        );
      }
      try {
        const [idRolUsuario] = this.roles.filter(role=>role.rol === this.usuario.id_rol);
        const nuevoUsuario = JSON.parse(JSON.stringify(this.usuario))
        nuevoUsuario.id_rol = idRolUsuario.id
        this.deshabilitado = true;
        const { data } = await this.axios.post(
          "/registro-usuario",
         nuevoUsuario
        );
        this.mostrarAlerta("success", data.msg);
        this.cerraModal();
        this.deshabilitado = false;
        this.obtenerUsuarios();
      } catch (error) {
        this.deshabilitado = false;
        this.mostrarAlerta("error", error.response.data.msg);
      }
    },
    async actualizarUsuario(){
      if(!this.usuario.usuario || !this.usuario.nombre || !this.usuario.nombre.length || !this.usuario.usuario.length || !this.usuario.id_rol || !this.usuario.id_rol.length){
        this.mostrarAlerta('error', 'Debes completar todos los datos.')
        return this.$refs.form.validate();
      }
      try {
        const [idRolUsuario] = this.roles.filter(role=>role.rol === this.usuario.id_rol);
        const usuarioDatosActualizar = JSON.parse(JSON.stringify(this.usuario))
        usuarioDatosActualizar.id_rol = idRolUsuario.id
        this.deshabilitado = true;
        const {data} = await this.axios.put(`/actualizar-usuario/${this.usuario.id}`, usuarioDatosActualizar)
        this.mostrarAlerta('success', data.msg);
        this.obtenerUsuarios()
        this.cerraModal();
        this.deshabilitado = false
      } catch (error) {
          this.deshabilitado = false;
          this.mostrarAlerta('error', error.response.data.msg)
      }
    },
    enviarFormulario(){
      this.editar ? this.actualizarUsuario() : this.crearUsuario()
    },
    async obtenerUsuarios() {
      try {
        this.loading = true;
        const { data } = await this.axios.get("/obtener-usuarios");
        this.usuarios = data;
        this.loading = false;
      } catch (error) {
        this.loading = false;
        this.mostrarAlerta("error", error.response.data.msg);
      }
    },
    eliminarUsuario(informacionUsuario){
           Swal.fire({
        title: "Eliminar usuario",
        text: `¿Estas seguro en eliminar el usuario ${informacionUsuario.nombre}? Una vez eliminado no se podra recuperar.`,
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#f14545",
        cancelButtonColor: "#204e65",
        cancelButtonText: "No, cancelar",
        confirmButtonText: "Si, Eliminar",
      })
        .then(async (result) => {
          if (result.isConfirmed) {
            this.deshabilitado = true;
            const { data } = await this.axios.delete(
              `/eliminar-usuario/${informacionUsuario.id}`
            );
            this.mostrarAlerta("success", data.msg);
            this.usuarios = this.usuarios.filter(
              (usuario) => usuario.id !== informacionUsuario.id
            );
            this.deshabilitado = false;
          }
        })
        .catch((error) => {
          this.deshabilitado = false;
          this.mostrarAlerta("error", error.response.data.msg);
        });
    },
    cambiarTypeIput() {
      if (this.botonClave.type === "password") {
        this.botonClave.type = "text";
        this.botonClave.icono = "mdi-eye";
      } else {
        this.botonClave.type = "password";
        this.botonClave.icono = "mdi-eye-off";
      }
    },
    cerraModal() {
      this.modalUsuario = false;
      this.editar = false;
      this.$refs.form.resetValidation();
      this.usuario = {
        nombre: "",
        clave: "",
        usuario: "",
         id_rol:""
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
  },
};
</script>

<style>
</style>