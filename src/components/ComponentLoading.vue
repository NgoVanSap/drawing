<template>
<div v-if="isActiveComponent" class="main_ui">
    <div class="main_content">
        <div class="icon_loading"></div>
    </div>
</div>
</template>

<script>
export default {
    name: 'component-loading',
    components: {

    },
    props: {
        isActiveComponent: {
            type: Boolean,
            request: true,
            default: false
        }
    },
    data() {
        return {

        }
    },
    methods: {

    },
    computed: {

    },
    watch: {

    }
}
</script>

<style scoped>
.main_ui {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.5);
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 9999;
}

.main_content {
    font-family: Arial, Helvetica, sans-serif;
    background-color: #00000000;
    width: 100px;
    height: 100px;
}

.icon_loading {
    width: 100%;
    height: 100%;
    border: 1px solid none;
    background: transparent;
    color: #333;
    background-image: url('../assets/images/loading.gif');
    background-size: 100px;
    background-repeat: no-repeat;
    background-color: rgba(0, 0, 0, 0);
}
</style>
