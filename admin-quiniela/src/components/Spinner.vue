<template>
  <v-container>
    <v-row align="center" justify="center">
      <v-col cols="8" class="text-center mt-15">
        <v-progress-circular
          :size="50"
          :width="4"
          color="primary"
          indeterminate
        ></v-progress-circular>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
export default {
  name: "Spinner",
};
</script>

<style>
</style>