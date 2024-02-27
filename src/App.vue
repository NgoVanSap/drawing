<template>
  <ComponentMain/>
</template>

<script>
import ComponentMain from './components/ComponentMain.vue'

export default {
  name: 'App',
  components: {
    ComponentMain,
  }
}
</script>

<style>
@font-face {
  font-family: 'Poppins';
  src: url('@/assets//fonts/Poppins/Poppins-Regular.ttf') format('truetype');
}
#app {
  font-family: 'Poppins', sans-serif;
  /* -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50; */
}
</style>
