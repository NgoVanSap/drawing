<template>
    <div class="parent">
        <header>Tao thu muc moi</header>
        <input type="text" class="input" ref="inputValue">
        <button class="my-button" >Close</button>
        <footer>
            <button class="my-button" @click="ActionCreate()">Tao</button>
            <button class="my-button" @click="ActionCancel()">Huy bo</button>
        </footer>
    </div>
</template>

<script>
import axios from 'axios';
export default{
    name: "AddNewFolder",
    data(){
        
    },
    methods:{
        ActionCreate() {
            const name = this.$refs.inputValue.value;
            console.log("Click Create Directory at ComponentAddNewFolder: ", name);
            if(name === "")
            {
                console.log("Warning: Please input name of the folder");
            }else{
                const path = 'c:\\Users\\KTV_QSP\\Downloads\\' + name;
                console.log("path: ", path);
                const apiUrl = this.$globalVariable.URL_API + '/WeatherForecast/create_directory/';
                axios.get(apiUrl, {
                params: {
                    path: path
                }
                }).then(response => {
                    console.log(response.data);
                }).catch(error => {
                    console.error(error);
                })
            }
        },
        ActionCancel() {
            console.log("Click Clear Directory at ComponentAddNewFolder");
            this.$refs.inputValue.value = '';
        }
    },
    beforeCreate(){
      console.log('[Lift circle - ComponentAddNewFolder] beforeCreate');
    },
    created() {
      console.log('[Lift circle - ComponentAddNewFolder] created');
    },
    beforeMount() {
      console.log('[Lift circle - ComponentAddNewFolder] beforeMount');
    },
    mounted() {
      console.log('[Lift circle - ComponentAddNewFolder] mounted');
    },
    beforeUpdate() {
      console.log('[Lift circle - ComponentAddNewFolder] beforeUpdate');
    },
    updated() {
      console.log('[Lift circle - ComponentAddNewFolder] updated');
    },
    beforeUnmount() {
      console.log('[Lift circle - ComponentAddNewFolder] beforeUnmount');
    },
    Unmounted() {
      console.log('[Lift circle - ComponentAddNewFolder] Unmounted');
    }
}
</script>

<style scoped>
.parent{
    border: 1px solid grey;
    width: 500px;
    height: 150px;
    border-radius: 5px;
}

.parent input{
    border: 1px solid #ccc;
    width: 200px;
    height: 15px;
    border-radius: 5px;
    padding: 10px;
    font-size: 16px;
    color: #333;
}

.parent input:focus{
    outline: none;
    border-color: #4caf50;
    box-shadow: 0 0 4px #4caf50;
}

.parent .my-button{
    margin-top: 10px;
    margin-right: 20px;
    margin-left: 10px;
    display: inline-block;
    padding: 10px 20px;
    font-size: 16px;
    font-weight: bold;
    text-align: center;
    text-decoration: none;
    border: none;
    border-radius: 4px;
    color: #FFF;
    background-color: #4caf50;
    cursor: pointer;
}

.parent .my-button:hover{
    background-color: #45a049;
}

.parent .my-button:focus{
    outline: none;
    box-shadow: 0 0 4px #4caf50;
}
</style>