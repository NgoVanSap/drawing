<template>
    <div class="parent">
        <header>Tai file len</header>
        <div >
            <input type="file" ref="fileInput" multiple @change="handleFileChange" />
        </div>
        <button @click="uploadFiles">Upload</button>
        <br>
        <div class="div-progress-bar" v-if="isShowProgressBar">
            <div class="div-progress"></div>
            <div class="progress-text">Rev6_slim_approach_06.2023.pdf</div>
            <span class="close-icon" @click="CloseProgressBar">&times;</span>
        </div>
        <div class="div-progress-bar">
            <div class="div-progress"></div>
            <div class="progress-text">Rev6_slim_approach_06.2022.pdf</div>
            <span class="close-icon" @click="CloseProgressBar">&times;</span>
        </div>
        <div class="div-progress-bar">
            <div class="div-progress"></div>
            <div class="progress-text">Rev6_slim_approach_06.2022.pdf</div>
            <span class="close-icon" @click="CloseProgressBar">&times;</span>
        </div>
        <div class="div-progress-bar">
            <div class="div-progress"></div>
            <div class="progress-text">Rev6_slim_approach_06.2022.pdf</div>
            <span class="close-icon" @click="CloseProgressBar">&times;</span>
        </div>
        <div class="div-progress-bar">
            <div class="div-progress"></div>
            <div class="progress-text">Rev6_slim_approach_06.2022.pdf</div>
            <span class="close-icon" @click="CloseProgressBar">&times;</span>
        </div>
        <div>
            <h4>Name = {{ this.name }}</h4>
            <h4>Age = {{ this.age }}</h4>
        </div>
        <button @click="sendDataToParent">Send Emit</button>
    </div>
</template>

<script>
import axios from 'axios';
export default{
    name: "AddNewFile",
    props: {
        name: {
            type: String,
            required: true,
            default: ''
        },
        age: {
            type: Number,
            required: true,
            default: 0
        }
    },
    data(){
        return {
            selectedFiles: [],
            isShowProgressBar: true,
            percentProgressBar: 0,
            dataEmit: 'Test send emit ACD'
        }
    },
    methods:{
        sendDataToParent() {
            console.log("Click send emit")
            this.$emit('eventName', this.dataEmit);
        },
        handleFileChange(event) {
            console.log("Click Choose Files");
            this.selectedFiles = Array.from(event.target.files);
        },
        uploadFiles() {
            console.log("Click button Upload");
            if(!this.selectedFiles){
                console.log("List file empty");
                return;
            }
            this.isShowProgressBar = true;
            const formData = new FormData();
            this.selectedFiles.forEach(file => {
                formData.append('files', file);

                const fileURL = URL.createObjectURL(file);
                console.log("File: ", file.name);
                console.log("Size: ", file.size/1024, "KB");
                console.log("Type: ", file.type);
                console.log("fileURL: ", fileURL);
                console.log("lastModified: ", file.lastModified);
                console.log("lastModifiedDate: ", file.lastModifiedDate);
            });

            axios.post(this.$globalVariable.URL_API + '/Files/upload_file/', formData, {
                onUploadProgress: ProgressEvent => {
                    this.percentProgressBar = Math.round((ProgressEvent.loaded / ProgressEvent.total)*100);
                }
            }).then(response => {
            console.log(response.data);
          }).catch(error => {
            console.error(error);
          }).finally(() => {
            this.isShowProgressBar = false;
            this.percentProgressBar = 0;
          })
        },
        CloseProgressBar() {
            console.log("Close progress bar");
            this.isShowProgressBar = false;
        }
    },
    beforeCreate(){
      console.log('[Lift circle - ComponentAddNewFile] beforeCreate');
    },
    created() {
      console.log('[Lift circle - ComponentAddNewFile] created');
    },
    beforeMount() {
      console.log('[Lift circle - ComponentAddNewFile] beforeMount');
    },
    mounted() {
      console.log('[Lift circle - ComponentAddNewFile] mounted');
    },
    beforeUpdate() {
      console.log('[Lift circle - ComponentAddNewFile] beforeUpdate');
    },
    updated() {
      console.log('[Lift circle - ComponentAddNewFile] updated');
    },
    beforeUnmount() {
      console.log('[Lift circle - ComponentAddNewFile] beforeUnmount');
    },
    Unmounted() {
      console.log('[Lift circle - ComponentAddNewFile] Unmounted');
    }
}
</script>

<style scoped>
.parent{
    border: 1px solid grey;
    width: 500px;
    height: 400px;
    border-radius: 5px;
}
.parent .progress-bar{
    margin-top: 10px;
    width: 400px;
    background-color: #FFF;
    height: 30px;
    border-radius: 20px;
    overflow: hidden;
}

.parent .div-progress-bar{
    margin-left: 20px;
    margin-top: 10px;
    width: 400px;
    background-color: grey;
    height: 30px;
    border-radius: 15px;
    overflow: hidden;
    position: relative;
}

.parent .div-progress-bar .div-progress{
    background-color: #4caf50;
    height: 100%;
    width: 80%;
    transform: width 0.5 ease-in-out;
}

.parent .div-progress-bar .progress-text{
    position: absolute;
    top: 0;
    left: 40%;
    transform: translateX(-50%);
    line-height: 20px;
    color: #FFF;
    padding-top: 5px;;
}

.parent .div-progress-bar .close-icon{
    position: absolute;
    top: 50%;
    right: 13px;
    transform: translateY(-50%);
    font-size: 16px;
    color: #FFF;
    font-weight: bold;
    cursor: pointer;
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

/* CSS Chon file */
.parent .file-input{
    position: relative;
    display: inline-block;
}

.parent .file-input .file{
    opacity: 0;
    position: absolute;
    left: 0;
    top: 0;
}

.parent .file-input .file-label{
    display: inline-block;
    padding: 10px 20px;
    font-size: 16px;
    font-weight: bold;
    text-align: center;
    border: none;
    border-radius: 4px;
    color: #FFFFFF;
    background-color: #4caf50;
    cursor: pointer;
}

.parent .file-input .file-label:hover{
    background-color: #45a049;
}


</style>