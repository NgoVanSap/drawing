<template>
<div v-if="isActiveFormVerify" class="main-active-user">
    <div class="content">
        <header>
            <div class="header">
                <div class="title">Active</div>
                <div class="icon"><i class="fas fa-times close-icon" @click="HandleCancel"></i></div>
            </div>
        </header>
        <div class="settings">
            <div class="message">
                <p>{{ $t('messagesChangeStatusUser') }} {{ userid }}?</p>
            </div>
        </div>
        <div class="option">
            <v-btn class="button" @click="handleConfirm" style="font-family: 'Poppins', sans-serif">Yes</v-btn>
            <v-btn class="button" @click="HandleCancel" style="font-family: 'Poppins', sans-serif">No</v-btn>
        </div>
    </div>
</div>
</template>

    
<script>
export default {
    components: {

    },
    props: {
        isActiveFormVerify: {
            type: Boolean,
            required: true,
            default: false
        },
        userid: {
            type: String,
            required: true,
            default: ""
        }
    },
    data() {
        return {

        }
    },
    methods: {
        HandleCancel() {
            this.$emit("signalHandleCancel");
        },
        handleConfirm() {
            this.$emit("signalHandleConfirm");
        }
    },
    computed: {

    },
    watch: {
        
    }
}
</script>

    
<style scoped>
@import '@mdi/font/css/materialdesignicons.min.css';

.main-active-user {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.1);
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 9999;
}

.content {
    position: relative;
    font-family: Arial, Helvetica, sans-serif;
    background-color: #fff;
    padding: 0px;
    border-radius: 4px;
    width: 33%;
    height: 10%;
    min-height: 180px;
}

.header {
    display: flex;
    height: 50px;
    width: 100%;
    justify-content: space-between;
    align-items: center;
    vertical-align: middle;
    background-color: #01579B;
    padding-right: 5px;
    color: #fff;
}

.title {
    border-radius: 5px;
    font-weight: bold;
    padding-left: 10px;
    border: none;
    text-align: left;
    width: 78%;
}

.icon {
    text-align: right;
    cursor: pointer;
    margin-right: 10px;
    color: #fff;
    width: 18%;
}

.icon i {
    font-size: 20px;
    color: #fff;
}

.icon i:hover {
    font-size: 20px;
    color: #000;
}

.settings {
    position: relative;
    align-items: center;
    border: none;
    width: 100%;
    height: calc(100% - 120px);
    justify-content: center;
}

.message {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100%;
    border: none;
}

p {
    font-size: 17px;
    padding-top: 20px;
    text-align: center;
}

.option {
    display: flex;
    height: 70px;
    width: 100%;
    justify-content: flex-end;
    padding-right: 5px;
    color: #fff;
    padding-top: 10px;
    padding-bottom: 20px;
    border: none;
}

.button {
    margin-right: 20px;
}
</style>
