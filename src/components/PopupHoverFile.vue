<template>
<div class="main" :style="{top: y + 'px', left: x + 'px'}">{{ name }}</div>
</template>

<script>
export default {
    name: 'popup-hover-file',
    props: {
        x: {
            type: Number,
            required: true,
            default: 0
        },
        y: {
            type: Number,
            required: true,
            default: 0
        },
        name: {
            type: String,
            required: true,
            default: ''
        }
    },
    data() {
        return {

        }
    },
    methods: {

    },
    watch: {
        
    },
}
</script>

<style scoped>
.main {
    z-index: 1000;
    position: fixed;
    overflow: hidden;
    white-space: nowrap;
    font-family: sans-serif;
    background: #FFF;
    color: #333;
    border-radius: 5px;
    padding: 10px;
    margin: 0px;
    border: 1px solid lightgray;
    box-shadow: 1px 1px 1px rgba(0, 0, 0, 0.3);
}
</style>
