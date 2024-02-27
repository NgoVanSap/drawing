<template>
    <div>
      <!-- <h1>.sss</h1> -->
    </div>
  </template>
  
  <script>
  import axios from 'axios';
  export default {
    data() {
      return {
        files: [],
        progress: null,
      };
    },
    methods: {
      handleFileChange(event) {
        this.files = Array.from(event.target.files);
      },
      async uploadFiles() {
        const totalFiles = this.files.length;
  
        for (let i = 0; i < totalFiles; i++) {
          const file = this.files[i];
          await this.uploadFile(file, totalFiles, i);
        }
  
        // Clear selected files after upload
        this.files = [];
      },
      async uploadFile(file, totalFiles, currentFileIndex) {
        return new Promise((resolve, reject) => {
          const chunkSize = 1024 * 1024; // 1MB
          const totalChunks = Math.ceil(file.size / chunkSize);
          let currentChunk = 0;
  
          const fileReader = new FileReader();
  
          fileReader.onloadend = async () => {
            const chunk = fileReader.result;
  
            // Simulate file upload delay (remove this in production)
            await new Promise((resolve) => setTimeout(resolve, 1000));
  
            // TODO: Send chunk to server using axios or fetch API
            // Replace the placeholder URL with your API endpoint
            const uploadUrl = this.$globalVariable.URL_API + "/api/FileUpload/upload/";
            const formData = new FormData();
            formData.append("file", chunk);
            formData.append("totalFiles", totalFiles);
            formData.append("currentFileIndex", currentFileIndex);
            formData.append("totalChunks", totalChunks);
            formData.append("currentChunk", currentChunk);
            formData.append("fileName", 'ABC');
  
            // TODO: Make a POST request to the server
            // Example using axios:
            axios.post(uploadUrl, formData)
              .then(response => {
                // Handle the response from the server
                // Update progress if necessary
                console.log(response.data);
                currentChunk++;
                this.progress = Math.round((currentChunk / totalChunks) * 100);
                resolve();
              })
              .catch(error => {
                // Handle the error
                reject(error);
              });
  
            // Placeholder code to simulate progress update (remove this in production)
            currentChunk++;
            this.progress = Math.round((currentChunk / totalChunks) * 100);
  
            // Resolve the promise after successful upload
            resolve();
          };
  
          fileReader.readAsArrayBuffer(file);
        });
      },
    },
  };
  </script>