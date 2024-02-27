<template>
  <div class="main-ui">
    <div class="main-content">
      <div class="top-ui">
        <div class="top-title">{{ $t("Upload") }}</div>
        <div class="top-icon">
          <i class="fas fa-times close-icon" @click="handleClose"></i>
        </div>
      </div>
      <div class="center-ui">
        <table class="table-content">
          <thead>
            <tr>
              <th class="fix-header th-no">{{ $t("No") }}</th>
              <th class="fix-header th-title">{{ $t("Title") }}</th>
              <th class="fix-header th-action">{{ $t("Action") }}</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(upload, index) in listDropFiles" :key="index">
              <td class="td-no">{{ upload.id }}</td>
              <td class="progress-bar-cell">
                <div class="progress-bar">
                  <div
                    v-if="!upload.isFinished"
                    class="progress"
                    :style="{ width: upload.uploadPercent + '%' }"
                  ></div>
                  <div class="progress-text">{{ upload.fileName }}</div>
                </div>
              </td>

              <td class="td-action">
                <div class="icon-action">
                  <i
                    v-if="!upload.isCancel && upload.isResult == 'waiting'"
                    class="fa-solid fa-xmark"
                    style="color: red"
                  ></i>
                  <i
                    v-if="upload.isResult == 'success'"
                    class="fa-solid fa-check"
                    style="color: #12c448"
                  ></i>
                  <i
                    v-if="
                      (upload.isCancel && upload.isResult == 'waiting') ||
                      upload.isResult == 'error'
                    "
                    class="fa-solid fa-triangle-exclamation"
                    style="color: red"
                  ></i>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="bottom-ui">
        <div class="bottom-cancel">
          <v-btn
            class="button"
            @click="handleCancel"
            style="font-family: 'Poppins', sans-serif"
            >{{ OptionButton }}</v-btn
          >
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "component-drop-files",
  components: {},
  props: {
    pathToUpload: {
      type: String,
      default: "",
    },
    isActiveMainUI: {
      type: Boolean,
      default: false,
    },
    listDropFiles: {
      type: Array,
      request: true,
    },
    OptionButton: {
      type: String,
      default: "Cancel",
    },
  },
  data() {
    return {
      uploadPercent: 10,
      downloadBackground: "linear-gradient(to right, #00ff00 50%, #ffffff 10%)",
      uploads: [
        {
          id: 1,
          fileName: "File 1.txt",
          uploadPercent: 10,
        },
        {
          id: 2,
          fileName: "File 2.png",
          uploadPercent: 0,
        },
        {
          id: 3,
          fileName: "File 3.doc",
          uploadPercent: 50,
        },
        {
          id: 4,
          fileName: "File 4.pdf",
          uploadPercent: 100,
        },
        {
          id: 5,
          fileName: "File 5.jpg",
          uploadPercent: 100,
        },
      ],
    };
  },
  methods: {
    handleClose() {
      this.$emit("signalClose");
    },
    handleCancel() {
      this.$emit("signalCancel");
    },
  },
  computed: {},
  watch: {},
  mounted() {},
};
</script>

<style scoped>
@import "@mdi/font/css/materialdesignicons.min.css";

/* CSS to MAIN */
.main-ui {
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

.main-content {
  font-family: Arial, Helvetica, sans-serif;
  background-color: #fff;
  padding: 0px;
  border-radius: 4px;
  width: 650px;
}

/* CSS to TOP */
.top-ui {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background-color: black;
  border: none;
  padding-right: 5px;
  color: #fff;
}

.top-title {
  flex: 1;
  height: 40px;
  padding-top: 10px;
  border-radius: 5px;
  font-weight: bold;
  text-align: left;
  padding-left: 10px;
}

.top-icon {
  display: flex;
  align-items: center;
  cursor: pointer;
  margin-right: 10px;
  color: #fff;
}

.top-icon i {
  font-size: 20px;
  color: #fff;
}

.top-icon i:hover {
  font-size: 20px;
  color: #747070;
}
/* CSS to CENTER */
.center-ui {
  padding: 2px;
  border: none;
  min-height: 35px;
  max-height: 435px;
  background-color: #fff;
  width: 100%;
  overflow-y: auto;
}

.table-content {
  width: 100%;
  border-collapse: collapse;
  height: 35px;
  table-layout: fixed;
}

.fix-header {
  position: sticky;
  top: 0;
}

.table-content th {
  padding: 8px;
  border: 1px solid #b5b5b5;
  height: 30px;
  text-align: center;
}

.table-content tr,
.table-content td {
  padding: 8px;
  border: 1px solid #b5b5b5;
  height: 40px;
}

.th-no {
  width: 50px;
}

.th-title {
  width: 460px;
}

.th-action {
  width: 70px;
}

.td-no {
  text-align: center;
}

.td-title {
  max-width: 400px;
  /* Chiều dài tối đa của thẻ td */
  white-space: nowrap;
  /* Ngăn không cho văn bản xuống dòng */
  overflow: hidden;
  /* Ẩn nội dung vượt quá chiều dài */
  text-overflow: ellipsis;
  /* Hiển thị dấu ... khi văn bản bị cắt */
  text-align: left;
  /* Canh lề bên trái cho văn bản */
}

.td-action {
  cursor: pointer;
  padding-left: 40px;
  text-align: center;
}

.icon-action {
  border: none;
}

.icon-action i {
  font-size: 20px;
  color: red;
}

.icon-action i:hover {
  font-size: 20px;
  color: red;
}

.circle-content {
  width: 40px;
  height: 40px;
  background-color: #f39c12;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 15px;
  color: white;
}

/* CSS to BOTTOM */
.bottom-ui {
  border: none;
  align-items: center;
  justify-content: center;
}

.bottom-cancel {
  border: none;
  align-items: center;
  justify-content: center;
  text-align: center;
  margin: 10px;
}

.progress-bar-cell {
  position: relative;
  width: 150px;
  height: 30px;
}

.progress-bar {
  width: 100%;
  height: 35px;
  border: none;
  border-radius: 10px;
  overflow: hidden;
}

.progress {
  width: 0;
  height: 100%;
  background-color: #4fc3f7;
  transition: width 0.3s ease;
}

.progress-text {
  position: absolute;
  padding-left: 20px;
  max-width: 480px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  text-align: left;
}
</style>
