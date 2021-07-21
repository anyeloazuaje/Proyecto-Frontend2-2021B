<template>
  <div>
    <Hero />
    <UltimasNoticias />
    <EquiposPrincipales />
    <ApuestasAcertadasInicio />
    <SeccionContacto />
  </div>
</template>

<script>
import Hero from "@/components/Hero.vue";
import UltimasNoticias from "@/components/UltimasNoticias.vue";
import EquiposPrincipales from "@/components/EquiposPrincipales.vue";
import SeccionContacto from "@/components/SeccionContacto.vue";
import ApuestasAcertadasInicio from "@/components/ApuestasAcertadasInicio.vue";
export default {
  name: "Home",
  components: {
    Hero,
    UltimasNoticias,
    EquiposPrincipales,
    SeccionContacto,
    ApuestasAcertadasInicio
  },
};
</script>

