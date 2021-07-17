<template>
  <div>
    <v-navigation-drawer
      class="blue darken-3 "
      dark
      v-model="sidebar"
      app
      temporary
    >
      <v-list>
        <v-list-item>
          <v-list-item-avatar>
            <v-img :src="imagenSidebar"></v-img>
          </v-list-item-avatar>

          <v-list-item-content>
            <v-list-item-title>{{ obtenerNombreAdmin }}</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
        <v-divider></v-divider>
        <template v-if="esAdmin">
        <v-list-item v-for="item in items" :key="item.titulo" link>
          <v-list-item-icon>
            <v-icon>{{ item.icono }}</v-icon>
          </v-list-item-icon>
          <v-list-item-content>
            <v-list-item-title @click="$router.push(item.ruta)">{{ item.titulo }}</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
        </template>
        <template v-else>
            <v-list-item v-for="item in itemsObservador" :key="item.titulo" link>
          <v-list-item-icon>
            <v-icon>{{ item.icono }}</v-icon>
          </v-list-item-icon>
          <v-list-item-content>
            <v-list-item-title @click="$router.push(item.ruta)">{{ item.titulo }}</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
        </template>
      </v-list>

      <template v-slot:append>
        <div class="pa-2">
          <v-btn block class="red lighten-1" @click="logout"> Cerrar Sesión <v-icon>mdi-logout-variant</v-icon> </v-btn>
        </div>
      </template>
    </v-navigation-drawer>

    <v-app-bar app color="primary" dark class="px-5">
      <v-app-bar-nav-icon @click="sidebar = !sidebar"></v-app-bar-nav-icon>

      <v-toolbar-title>Bienvenido {{ obtenerNombreAdmin }}</v-toolbar-title>

      <v-spacer></v-spacer>

      <v-btn icon @click="logout" title="Cerrar Sesión">
        <v-icon>mdi-export</v-icon>
      </v-btn>
    </v-app-bar>
  </div>
</template>

<script>
export default {
  name: "Sidebar",
  data() {
    return {
      sidebar: false,
      items: [
        { titulo: "Clientes", icono: "mdi-account-multiple", ruta:"/" },
        { titulo: "Autores", icono: "mdi-account-edit", ruta:"/autor" },
        { titulo: "Categorias", icono: "mdi-bookmark-multiple" , ruta:"/categoria"},
        { titulo: "Noticias", icono: "mdi-earth" , ruta:"/noticia"},
        { titulo: "Equipos", icono: "mdi-account-group" , ruta:"/equipo"},
        { titulo: "Apuestas", icono: "mdi-trophy" , ruta:"/apuesta"},
        { titulo: "Apuestas del cliente", icono: "mdi-medal-outline" , ruta:"/apuesta-cliente"},
        { titulo: "Seguimientos", icono: "mdi-account-heart" , ruta:"/seguimiento"},
        { titulo: "Recargas", icono: "mdi-currency-usd" , ruta:"/solicitud-recargas"},
        { titulo: "Contactos", icono: "mdi-forum" , ruta:"/contacto"},
        { titulo: "Usuarios", icono: "mdi-shield-account-outline" , ruta:"/usuarios"},
      ],
      itemsObservador:[
        { titulo: "Clientes", icono: "mdi-account-multiple", ruta:"/" },
        { titulo: "Apuestas del cliente", icono: "mdi-medal-outline" , ruta:"/apuesta-cliente"},
        { titulo: "Noticias", icono: "mdi-earth" , ruta:"/noticia"},
        { titulo: "Seguimientos", icono: "mdi-account-heart" , ruta:"/seguimiento"},
        { titulo: "Contactos", icono: "mdi-forum" , ruta:"/contacto"},
         { titulo: "Equipos", icono: "mdi-account-group" , ruta:"/equipo"},
        { titulo: "Apuestas", icono: "mdi-trophy" , ruta:"/apuesta"},
      ]
    };
  },
  computed: {
    obtenerNombreAdmin() {
      return this.$store.getters.nombreAdmin;
    },
    esAdmin() {
      return this.$store.getters.esAdmin;
    },
    imagenSidebar(){
      return this.esAdmin ? require("@/assets/img/admin.png") : require("@/assets/img/observador.png")
    }
  },
  methods: {
    logout() {
      this.$store.dispatch("logout");
    },
  },
};
</script>

<style>
.v-toolbar {
  transition: 0.6s;
}
</style>