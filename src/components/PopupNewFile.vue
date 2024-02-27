<template>
  <div v-if="isOpenPopup" class="popup-component">
    <div class="popup-content">
      <header>
        <div class="header">
          <div class="title">{{ $t("UploadFile") }}</div>
          <div class="icon">
            <i class="fas fa-times close-icon" @click="HandleCancel"></i>
          </div>
        </div>
      </header>
      <div class="content">
        <label class="custom-label" for="file-input">Choose Files</label>
        <input
          class="custom-input"
          type="file"
          id="file-input"
          multiple
          @change="handleFileChange"
        />
        <label class="custom-text"
          >{{ this.listFiles.length }} {{ $t("FileSelected") }}</label
        >
      </div>
      <div class="tab-table">
        <table class="custom-table" v-bind:class="{ disabled: this.isDisabledTable }">
          <thead>
            <tr>
              <th class="fix-header th-title">{{ $t("Title") }}</th>
              <th class="fix-header th-action">{{ $t("Delete") }}</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="file in listFiles" :key="file.id">
              <td class="td-title">{{ file.name }}</td>
              <td class="td-action">
                <div class="icon-action">
                  <i class="fas fa-times close-icon" @click="HandleDelete(file.id)"></i>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="action">
        <div class="progress-bar" v-if="isProgressBar">
          <div class="progress" :style="{ width: progressPercent + '%' }"></div>
        </div>
        <button class="cancel" @click="HandleCancel">{{ $t("Cancel") }}</button>
        <button class="confirm" @click="HandleConfirm" :disabled="isDisabledUpload">
          {{ $t("Upload") }}
        </button>
      </div>
    </div>
  </div>
  <button
    v-if="this.$globalVariable.USER_INFO.admin == 1"
    @click="HandleOpenPopup"
    class="open-popup"
  >
    <i class="icon-open-popup"></i>{{ $t("Add") }}
  </button>
</template>

<script>
import axios from "axios";
export default {
  props: {
    currentPath: {
      type: String,
      default: "",
    },
  },
  data() {
    return {
      isOpenPopup: false,
      listFiles: [],
      selectedFiles: [],
      isDisabledUpload: false,
      isDisabledTable: false,
      isProgressBar: false,
      progressPercent: 10,
    };
  },
  methods: {
    HandleDelete(id) {
      console.log("HandleDelete: ", id);
      var index = -1;
      for (let i = 0; i < this.listFiles.length; i++) {
        if (this.listFiles[i].id == id) {
          index = i;
        }
      }
      if (index != -1) {
        this.listFiles.splice(index, 1);
      } else {
        console.log("Not found index");
      }
      if (this.listFiles.length > 0) {
        this.isDisabledUpload = false;
      } else {
        this.isDisabledUpload = true;
      }
    },
    handleFileChange(event) {
      this.selectedFiles = Array.from(event.target.files);
      console.log("selectedFiles: ", this.selectedFiles.length);

      this.listFiles = [];
      var id = 0;
      this.selectedFiles.forEach((file) => {
        const fileURL = URL.createObjectURL(file);
        console.log("File: ", file.name);
        console.log("Size: ", file.size / 1024, "KB");
        console.log("Type: ", file.type);
        console.log("fileURL: ", fileURL);
        console.log("lastModified: ", file.lastModified);
        console.log("lastModifiedDate: ", file.lastModifiedDate);
        var dataFile = {
          id: id++,
          name: file.name,
          size: file.size,
          type: file.type,
          fileURL: fileURL,
          lastModified: file.lastModified,
          lastModifiedDate: file.lastModifiedDate,
        };
        this.listFiles.push(dataFile);
        if (this.listFiles.length > 0) {
          this.isDisabledUpload = false;
        } else {
          this.isDisabledUpload = true;
        }
      });
    },
    HandleOpenPopup() {
      this.isOpenPopup = true;
      this.isDisabledUpload = true;
      this.listFiles = [];
      this.isDisabledTable = false;
      this.isProgressBar = false;
      this.progressPercent = 0;
    },
    HandleConfirm() {
      if (this.selectedFiles.length <= 0) {
        console.log("Warning: Please choose a file");
      } else {
        console.log("Uploading to ", this.currentPath);
        this.isDisabledTable = true;
        this.isDisabledUpload = true;
        this.isProgressBar = true;
        this.progressPercent = 0;

        const formData = new FormData();
        this.selectedFiles.forEach((file) => {
          formData.append("files", file);
          const fileURL = URL.createObjectURL(file);
          console.log("File: ", file.name);
          console.log("Size: ", file.size / 1024, "KB");
          console.log("Type: ", file.type);
          console.log("fileURL: ", fileURL);
          console.log("lastModified: ", file.lastModified);
          console.log("lastModifiedDate: ", file.lastModifiedDate);
        });
        formData.append("argument", this.currentPath);

        const maxFileSizeInBytes = 100 * 1024 * 1024;
        axios.defaults.maxContentLength = maxFileSizeInBytes;

        console.log("formData: ", formData);
        axios
          .post(this.$globalVariable.URL_API + "/Files/upload_file_v1/", formData, {
            headers: {
              "Content-Type": "multipart/form-data",
            },
            onUploadProgress: (ProgressEvent) => {
              this.progressPercent = Math.round(
                (ProgressEvent.loaded / ProgressEvent.total) * 100
              );
            },
          })
          .then((response) => {
            console.log(response.data);
          })
          .catch((error) => {
            console.error(error);
          })
          .finally(() => {
            this.isProgressBar = false;
            this.progressPercent = 0;
            this.isDisabledTable = false;
            this.isDisabledUpload = false;
          });
      }
    },
    HandleCancel() {
      this.isOpenPopup = false;
    },
  },
};
</script>

<style scoped>
.popup-component {
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
.popup-content {
  font-family: Arial, Helvetica, sans-serif;
  background-color: #fff;
  padding: 0px;
  border-radius: 4px;
  width: 650px;
}
.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: black;
  color: white;
}
.title {
  flex: 1;
  height: 40px;
  padding-top: 10px;
  border-radius: 5px;
  font-weight: bold;
  text-align: left;
  padding-left: 10px;
}
.icon {
  cursor: pointer;
  margin-right: 10px;
}
.icon i {
  font-size: 20px;
  color: white;
}
.icon i:hover {
  font-size: 20px;
  color: #555;
}
.input {
  margin-top: 20px;
  border: 1px solid #ccc;
  width: 298px;
  height: 13px;
  border-radius: 3px;
  padding: 10px;
  font-size: 16px;
  color: #333;
  margin-bottom: 20px;
}
.input:focus {
  outline: none;
  border-color: #4caf50;
  box-shadow: 0 0 4px #4caf50;
}
.action {
  border: 1px solid none;
  margin-bottom: 15px;
  text-align: right;
}
.action .confirm,
.action .cancel {
  cursor: pointer;
  padding: 4px 15px;
  border: 2px solid lightgray;
  background-color: #fff;
  margin-right: 15px;
  border-radius: 5px;
}
.action .confirm:focus,
.action .cancel:focus {
  color: #fff;
  background-color: gray;
}
.open-popup {
  display: flex;
  border: 1px solid white;
  border-radius: 4px;
  height: 40px;
  /* font-family:Arial, Helvetica, sans-serif; */
  font-family: "Roboto", sans-serif;
  font-size: 14px;
  cursor: pointer;
  background-color: transparent;
  margin-bottom: 1px;
  text-align: center;
  align-items: center;
  justify-content: center;
  padding: 10px;
  margin-left: 20px;
  text-decoration: none;
}
.open-popup:hover {
  border: 1px solid #64b5f6;
  background-color: #e3f2fd;
  transition: all 0.3s ease;
}
.icon-open-popup {
  display: inline-block;
  width: 32px;
  height: 32px;
  background-image: url(../assets/new_file.png);
  background-size: cover;
  background-position: center;
  margin-right: 10px;
  border: 1px solid none;
}
.content {
  border: 1px solid none;
  margin-top: 20px;
  margin-bottom: 20px;
}
.tab-table {
  border: 2px solid lightgray;
  min-height: 435px;
  max-height: 435px;
  background-color: #fff;
  width: 600px;
  overflow-y: auto;
  margin-bottom: 20px;
  margin-left: 22px;
  margin-right: 22px;
}
.custom-table {
  width: 100%;
  border-collapse: collapse;
  height: 35px;
  table-layout: fixed;
}
.fix-header {
  position: sticky;
  top: 0;
  background-color: lightgray;
}
.custom-table th {
  padding: 8px;
  border: 1px solid #b5b5b5;
  height: 30px;
  text-align: center;
}
.custom-table tr,
.custom-table td {
  padding: 8px;
  border: 1px solid #b5b5b5;
  height: 20px;
}
.th-title {
  width: 460px;
}
.th-action {
  width: 60px;
}
.td-title {
  max-width: 400px; /* Chiều dài tối đa của thẻ td */
  white-space: nowrap; /* Ngăn không cho văn bản xuống dòng */
  overflow: hidden; /* Ẩn nội dung vượt quá chiều dài */
  text-overflow: ellipsis; /* Hiển thị dấu ... khi văn bản bị cắt */
  text-align: left; /* Canh lề bên trái cho văn bản */
}
.icon-action {
  cursor: pointer;
  margin-right: 10px;
  padding-left: 20px;
}
.icon-action i {
  font-size: 20px;
  color: red;
}
.icon-action i:hover {
  font-size: 20px;
  color: red;
}
.custom-input {
  visibility: hidden;
  position: absolute;
}
.custom-label {
  background-color: #e8e8e8;
  padding: 5px 10px;
  border: 1px solid grey;
  cursor: pointer;
  display: inline-block;
  border-radius: 4px;
  margin-left: 22px;
}
.custom-text {
  margin-left: 10px;
}
.custom-table.disabled {
  pointer-events: none;
  opacity: 0.5;
}
.progress-bar {
  margin-left: 20px;
  margin-top: 10px;
  width: 610px;
  background-color: lightgray;
  height: 30px;
  border-radius: 15px;
  overflow: hidden;
  position: relative;
  margin-bottom: 20px;
}
.progress-bar .progress {
  background-color: #4caf50;
  height: 100%;
  width: 80%;
  transform: width 0.5 ease-in-out;
}
</style>
