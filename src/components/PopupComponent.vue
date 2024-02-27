<template>
  <div v-if="isOpenPopup" class="popup-component">
    <div class="popup-content">
      <header>
        <div class="header">
          <div class="title">{{ $t("CreateFolder") }}</div>
          <div class="icon">
            <i class="fas fa-times close-icon" @click="HandleCancel"></i>
          </div>
        </div>
      </header>
      <input type="text" class="input" ref="inputValue" />
      <div class="action">
        <button class="confirm" @click="HandleConfirm">{{ $t("Create") }}</button>
        <button class="cancel" @click="HandleCancel">{{ $t("Cancel") }}</button>
      </div>
    </div>
  </div>
  <button
    v-if="this.$globalVariable.USER_INFO.admin == 1"
    @click="HandleOpenPopup"
    class="open-popup"
  >
    <i class="icon-open-popup"></i>{{ $t("NewFolder") }}
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
    };
  },
  methods: {
    HandleOpenPopup() {
      this.isOpenPopup = true;
    },
    HandleConfirm() {
      const name = this.$refs.inputValue.value;
      if (name === "") {
        console.log("Warning: Please input name of the folder");
      } else {
        const path = this.currentPath + "\\" + name;
        console.log("path: ", path);
        const apiUrl =
          this.$globalVariable.URL_API + "/WeatherForecast/create_directory/";
        axios
          .get(apiUrl, {
            params: {
              path: path,
            },
          })
          .then((response) => {
            console.log(response.data);
            if (response.data == "success") {
              console.log("Result create: Passed");
              this.isOpenPopup = false;
            } else {
              console.log("Result create: Failed");
            }
          })
          .catch((error) => {
            console.error(error);
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
  width: 350px;
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
  height: 35px;
  border-radius: 3px;
  padding: 10px;
  font-size: 16px;
  color: #333;
  margin-bottom: 20px;
  margin-left: 24px;
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
  transition: all 0.3s ease;
  margin-right: 15px;
  border-radius: 5px;
}
.action .confirm:hover,
.action .cancel:hover {
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
  width: 32px;
  height: 32px;
  background-image: url(../assets/new_folder_1.png);
  background-size: cover;
  background-position: center;
  margin-right: 10px;
  border: 1px solid none;
}
</style>
