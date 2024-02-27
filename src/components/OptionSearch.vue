<template>
  <div class="main">
    <input
      type="text"
      class="input"
      v-bind:class="{ disabled: active_icon_loading }"
      ref="inputValue"
    />
    <button @click="HandleSearch" class="open-popup">
      <i v-if="!active_icon_loading" class="icon-open-popup"></i
      ><i v-if="active_icon_loading" class="icon_loading"></i>{{ $t("Search") }}
    </button>
  </div>
</template>

<script>
import axios from "axios";
export default {
  name: "option-search",
  props: {
    active_icon_loading: {
      type: Boolean,
      default: false,
    },
  },
  data() {
    return {};
  },
  methods: {
    HandleSearch() {
      const value = this.$refs.inputValue.value;
      this.$globalVariable.SEARCH_TEXT = value;
      console.log("HandleSearch: ", value);
      if (value == "") {
        console.log("Warning: Please input value");
      } else {
        console.log("Info: Searching ...");
        this.$emit("signalClearDataTable");

        var path_data = "E:\\Drive_W\\Data";
        if (this.$globalVariable.RUNNING_DOCKER) {
          path_data = "/Data/Data";
        }

        const jsonData = {
          name: value,
          path: path_data,
          userID: this.$globalVariable.USER_INFO.userID,
          jobID: this.$globalVariable.USER_INFO.jobID,
          areaID: this.$globalVariable.USER_INFO.areaID,
          admin: this.$globalVariable.USER_INFO.admin,
        };

        const jsonString = JSON.stringify(jsonData);
        console.log("jsonData: ", jsonData);
        console.log("jsonString: ", jsonString);
        axios
          .post(this.$globalVariable.URL_API + "/Files/search_file/", jsonString, {
            headers: {
              "Content-Type": "application/json",
            },
          })
          .then((response) => {
            console.log("[HandleSearch] Response Data: ", response.data);
            this.processResponse(response.data);
          })
          .catch((error) => {
            console.error(error);
          });
      }
    },
    processResponse(jsonString) {
      try {
        console.log("[processResponse] Json String Search: ", jsonString);
        console.log("path: ", jsonString.path);
        console.log("dataDirectories: ", jsonString.dataDirectories.length);
        for (let i = 0; i < jsonString.dataDirectories.length; i++) {
          const directory = jsonString.dataDirectories[i];
          console.log("\t directory: ", directory);
          const id = directory["id"];
          const Name = directory["Name"];
          console.log("\t\t id: ", id);
          console.log("\t\t Name: ", Name);
        }
        console.log("dataFiles: ", jsonString.dataFiles.length);
        for (let i = 0; i < jsonString.dataFiles.length; i++) {
          const file = jsonString.dataFiles[i];
          console.log("\t file: ", file);
          const id = file["id"];
          const Name = file["Name"];
          const Data = file["Data"];
          console.log("\t\t id: ", id);
          console.log("\t\t Name: ", Name);
          console.log("\t\t Data: ", Data);
          const detail_Name = Data["Name"];
          const detail_LastWriteTime = Data["LastWriteTime"];
          const detail_CreationTime = Data["CreationTime"];
          const detail_DirectoryName = Data["DirectoryName"];
          const detail_Extension = Data["Extension"];
          const detail_IsReadOnly = Data["IsReadOnly"];
          const detail_LastAccessTime = Data["LastAccessTime"];
          const detail_Length = Data["Length"];
          console.log("\t\t\t detail_Name: ", detail_Name);
          console.log("\t\t\t detail_LastWriteTime: ", detail_LastWriteTime);
          console.log("\t\t\t detail_CreationTime: ", detail_CreationTime);
          console.log("\t\t\t detail_DirectoryName: ", detail_DirectoryName);
          console.log("\t\t\t detail_Extension: ", detail_Extension);
          console.log("\t\t\t detail_IsReadOnly: ", detail_IsReadOnly);
          console.log("\t\t\t detail_LastAccessTime: ", detail_LastAccessTime);
          console.log("\t\t\t detail_Length: ", detail_Length);
        }
      } catch (error) {
        console.log("error: ", error);
        jsonString = "";
      }
      this.$emit("signalReloadDataSearch", {
        dataResponse: jsonString,
      });
    },
  },
};
</script>

<style scoped>
.main {
  border: 1px solid transparent;
  display: flex;
  float: right;
  padding-right: 20px;
}

.input {
  border: 1px solid #ccc;
  width: 400px;
  height: 35px;
  border-radius: 20px;
  padding: 10px;
  padding-left: 20px;
  padding-right: 20px;
  font-size: 14px;
  color: #333;
  margin-top: 3px;
  margin-bottom: 25px;
  margin-left: 16px;
  margin-right: 10px;
  background-color: #fff;
}

.input:focus {
  outline: none;
  border-color: #4caf50;
  box-shadow: 0 0 4px #4caf50;
}

.input.disabled {
  pointer-events: none;
  /* vô hiệu hóa tương tác với thẻ input khi bị disable */
  opacity: 0.9;
  /* giảm độ sáng cho thẻ input khi bị disable */
  background-color: bisque;
}

.open-popup {
  display: flex;
  border: 1px solid white;
  border-radius: 4px;
  height: 40px;
  /* font-family: Arial, Helvetica, sans-serif; */
  font-family: "Roboto", sans-serif;
  font-size: 14px;
  cursor: pointer;
  background-color: transparent;
  margin-bottom: 1px;
  text-align: center;
  align-items: center;
  justify-content: center;
  padding: 10px;
  margin-right: 10px;
  text-decoration: none;
}

.open-popup:hover {
  border: 1px solid #64b5f6;
  background-color: #e3f2fd;
  transition: all 0.3s ease;
}

.icon-open-popup {
  display: inline-block;
  width: 24px;
  height: 24px;
  background-image: url(../assets/search.png);
  background-size: cover;
  background-position: center;
  margin-right: 10px;
  border: 1px solid transparent;
}

.icon_loading {
  width: 24px;
  height: 24px;
  border: 1px solid none;
  background: transparent;
  color: #333;
  background-image: url("../assets/loading.gif");
  background-size: 24px;
  font-size: 24px;
  background-repeat: no-repeat;
  background-color: rgba(0, 0, 0, 0);
  margin-right: 10px;
}
</style>
