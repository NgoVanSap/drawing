<template>
    <v-snackbar v-model="showSnackbar" :color="snackbarColor" :timeout="timeout">
      {{ message }}
      <template v-slot:action="{ attrs }">
        <v-btn color="white" text v-bind="attrs" @click="showSnackbar = false">Close</v-btn>
      </template>
    </v-snackbar>
  </template>
  
  <script>
  export default {
    props: {
      message: String,
      snackbarColor: String,
      timeout: Number
    },
    data() {
      return {
        showSnackbar: false
      };
    }
  };
  </script>
  