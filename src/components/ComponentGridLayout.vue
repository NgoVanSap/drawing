<template>
  <div class="file-card">
    <div class="file-icon">
      <i :class="getFileIconClass(file.Extension)"></i>
    </div>
    <div class="content">
      <div class="file-general">
        <b>Title: </b>
        <a
          class="td-title-a"
          href="#"
          target="_blank"
          @click.left="handleLeftClick"
          @click.right="handleRightClick"
          @mouseover="showCellContent($event, file.FullName)"
          @mouseout="hideCellContent"
          @contextmenu="showMenu($event, file.Name, file.FullName)"
          v-html="highlightText(file.Name)"
        >
        </a>
        <menu-component
          v-if="menuVisible"
          :x="menuX"
          :y="menuY"
          :name="fileNameSelected"
          :path="filePathSelected"
          v-on:handlePreview="handlePreview"
          v-on:handleDownload="handleDownload"
        ></menu-component>
        <popup-hover-file
          v-if="showContent"
          :x="menuX"
          :y="menuY"
          :name="pathFileHover"
        ></popup-hover-file>
      </div>
      <div class="file-general file-last-check-in">
        <b>{{ $t("DateAccessed") }}:</b> {{ file.LastAccessTime }}
      </div>
      <div class="file-general file-size">
        <b>{{ $t("Size") }}:</b> {{ file.Length }}
      </div>
    </div>
  </div>
</template>

<script>
import MenuComponent from "./MenuComponent.vue";
import PopupHoverFile from "./PopupHoverFile.vue";
export default {
  props: {
    file: Object,
    menuVisible: {
      type: Boolean,
      required: true,
      default: false,
    },
  },
  components: {
    MenuComponent,
    PopupHoverFile,
  },
  data() {
    return {
      showContent: false,
      menuX: 0,
      menuY: 0,
      fileNameSelected: "",
      filePathSelected: "",
      pathFileHover: "",
    };
  },
  methods: {
    getFileIconClass(extension) {
      var value = extension.toLowerCase();
      switch (value) {
        case ".pdf":
          return "icon_pdf";
        case ".dwg":
          return "icon_dwg";
        case ".doc":
        case ".docx":
          return "icon_word";
        case ".xls":
        case ".xlsx":
          return "icon_excel";
        case ".ppt":
        case ".pptx":
          return "icon_powerpoint";
        case ".jpg":
        case ".jpeg":
        case ".png":
          return "icon_image";
        case ".rar":
        case ".zip":
          return "icon_winrar";
        case ".directory":
          return "icon_directory";
        default:
          return "icon_file";
      }
    },
    showMenu(event, name, path) {
      console.log("[GridLayout] showMenu");
      console.log("[showMenu] menuVisible: ", this.menuVisible);
      this.fileNameSelected = name;
      this.filePathSelected = path;
      this.menuX = event.clientX;
      this.menuY = event.clientY;
      this.showContent = false;

      event.preventDefault();
      this.$emit("signal_show_menu", {
        fileNameSelected: this.fileNameSelected,
        filePathSelected: this.filePathSelected,
        menuX: this.menuX,
        menuY: this.menuY,
      });
    },
    handleLeftClick(event) {
      event.preventDefault();
    },
    handleRightClick(event) {
      console.log("[handleRightClick] [ComponentsGridLayout] Event: ", event);
    },
    handlePreview() {
      this.$emit("signal_preview");
    },
    handleDownload() {
      this.$emit("signal_download");
    },
    showCellContent(event, name) {
      console.log("[showCellContent] Name 123: ", name);
      if (this.$globalVariable.RUNNING_DOCKER) {
        this.pathFileHover = name.replace("/Data/Data/", "").replace("W:\\", "");
      } else {
        this.pathFileHover = name
          .replace(this.$globalVariable.DIR_DATA_E, "")
          .replace("W:\\", "");
      }
      this.menuX = event.clientX;
      this.menuY = event.clientY;
      this.showContent = true;
    },
    hideCellContent() {
      this.showContent = false;
    },
    highlightText(text) {
      if (this.$globalVariable.SEARCH_TEXT) {
        const regex = new RegExp(this.$globalVariable.SEARCH_TEXT, "gi");
        const text_tmp = text.replace(
          regex,
          (match) => `<span style="background-color: yellow;">${match}</span>`
        );
        return text_tmp;
      }
      return text;
    },
  },
};
</script>

<style scoped>
.file-card {
  position: relative;
  display: flex;
  flex-direction: row;
  border: 1px solid transparent;
  padding: 10px;
  text-align: center;
  margin: 10px;
  background-color: #f2f2f2;
  border-radius: 10px;
  justify-self: center;
  width: 95%;
  height: 90px;
}

.file-icon {
  border: 1px solid transparent;
  width: 60px;
  height: 60px;
}

.content {
  display: flex;
  flex-direction: column;
  border: 1px solid transparent;
  margin-left: 10px;
  text-align: left;
  width: calc(100% - 60px);
}

.file-general {
  flex: 1;
  padding-left: 10px;
  padding-right: 10px;
  border: 1px solid transparent;
  white-space: nowrap;
  text-overflow: ellipsis;
  overflow: hidden;
  height: 50px;
  max-width: 350px;
}

.icon_pdf {
  display: inline-block;
  width: 60px;
  height: 60px;
  background-image: url(../assets/images/offices/pdf-file.png);
  background-size: cover;
  margin-right: 10px;
}

.icon_dwg {
  display: inline-block;
  width: 60px;
  height: 60px;
  background-image: url(../assets/images/offices/dwg.png);
  background-size: cover;
  margin-right: 10px;
}

.icon_image {
  display: inline-block;
  width: 60px;
  height: 60px;
  background-image: url(../assets/images/offices/photo.png);
  background-size: cover;
  margin-right: 10px;
}

.icon_word {
  display: inline-block;
  width: 60px;
  height: 60px;
  background-image: url(../assets/images/offices/word.png);
  background-size: cover;
  margin-right: 10px;
}

.icon_excel {
  display: inline-block;
  width: 60px;
  height: 60px;
  background-image: url(../assets/images/offices/excel.png);
  background-size: cover;
  margin-right: 10px;
}

.icon_powerpoint {
  display: inline-block;
  width: 60px;
  height: 60px;
  background-image: url(../assets/images/offices/powerpoint.png);
  background-size: cover;
  margin-right: 10px;
}

.icon_file {
  display: inline-block;
  width: 60px;
  height: 60px;
  background-image: url(../assets/images/offices/file.png);
  background-size: cover;
  margin-right: 10px;
}

.icon_winrar {
  display: inline-block;
  width: 60px;
  height: 60px;
  background-image: url(../assets/images/offices/winrar.png);
  background-size: cover;
  margin-right: 10px;
}

.icon_directory {
  display: inline-block;
  width: 60px;
  height: 60px;
  background-image: url(../assets/images/offices/directory.png);
  background-size: cover;
  margin-right: 10px;
}

.td-title-a {
  text-decoration: none;
  color: #1874cd;
  white-space: nowrap;
  /* Ngăn không cho văn bản xuống dòng */
  text-overflow: ellipsis;
  /* Hiển thị dấu ... khi văn bản bị cắt */
  overflow: hidden;
  /* Ẩn nội dung vượt quá chiều dài */
  border: none;
  /* max-width: 450px; */
}

@media screen and (max-width: 1800px) {
  .file-general {
    flex: 1;
    padding-left: 10px;
    padding-right: 10px;
    border: 1px solid transparent;
    height: 50px;
    max-width: 350px;
  }
}

@media screen and (max-width: 1200px) {
  .file-general {
    flex: 1;
    padding-left: 10px;
    padding-right: 10px;
    border: 1px solid transparent;
    height: 50px;
    max-width: 650px;
  }
}
</style>
